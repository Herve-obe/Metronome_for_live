import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/playback_provider.dart';
import '../providers/edit_providers.dart';
import '../widgets/edit_dialogs.dart';

/// Page de liste des morceaux d'une setlist.
class SongsScreen extends ConsumerWidget {
  final String setlistId;
  final String projectId;
  const SongsScreen(
      {super.key, required this.setlistId, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(songsStreamProvider(setlistId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Morceaux'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/edit/project/$projectId'),
        ),
      ),
      body: songsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (songs) {
          if (songs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_note_outlined,
                      size: 80,
                      color: AppColors.textDim.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('Aucun morceau',
                      style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Nouveau morceau'),
                  ),
                ],
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: songs.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              final ids = songs.map((s) => s.id).toList();
              final movedId = ids.removeAt(oldIndex);
              ids.insert(newIndex, movedId);
              ref.read(songsActionsProvider).reorder(ids);
            },
            itemBuilder: (context, index) {
              final song = songs[index];
              return Card(
                key: ValueKey(song.id),
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
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  title: Text(song.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Appui long → lire en Live',
                      style: TextStyle(color: AppColors.textDim, fontSize: 11)),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert,
                        color: AppColors.textSecondary),
                    color: AppColors.surfaceLight,
                    onSelected: (action) {
                      switch (action) {
                        case 'play':
                          ref.read(playbackProvider.notifier)
                              .loadSongWithName(song.id, song.name);
                          context.go('/live');
                        case 'rename':
                          showRenameDialog(
                            context: context,
                            title: 'Renommer le morceau',
                            currentName: song.name,
                            onConfirm: (n) => ref
                                .read(songsActionsProvider)
                                .rename(song.id, n),
                          );
                        case 'delete':
                          showDeleteDialog(
                            context: context,
                            itemName: song.name,
                            onConfirm: () => ref
                                .read(songsActionsProvider)
                                .delete(song.id),
                          );
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                          value: 'play',
                          child: Row(children: [
                            Icon(Icons.play_arrow_rounded, size: 20, color: AppColors.accent),
                            SizedBox(width: 12),
                            Text('Lire en Live',
                                style: TextStyle(color: AppColors.accent))
                          ])),
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
                  onTap: () => context.go(
                      '/edit/project/$projectId/setlist/$setlistId/song/${song.id}'),
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
      title: 'Nouveau morceau',
      nameLabel: 'Nom du morceau',
      onConfirm: (name, _) {
        ref.read(songsActionsProvider).create(setlistId, name);
      },
    );
  }
}
