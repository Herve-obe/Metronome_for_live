import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/enums.dart';
import '../../../core/database/app_database.dart';
import '../providers/edit_providers.dart';
import '../widgets/edit_dialogs.dart';

/// Éditeur de blocs de tempo d'un morceau.
class BlockEditorScreen extends ConsumerStatefulWidget {
  final String songId;
  const BlockEditorScreen({super.key, required this.songId});

  @override
  ConsumerState<BlockEditorScreen> createState() => _BlockEditorScreenState();
}

class _BlockEditorScreenState extends ConsumerState<BlockEditorScreen> {
  String? _selectedBlockId;

  @override
  Widget build(BuildContext context) {
    final blocksAsync = ref.watch(blocksStreamProvider(widget.songId));

    return Scaffold(
      appBar: AppBar(title: const Text('Blocs de tempo')),
      body: blocksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (blocks) {
          if (blocks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timeline_outlined,
                      size: 80,
                      color: AppColors.textDim.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('Aucun bloc',
                      style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _createBlock(),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un bloc'),
                  ),
                ],
              ),
            );
          }

          final selectedBlock = _selectedBlockId != null
              ? blocks
                  .where((b) => b.id == _selectedBlockId)
                  .firstOrNull
              : null;

          return Column(
            children: [
              // ─── Timeline horizontale ───────────────────────
              SizedBox(
                height: 100,
                child: ReorderableListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    final ids = blocks.map((b) => b.id).toList();
                    final movedId = ids.removeAt(oldIndex);
                    ids.insert(newIndex, movedId);
                    ref.read(blocksActionsProvider).reorder(ids);
                  },
                  children: [
                    for (final block in blocks)
                      GestureDetector(
                        key: ValueKey(block.id),
                        onTap: () =>
                            setState(() => _selectedBlockId = block.id),
                        child: Container(
                          width: 120,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: block.id == _selectedBlockId
                                ? AppColors.accentDim
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: block.id == _selectedBlockId
                                  ? AppColors.accent
                                  : AppColors.surfaceBorder,
                              width: block.id == _selectedBlockId ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                block.name,
                                style: TextStyle(
                                  color: block.id == _selectedBlockId
                                      ? AppColors.accent
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${block.bpm} BPM · ${block.numerator}/${block.denominator}',
                                style: const TextStyle(
                                  color: AppColors.textDim,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                block.measureCount == 0
                                    ? '∞ mesures'
                                    : '${block.measureCount} mes.',
                                style: const TextStyle(
                                  color: AppColors.textDim,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // ─── Formulaire d'édition ───────────────────────
              if (selectedBlock != null)
                Expanded(
                  child: _BlockForm(
                    block: selectedBlock,
                    onChanged: (companion) {
                      ref.read(blocksActionsProvider).update(companion);
                    },
                    onDelete: () {
                      ref.read(blocksActionsProvider).delete(selectedBlock.id);
                      setState(() => _selectedBlockId = null);
                    },
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Text(
                      'Sélectionnez un bloc pour le modifier',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createBlock,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createBlock() {
    showCreateDialog(
      context: context,
      title: 'Nouveau bloc',
      nameLabel: 'Nom du bloc (ex: Intro, Couplet 1...)',
      onConfirm: (name, _) async {
        final id = await ref
            .read(blocksActionsProvider)
            .create(widget.songId, name);
        setState(() => _selectedBlockId = id);
      },
    );
  }
}

/// Formulaire d'édition d'un bloc de tempo.
class _BlockForm extends StatelessWidget {
  final TempoBlock block;
  final void Function(TempoBlocksCompanion) onChanged;
  final VoidCallback onDelete;

  const _BlockForm({
    required this.block,
    required this.onChanged,
    required this.onDelete,
  });

  /// Crée un companion avec les valeurs actuelles du bloc,
  /// avec possibilité de surcharger un champ.
  TempoBlocksCompanion _withUpdate({
    int? bpm,
    int? numerator,
    int? denominator,
    int? subdivision,
    int? measureCount,
    double? volume,
  }) {
    return TempoBlocksCompanion(
      id: Value(block.id),
      songId: Value(block.songId),
      name: Value(block.name),
      sortOrder: Value(block.sortOrder),
      bpm: Value(bpm ?? block.bpm),
      numerator: Value(numerator ?? block.numerator),
      denominator: Value(denominator ?? block.denominator),
      subdivision: Value(subdivision ?? block.subdivision),
      measureCount: Value(measureCount ?? block.measureCount),
      volume: Value(volume ?? block.volume),
      accentSound: Value(block.accentSound),
      normalSound: Value(block.normalSound),
      subdivisionSound: Value(block.subdivisionSound),
      announceName: Value(block.announceName),
      announceCountIn: Value(block.announceCountIn),
      countInMeasures: Value(block.countInMeasures),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ─── Nom ────────────────────────────────────────
        Text('NOM DU BLOC',
            style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 6),
        Text(block.name,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.accent)),
        const SizedBox(height: 24),

        // ─── BPM ────────────────────────────────────────
        Row(
          children: [
            Text('BPM',
                style: Theme.of(context).textTheme.labelSmall),
            const Spacer(),
            Text(TempoName.fromBpm(block.bpm),
                style: const TextStyle(
                    color: AppColors.textDim, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: block.bpm > 20
                  ? () => onChanged(_withUpdate(bpm: block.bpm - 1))
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.accent,
            ),
            Expanded(
              child: Slider(
                value: block.bpm.toDouble(),
                min: 20,
                max: 300,
                divisions: 280,
                label: '${block.bpm}',
                onChanged: (v) =>
                    onChanged(_withUpdate(bpm: v.round())),
              ),
            ),
            IconButton(
              onPressed: block.bpm < 300
                  ? () => onChanged(_withUpdate(bpm: block.bpm + 1))
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.accent,
            ),
            SizedBox(
              width: 60,
              child: Text(
                '${block.bpm}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ─── Signature ──────────────────────────────────
        Text('SIGNATURE',
            style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            // Numérateur
            Expanded(
              child: Column(
                children: [
                  const Text('Numérateur',
                      style: TextStyle(
                          color: AppColors.textDim, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: block.numerator > 1
                            ? () => onChanged(
                                _withUpdate(numerator: block.numerator - 1))
                            : null,
                        icon: const Icon(Icons.remove, size: 20),
                        color: AppColors.accent,
                      ),
                      Text(
                        '${block.numerator}',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary),
                      ),
                      IconButton(
                        onPressed: block.numerator < 16
                            ? () => onChanged(
                                _withUpdate(numerator: block.numerator + 1))
                            : null,
                        icon: const Icon(Icons.add, size: 20),
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Text('/',
                style: TextStyle(
                    fontSize: 32,
                    color: AppColors.textDim,
                    fontWeight: FontWeight.w300)),
            // Dénominateur
            Expanded(
              child: Column(
                children: [
                  const Text('Dénominateur',
                      style: TextStyle(
                          color: AppColors.textDim, fontSize: 12)),
                  const SizedBox(height: 4),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 1, label: Text('1')),
                      ButtonSegment(value: 2, label: Text('2')),
                      ButtonSegment(value: 4, label: Text('4')),
                      ButtonSegment(value: 8, label: Text('8')),
                      ButtonSegment(value: 16, label: Text('16')),
                    ],
                    selected: {block.denominator},
                    onSelectionChanged: (v) =>
                        onChanged(_withUpdate(denominator: v.first)),
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: AppColors.accentDim,
                      selectedForegroundColor: AppColors.accent,
                      foregroundColor: AppColors.textDim,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ─── Mesures ────────────────────────────────────
        Text('NOMBRE DE MESURES',
            style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: block.measureCount > 0
                  ? () => onChanged(
                      _withUpdate(measureCount: block.measureCount - 1))
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.accent,
            ),
            Text(
              block.measureCount == 0 ? '∞' : '${block.measureCount}',
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
            IconButton(
              onPressed: () => onChanged(
                  _withUpdate(measureCount: block.measureCount + 1)),
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.accent,
            ),
          ],
        ),
        if (block.measureCount == 0)
          const Center(
            child: Text('Infini — le bloc se répète indéfiniment',
                style: TextStyle(color: AppColors.textDim, fontSize: 12)),
          ),
        const SizedBox(height: 24),

        // ─── Subdivision ────────────────────────────────
        Text('SUBDIVISION',
            style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        SegmentedButton<int>(
          segments: SubdivisionType.values
              .map((s) => ButtonSegment(
                  value: s.index, label: Text(s.label)))
              .toList(),
          selected: {block.subdivision},
          onSelectionChanged: (v) =>
              onChanged(_withUpdate(subdivision: v.first)),
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: AppColors.accentDim,
            selectedForegroundColor: AppColors.accent,
            foregroundColor: AppColors.textDim,
          ),
        ),
        const SizedBox(height: 32),

        // ─── Supprimer ──────────────────────────────────
        Center(
          child: TextButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: AppColors.error),
            label: const Text('Supprimer ce bloc',
                style: TextStyle(color: AppColors.error)),
          ),
        ),
      ],
    );
  }
}


