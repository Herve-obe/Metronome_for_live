import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/edit_providers.dart';
import '../widgets/edit_dialogs.dart';

/// Page de liste des setlists d'un projet.
class SetlistsScreen extends ConsumerWidget {
  final String projectId;
  const SetlistsScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setlistsAsync = ref.watch(setlistsStreamProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setlists'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/edit'),
        ),
      ),
      body: setlistsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (setlists) {
          if (setlists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.queue_music_outlined,
                      size: 80,
                      color: AppColors.textDim.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('Aucune setlist',
                      style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Nouvelle setlist'),
                  ),
                ],
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: setlists.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              final ids = setlists.map((s) => s.id).toList();
              final movedId = ids.removeAt(oldIndex);
              ids.insert(newIndex, movedId);
              ref.read(setlistsActionsProvider).reorder(ids);
            },
            itemBuilder: (context, index) {
              final setlist = setlists[index];
              return Card(
                key: ValueKey(setlist.id),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accentDim,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.queue_music,
                        color: AppColors.accent),
                  ),
                  title: Text(setlist.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    setlist.autoChain
                        ? 'Enchaînement auto'
                        : 'Manuel',
                    style: const TextStyle(
                        color: AppColors.textDim, fontSize: 13),
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert,
                        color: AppColors.textSecondary),
                    color: AppColors.surfaceLight,
                    onSelected: (action) {
                      switch (action) {
                        case 'rename':
                          showRenameDialog(
                            context: context,
                            title: 'Renommer la setlist',
                            currentName: setlist.name,
                            onConfirm: (n) => ref
                                .read(setlistsActionsProvider)
                                .rename(setlist.id, n),
                          );
                        case 'delete':
                          showDeleteDialog(
                            context: context,
                            itemName: setlist.name,
                            onConfirm: () => ref
                                .read(setlistsActionsProvider)
                                .delete(setlist.id),
                          );
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                          value: 'rename',
                          child: Row(children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 12),
                            Text('Renommer')
                          ])),
                      const PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            Icon(Icons.delete, size: 20, color: AppColors.error),
                            SizedBox(width: 12),
                            Text('Supprimer',
                                style: TextStyle(color: AppColors.error))
                          ])),
                    ],
                  ),
                  onTap: () => context
                      .go('/edit/project/$projectId/setlist/${setlist.id}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showCreateDialog(
      context: context,
      title: 'Nouvelle setlist',
      nameLabel: 'Nom de la setlist',
      onConfirm: (name, _) {
        ref.read(setlistsActionsProvider).create(projectId, name);
      },
    );
  }
}
