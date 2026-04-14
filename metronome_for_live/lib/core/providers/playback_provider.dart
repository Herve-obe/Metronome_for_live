import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../audio/audio_engine.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';

/// État complet de la lecture d'un morceau.
class PlaybackState {
  final bool isPlaying;
  final bool isLooping;
  final String? songId;
  final String? songName;
  final List<TempoBlock> blocks;
  final int currentBlockIndex;
  final int currentBeat;
  final int currentMeasure;
  final int? loopCountdown; // mesures restantes avant fin du loop

  const PlaybackState({
    this.isPlaying = false,
    this.isLooping = false,
    this.songId,
    this.songName,
    this.blocks = const [],
    this.currentBlockIndex = 0,
    this.currentBeat = 0,
    this.currentMeasure = 0,
    this.loopCountdown,
  });

  TempoBlock? get currentBlock =>
      blocks.isNotEmpty && currentBlockIndex < blocks.length
          ? blocks[currentBlockIndex]
          : null;

  bool get hasNextBlock => currentBlockIndex < blocks.length - 1;
  bool get hasPrevBlock => currentBlockIndex > 0;

  /// Progression dans le morceau (0.0 → 1.0).
  double get songProgress {
    if (blocks.isEmpty) return 0;
    return (currentBlockIndex + 1) / blocks.length;
  }

  PlaybackState copyWith({
    bool? isPlaying,
    bool? isLooping,
    String? songId,
    String? songName,
    List<TempoBlock>? blocks,
    int? currentBlockIndex,
    int? currentBeat,
    int? currentMeasure,
    int? Function()? loopCountdown,
  }) {
    return PlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLooping: isLooping ?? this.isLooping,
      songId: songId ?? this.songId,
      songName: songName ?? this.songName,
      blocks: blocks ?? this.blocks,
      currentBlockIndex: currentBlockIndex ?? this.currentBlockIndex,
      currentBeat: currentBeat ?? this.currentBeat,
      currentMeasure: currentMeasure ?? this.currentMeasure,
      loopCountdown:
          loopCountdown != null ? loopCountdown() : this.loopCountdown,
    );
  }
}

/// Provider pour la lecture séquentielle des blocs d'un morceau.
class PlaybackNotifier extends StateNotifier<PlaybackState> {
  final AudioEngine _engine;
  final AppDatabase _db;
  bool _initialized = false;

  /// Nombre de mesures de décompte avant la fin de loop (configurable).
  int loopExitMeasures = 2;

  PlaybackNotifier(this._engine, this._db) : super(const PlaybackState());

