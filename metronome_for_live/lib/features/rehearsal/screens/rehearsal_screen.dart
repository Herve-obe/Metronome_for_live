import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/enums.dart';
import '../../../core/providers/playback_provider.dart';

/// Page Rehearsal — Mode répétition avec édition rapide des blocs.
/// Plus de contrôles que Live : modification du BPM,
/// de la signature et du nombre de mesures directement.
class RehearsalScreen extends ConsumerWidget {
  const RehearsalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pb = ref.watch(playbackProvider);
    final notifier = ref.read(playbackProvider.notifier);
    final block = pb.currentBlock;

    return Scaffold(
      appBar: AppBar(
        title: Text(pb.songName ?? 'Rehearsal'),
        centerTitle: true,
      ),
      body: pb.blocks.isEmpty
          ? _EmptyState()
          : SafeArea(
              child: Column(
                children: [
                  // ─── Block selector ───────────────────────
                  _BlockSelector(
                    blocks: pb.blocks,
                    currentIndex: pb.currentBlockIndex,
                    onTap: (i) => notifier.jumpToBlock(i),
                  ),
                  const Divider(height: 1),

                  // ─── Main content ─────────────────────────
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        if (block != null) ...[
                          // ─── Block name & status ──────────
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  block.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                              if (pb.isPlaying)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentDim,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Mesure ${pb.currentMeasure + 1}'
                                    '${block.measureCount > 0 ? " / ${block.measureCount}" : ""}',
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ─── BPM ──────────────────────────
                          _SectionTitle('TEMPO'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // BPM display
                              Text(
                                '${block.bpm}',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('BPM',
                                      style: TextStyle(
                                          color: AppColors.textDim,
                                          fontSize: 12)),
                                  Text(
                                    TempoName.fromBpm(block.bpm),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ─── Signature ────────────────────
                          _SectionTitle('SIGNATURE'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${block.numerator} / ${block.denominator}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                block.measureCount == 0
                                    ? '∞ mesures'
                                    : '${block.measureCount} mesures',
                                style: const TextStyle(
                                  color: AppColors.textDim,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ─── Subdivision ──────────────────
                          if (block.subdivision > 0) ...[
                            _SectionTitle('SUBDIVISION'),
                            const SizedBox(height: 8),
                            Text(
                              SubdivisionType.values[block.subdivision].label,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),

                          // ─── Beat visualization ───────────
                          _BeatVisualization(
                            numerator: block.numerator,
                            currentBeat: pb.currentBeat,
                            isPlaying: pb.isPlaying,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ─── Bottom controls ────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(
                        top: BorderSide(color: AppColors.surfaceBorder),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Prev
                          IconButton(
                            onPressed: pb.hasPrevBlock
                                ? () => notifier.prevBlock()
                                : null,
                            icon: const Icon(Icons.skip_previous_rounded,
                                size: 32),
                            color: AppColors.textPrimary,
                          ),

                          // Loop
                          IconButton(
                            onPressed: pb.isPlaying
                                ? () => notifier.toggleLoop()
                                : null,
                            icon: Icon(
                              Icons.loop_rounded,
                              size: 28,
                              color: pb.isLooping
                                  ? AppColors.accent
                                  : AppColors.textDim,
                            ),
                          ),

                          // Play / Pause
                          GestureDetector(
                            onTap: () => notifier.togglePlayback(),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: pb.isPlaying
                                    ? AppColors.accent
                                    : AppColors.accentDim,
                              ),
                              child: Icon(
                                pb.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 36,
                                color: pb.isPlaying
                                    ? AppColors.background
                                    : AppColors.accent,
                              ),
                            ),
                          ),

                          // Stop
                          IconButton(
                            onPressed: pb.isPlaying
                                ? () => notifier.stop()
                                : null,
                            icon: const Icon(Icons.stop_rounded, size: 28),
                            color: AppColors.textDim,
                          ),

                          // Next
                          IconButton(
                            onPressed: pb.hasNextBlock
                                ? () => notifier.nextBlock()
                                : null,
                            icon: const Icon(Icons.skip_next_rounded,
                                size: 32),
                            color: AppColors.textPrimary,
                          ),
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.headphones_outlined,
              size: 80, color: AppColors.textDim.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('Mode Rehearsal',
              style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          const Text(
            'Chargez un morceau depuis l\'onglet Edit\npour répéter avec plus de contrôle',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textDim),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: Theme.of(context).textTheme.labelSmall);
  }
}

/// Sélecteur de blocs en chips.
class _BlockSelector extends StatelessWidget {
  final List blocks;
  final int currentIndex;
  final void Function(int) onTap;

  const _BlockSelector({
    required this.blocks,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: blocks.length,
        itemBuilder: (context, index) {
          final block = blocks[index];
          final isCurrent = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isCurrent ? AppColors.accentDim : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCurrent
                      ? AppColors.accent
                      : AppColors.surfaceBorder,
                ),
              ),
              child: Center(
                child: Text(
                  block.name,
                  style: TextStyle(
                    color: isCurrent
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Visualisation des beats.
class _BeatVisualization extends StatelessWidget {
  final int numerator;
  final int currentBeat;
  final bool isPlaying;

  const _BeatVisualization({
    required this.numerator,
    required this.currentBeat,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(numerator, (index) {
          final isActive = isPlaying && index == currentBeat;
          final isFirst = index == 0;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            width: isActive ? 40 : 32,
            height: isActive ? 40 : 32,
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
                            .withValues(alpha: 0.5),
                        blurRadius: 16,
                        spreadRadius: 3,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : AppColors.textDim,
                  fontWeight: FontWeight.w700,
                  fontSize: isActive ? 18 : 14,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
