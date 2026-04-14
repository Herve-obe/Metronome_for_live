import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/edit_providers.dart';
import '../widgets/edit_dialogs.dart';

/// Page de liste des projets.
class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome for Live'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Settings page
            },
          ),
        ],
      ),
      body: projectsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (projects) {
          if (projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 80,
                    color: AppColors.textDim.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun projet',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Créez votre premier projet\npour commencer',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Nouveau projet'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
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
                    child: const Icon(
                      Icons.folder_outlined,
                      color: AppColors.accent,
                    ),
                  ),
                  title: Text(
                    project.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: project.groupName.isNotEmpty
                      ? Text(
                          project.groupName,
                          style: const TextStyle(color: AppColors.textDim),
                        )
                      : null,
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert,
                        color: AppColors.textSecondary),
                    color: AppColors.surfaceLight,
                    onSelected: (action) {
                      switch (action) {
                        case 'rename':
                          _showRenameDialog(context, ref, project);
                        case 'delete':
                          _showDeleteDialog(context, ref, project);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 12),
                            Text('Renommer'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: AppColors.error),
                            SizedBox(width: 12),
                            Text('Supprimer',
                                style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () =>
                      context.go('/edit/project/${project.id}'),
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
      title: 'Nouveau projet',
      nameLabel: 'Nom du projet',
      extraField: 'Groupe (optionnel)',
      onConfirm: (name, extra) {
        ref
            .read(projectsActionsProvider)
            .create(name, groupName: extra ?? '');
      },
    );
  }

  void _showRenameDialog(
      BuildContext context, WidgetRef ref, dynamic project) {
    showRenameDialog(
      context: context,
      title: 'Renommer le projet',
      currentName: project.name,
      onConfirm: (newName) {
        ref.read(projectsActionsProvider).rename(project.id, newName);
      },
    );
  }

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, dynamic project) {
    showDeleteDialog(
      context: context,
      itemName: project.name,
      onConfirm: () {
        ref.read(projectsActionsProvider).delete(project.id);
      },
    );
  }
}