  Future<void> _ensureInit() async {
    if (!_initialized) {
      await _engine.init();
      _initialized = true;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // CHARGER UN MORCEAU
  // ═══════════════════════════════════════════════════════════

  /// Charge un morceau et ses blocs pour la lecture.
  Future<void> loadSong(String songId) async {
    await _ensureInit();

    // Arrêter la lecture en cours
    if (state.isPlaying) {
      await _engine.stop();
    }

    // Charger les blocs depuis la DB
    final blocks = await _db.getBlocksForSong(songId);

    // Récupérer le nom du morceau
    // (on le récupère via les blocs, pas idéal mais suffisant pour le MVP)
    String songName = 'Morceau';
    try {
      final songs = await _db.getSongsForSetlist(''); // won't work
      songName = songs.firstWhere((s) => s.id == songId).name;
    } catch (_) {
      // Fallback
    }

    state = PlaybackState(
      songId: songId,
      songName: songName,
      blocks: blocks,
      currentBlockIndex: 0,
    );
  }

  /// Charge un morceau avec son nom directement.
  Future<void> loadSongWithName(
      String songId, String songName) async {
    await _ensureInit();

    if (state.isPlaying) {
      await _engine.stop();
    }

    final blocks = await _db.getBlocksForSong(songId);

    state = PlaybackState(
      songId: songId,
      songName: songName,
      blocks: blocks,
      currentBlockIndex: 0,
    );
  }

  // ═══════════════════════════════════════════════════════════
  // CONTRÔLES DE LECTURE
  // ═══════════════════════════════════════════════════════════

  /// Play / Pause.
  Future<void> togglePlayback() async {
    await _ensureInit();

    if (state.isPlaying) {
      await _engine.stop();
      state = state.copyWith(
        isPlaying: false,
        currentBeat: 0,
        currentMeasure: 0,
        isLooping: false,
        loopCountdown: () => null,
      );
    } else {
      await _startCurrentBlock();
    }
  }

  /// Passe au bloc suivant.
  Future<void> nextBlock() async {
    if (!state.hasNextBlock) return;

    final wasPlaying = state.isPlaying;
    if (wasPlaying) await _engine.stop();

    state = state.copyWith(
      currentBlockIndex: state.currentBlockIndex + 1,
      currentBeat: 0,
      currentMeasure: 0,
      isLooping: false,
      loopCountdown: () => null,
    );

    if (wasPlaying) await _startCurrentBlock();
  }

  /// Revient au bloc précédent.
  Future<void> prevBlock() async {
    if (!state.hasPrevBlock) return;

    final wasPlaying = state.isPlaying;
    if (wasPlaying) await _engine.stop();

    state = state.copyWith(
      currentBlockIndex: state.currentBlockIndex - 1,
      currentBeat: 0,
      currentMeasure: 0,
      isLooping: false,
      loopCountdown: () => null,
    );

    if (wasPlaying) await _startCurrentBlock();
  }

  /// Saute à un bloc spécifique.
  Future<void> jumpToBlock(int index) async {
    if (index < 0 || index >= state.blocks.length) return;

    final wasPlaying = state.isPlaying;
    if (wasPlaying) await _engine.stop();

    state = state.copyWith(
      currentBlockIndex: index,
      currentBeat: 0,
      currentMeasure: 0,
      isLooping: false,
      loopCountdown: () => null,
    );

    if (wasPlaying) await _startCurrentBlock();
  }

  // ═══════════════════════════════════════════════════════════
  // LOOP
  // ═══════════════════════════════════════════════════════════

  /// Active/désactive le loop sur le bloc actuel.
  /// - 1er appui : le bloc se répète indéfiniment.
  /// - 2e appui : un décompte de [loopExitMeasures] mesures commence,
  ///   puis le bloc suivant s'enchaîne automatiquement.
  void toggleLoop() {
    if (!state.isPlaying) return;

    if (!state.isLooping) {
      // Activer le loop
      state = state.copyWith(
        isLooping: true,
        loopCountdown: () => null,
      );
    } else {
      // Désactiver le loop avec décompte
      state = state.copyWith(
        loopCountdown: () => loopExitMeasures,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // LECTURE INTERNE
  // ═══════════════════════════════════════════════════════════

  /// Démarre la lecture du bloc courant.
  Future<void> _startCurrentBlock() async {
    final block = state.currentBlock;
    if (block == null) return;

    // Setup callbacks
    _engine.onBeat = (beatIndex, measureIndex) {
      if (!mounted) return;

      state = state.copyWith(
        currentBeat: beatIndex,
        currentMeasure: measureIndex,
      );

      // Gestion du décompte de sortie de loop
      if (state.loopCountdown != null && state.loopCountdown! > 0) {
        if (beatIndex == 0) {
          final newCountdown = state.loopCountdown! - 1;
          if (newCountdown <= 0) {
            // Fin du loop → bloc suivant
            _onBlockFinished();
          } else {
            state = state.copyWith(loopCountdown: () => newCountdown);
          }
        }
      }
    };

    _engine.onBlockFinished = () {
      if (!mounted) return;
      _onBlockFinished();
    };

    // Détermine si le bloc est infini (loop actif OU measureCount == 0)
    final effectiveMeasureCount =
        state.isLooping ? 0 : block.measureCount;

    await _engine.start(
      bpm: block.bpm,
      numerator: block.numerator,
      denominator: block.denominator,
      subdivision: block.subdivision,
      measureCount: effectiveMeasureCount,
      volume: block.volume,
      accentSound: block.accentSound,
      normalSound: block.normalSound,
      subdivisionSound: block.subdivisionSound,
    );

    state = state.copyWith(isPlaying: true);
  }

  /// Appelé quand un bloc est terminé.
  void _onBlockFinished() {
    if (state.isLooping && state.loopCountdown == null) {
      // Loop actif sans décompte → on relance le même bloc
      _startCurrentBlock();
      return;
    }

    // Passer au bloc suivant
    if (state.hasNextBlock) {
      state = state.copyWith(
        currentBlockIndex: state.currentBlockIndex + 1,
        currentBeat: 0,
        currentMeasure: 0,
        isLooping: false,
        loopCountdown: () => null,
      );
      _startCurrentBlock();
    } else {
      // Fin du morceau
      state = state.copyWith(
        isPlaying: false,
        currentBeat: 0,
        currentMeasure: 0,
        isLooping: false,
        loopCountdown: () => null,
      );
    }
  }

  /// Stop et reset.
  Future<void> stop() async {
    await _engine.stop();
    state = state.copyWith(
      isPlaying: false,
      currentBeat: 0,
      currentMeasure: 0,
      currentBlockIndex: 0,
      isLooping: false,
      loopCountdown: () => null,
    );
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }
}

/// Provider global de la lecture.
final playbackProvider =
    StateNotifierProvider<PlaybackNotifier, PlaybackState>((ref) {
  final db = ref.watch(databaseProvider);
  return PlaybackNotifier(AudioEngine.instance, db);
});
