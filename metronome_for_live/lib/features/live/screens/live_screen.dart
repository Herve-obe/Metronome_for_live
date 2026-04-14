import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/enums.dart';
import '../../../core/providers/playback_provider.dart';

/// Page Live — Lecture séquentielle des blocs d'un morceau.
class LiveScreen extends ConsumerWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pb = ref.watch(playbackProvider);
    final notifier = ref.read(playbackProvider.notifier);
    final block = pb.currentBlock;

    return Scaffold(
      appBar: AppBar(
        title: Text(pb.songName ?? 'Live'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: pb.blocks.isEmpty
          ? _EmptyState()
          : SafeArea(
              child: Column(
                children: [
                  // ─── Block timeline (scrollable) ──────────────
                  _BlockTimeline(
                    blocks: pb.blocks,
                    currentIndex: pb.currentBlockIndex,
                    isPlaying: pb.isPlaying,
                    onTap: (i) => notifier.jumpToBlock(i),
                  ),

                  const Divider(height: 1),

                  // ─── Main content ─────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          // ─── Block name ─────────────────────────
                          if (block != null) ...[
                            Text(
                              block.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Mesure ${pb.currentMeasure + 1}'
                              '${block.measureCount > 0 ? " / ${block.measureCount}" : ""}',
                              style: const TextStyle(
                                color: AppColors.textDim,
                                fontSize: 13,
                              ),
                            ),
                          ],

                          const SizedBox(height: 12),

                          // ─── Info bar ───────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Signature
                              _InfoChip(
                                label: 'T.S.',
                                value: block != null
                                    ? '${block.numerator}/${block.denominator}'
                                    : '4/4',
                              ),

                              // BPM
                              Column(
                                children: [
                                  const Text('BPM',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textDim)),
                                  Text(
                                    '${block?.bpm ?? 120}',
                                    style: const TextStyle(
                                      fontSize: 56,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accent,
                                      letterSpacing: -2,
                                      height: 1.1,
                                    ),
                                  ),
                                  Text(
                                    TempoName.fromBpm(block?.bpm ?? 120),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textDim,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),

                              // Loop indicator
                              _LoopIndicator(
                                isLooping: pb.isLooping,
                                countdown: pb.loopCountdown,
                              ),
                            ],
                          ),

                          const Spacer(),

                          // ─── Beat dots ──────────────────────────
                          _BeatDots(
                            numerator: block?.numerator ?? 4,
                            currentBeat: pb.currentBeat,
                            isPlaying: pb.isPlaying,
                          ),

                          const SizedBox(height: 32),

                          // ─── Transport controls ─────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Prev
                              _TransportButton(
                                icon: Icons.skip_previous_rounded,
                                enabled: pb.hasPrevBlock,
                                onTap: () => notifier.prevBlock(),
                              ),
                              const SizedBox(width: 20),

                              // Play / Pause
                              GestureDetector(
                                onTap: () => notifier.togglePlayback(),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surface,
                                    border: Border.all(
                                      color: pb.isPlaying
                                          ? AppColors.accent
                                          : AppColors.surfaceBorder,
                                      width: 3,
                                    ),
                                    boxShadow: pb.isPlaying
                                        ? [
                                            BoxShadow(
                                              color: AppColors.accent
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 24,
                                              spreadRadius: 4,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Icon(
                                    pb.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 48,
                                    color: pb.isPlaying
                                        ? AppColors.accent
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Next
                              _TransportButton(
                                icon: Icons.skip_next_rounded,
                                enabled: pb.hasNextBlock,
                                onTap: () => notifier.nextBlock(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ─── Loop button ────────────────────────
                          GestureDetector(
                            onTap: () => notifier.toggleLoop(),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 12),
                              decoration: BoxDecoration(
                                color: pb.isLooping
                                    ? AppColors.accentDim
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: pb.isLooping
                                      ? AppColors.accent
                                      : AppColors.surfaceBorder,
                                  width: pb.isLooping ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.loop_rounded,
                                    color: pb.isLooping
                                        ? AppColors.accent
                                        : AppColors.textDim,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    pb.loopCountdown != null
                                        ? 'SORTIE (${pb.loopCountdown})'
                                        : pb.isLooping
                                            ? 'LOOP ACTIF'
                                            : 'LOOP',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: pb.isLooping
                                          ? AppColors.accent
                                          : AppColors.textDim,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// WIDGETS INTERNES
// ═══════════════════════════════════════════════════════════════

/// État vide quand aucun morceau n'est chargé.
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_off_outlined,
              size: 80, color: AppColors.textDim.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('Aucun morceau chargé',
              style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          const Text(
            'Allez dans Edit pour créer un morceau\npuis appuyez sur ▶ pour le lire ici',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textDim),
          ),
        ],
      ),
    );
  }
}

/// Timeline horizontale des blocs.
class _BlockTimeline extends StatelessWidget {
  final List blocks;
  final int currentIndex;
  final bool isPlaying;
  final void Function(int) onTap;

  const _BlockTimeline({
    required this.blocks,
    required this.currentIndex,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: blocks.length,
        itemBuilder: (context, index) {
          final block = blocks[index];
          final isCurrent = index == currentIndex;
          final isPast = index < currentIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.accentDim
                    : isPast
                        ? AppColors.surface.withValues(alpha: 0.5)
                        : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCurrent
                      ? AppColors.accent
                      : AppColors.surfaceBorder,
                  width: isCurrent ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    block.name,
                    style: TextStyle(
                      color: isCurrent
                          ? AppColors.accent
                          : isPast
                              ? AppColors.textDim
                              : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${block.bpm} · ${block.numerator}/${block.denominator}',
                    style: TextStyle(
                      color: isCurrent
                          ? AppColors.accent.withValues(alpha: 0.7)
                          : AppColors.textDim,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Indicateur de beat dots.
class _BeatDots extends StatelessWidget {
  final int numerator;
  final int currentBeat;
  final bool isPlaying;

  const _BeatDots({
    required this.numerator,
    required this.currentBeat,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numerator, (index) {
        final isActive = isPlaying && index == currentBeat;
        final isFirst = index == 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            width: isActive ? 28 : 16,
            height: isActive ? 28 : 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? (isFirst ? AppColors.accent : AppColors.beatNormal)
                  : AppColors.beatInactive,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: (isFirst
                                ? AppColors.accent
                                : AppColors.beatNormal)
                            .withValues(alpha: 0.6),
                        blurRadius: 16,
                        spreadRadius: 3,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}

/// Chip d'info (signature, etc.).
class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 10, color: AppColors.textDim)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              )),
        ],
      ),
    );
  }
}

/// Indicateur de loop.
class _LoopIndicator extends StatelessWidget {
  final bool isLooping;
  final int? countdown;

  const _LoopIndicator({required this.isLooping, this.countdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isLooping ? AppColors.accentDim : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLooping ? AppColors.accent : AppColors.surfaceBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.loop_rounded,
            size: 18,
            color: isLooping ? AppColors.accent : AppColors.textDim,
          ),
          const SizedBox(height: 2),
          Text(
            countdown != null ? '$countdown' : isLooping ? 'ON' : 'OFF',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isLooping ? AppColors.accent : AppColors.textDim,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bouton de transport (prev/next).
class _TransportButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _TransportButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Icon(
          icon,
          size: 32,
          color: enabled ? AppColors.textPrimary : AppColors.textDim,
        ),
      ),
    );
  }
}
