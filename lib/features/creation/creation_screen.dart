import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:metronome_for_live/core/models/project.dart';
import 'package:metronome_for_live/core/models/song.dart';
import 'package:metronome_for_live/core/database/database_repository.dart';
import 'package:metronome_for_live/core/database/project_state.dart';
import 'package:metronome_for_live/features/creation/song_editor_screen.dart';
import 'package:metronome_for_live/features/creation/setlist_editor_screen.dart';
import 'package:metronome_for_live/features/creation/widgets/import_dialog.dart';
import 'package:metronome_for_live/core/models/setlist.dart';
import 'package:metronome_for_live/core/services/export_service.dart';

class CreationScreen extends ConsumerWidget {
  const CreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProject = ref.watch(currentProjectProvider);
    final repo = ref.read(databaseRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Mode Création', style: TextStyle(color: Colors.white)),
        actions: [
          if (currentProject != null)
            IconButton(
              icon: const Icon(Icons.folder_shared, color: Colors.white),
              onPressed: () {
                ref.read(currentProjectProvider.notifier).state = null;
              },
            )
        ],
      ),
      body: currentProject == null 
          ? _buildProjectSelector(context, ref, repo)
          : _buildProjectDashboard(context, ref, currentProject, repo),
    );
  }

  Widget _buildProjectSelector(BuildContext context, WidgetRef ref, DatabaseRepository repo) {
    return FutureBuilder<List<Project>>(
      future: repo.getProjects(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text("Erreur: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final projects = snapshot.data!;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.library_music, size: 80, color: Colors.white24),
              const SizedBox(height: 20),
              const Text("Aucun projet actif", style: TextStyle(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 20),
              if (projects.isNotEmpty) ...[
                const Text("Sélectionner :", style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                ...projects.map((p) => ListTile(
                  title: Text(p.name, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                  onTap: () => ref.read(currentProjectProvider.notifier).state = p,
                )),
                const SizedBox(height: 20),
              ],
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                icon: const Icon(Icons.add),
                label: const Text('NOUVEAU GROUPE / PROJET'),
                onPressed: () => _showNewProjectDialog(context, ref, repo),
              )
            ],
          ),
        );
      }
    );
  }

  Future<void> _showNewProjectDialog(BuildContext context, WidgetRef ref, DatabaseRepository repo) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        title: const Text('Nouveau Projet', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: "Nom du groupe", hintStyle: TextStyle(color: Colors.white54)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler', style: TextStyle(color: Colors.white54))),
          TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Créer', style: TextStyle(color: Colors.blueAccent))),
        ],
      )
    );

    if (name != null && name.trim().isNotEmpty) {
      final newProject = Project(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name.trim());
      await repo.saveProject(newProject);
      ref.read(currentProjectProvider.notifier).state = newProject;
    }
  }

  Widget _buildProjectDashboard(BuildContext context, WidgetRef ref, Project project, DatabaseRepository repo) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.black,
            child: const TabBar(
              indicatorColor: Colors.blueAccent,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.white54,
              tabs: [
                Tab(icon: Icon(Icons.music_note), text: "Chansons"),
                Tab(icon: Icon(Icons.queue_music), text: "Setlists"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _SongsTab(project: project, repo: repo),
                _SetlistsTab(project: project, repo: repo),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SongsTab extends StatefulWidget {
  final Project project;
  final DatabaseRepository repo;
  const _SongsTab({required this.project, required this.repo});

  @override
  State<_SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<_SongsTab> {
  void _refresh() => setState(() {});

  Future<void> _showAddToSetlistDialog(Song song) async {
    final setlists = await widget.repo.getSetlistsForProject(widget.project.id);
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        title: const Text('Ajouter à...', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: setlists.isEmpty 
          ? const Text("Aucune setlist dans ce groupe.", style: TextStyle(color: Colors.white54))
          : ListView.builder(
            shrinkWrap: true,
            itemCount: setlists.length,
            itemBuilder: (c, i) {
               final setlist = setlists[i];
               return ListTile(
                 title: Text(setlist.title, style: const TextStyle(color: Colors.white)),
                 onTap: () async {
                    Navigator.pop(ctx);
                    if (!setlist.songs.any((s) => s.id == song.id)) {
                       final updatedSongs = List<Song>.from(setlist.songs)..add(song);
                       final updatedSetlist = setlist.copyWith(songs: updatedSongs);
                       await widget.repo.saveSetlist(updatedSetlist, widget.project.id);
                       if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chanson ajoutée !')));
                    }
                 }
               );
            }
          )
        ),
      )
    );
  }

  Future<void> _showDuplicateSongDialog(Song song) async {
    final projects = await widget.repo.getProjects();
    final otherProjects = projects.where((p) => p.id != widget.project.id).toList();
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        title: const Text('Dupliquer vers le projet...', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: otherProjects.isEmpty 
          ? const Text("Aucun autre projet existant.", style: TextStyle(color: Colors.white54))
          : ListView.builder(
            shrinkWrap: true,
            itemCount: otherProjects.length,
            itemBuilder: (c, i) {
               final targetProject = otherProjects[i];
               return ListTile(
                 title: Text(targetProject.name, style: const TextStyle(color: Colors.white)),
                 onTap: () async {
                    Navigator.pop(ctx);
                    
                    const uuid = Uuid();
                    final newSongId = uuid.v4();
                    final newBlocks = song.blocks.map((b) => b.copyWith(id: uuid.v4())).toList();
                    final duplicatedSong = song.copyWith(
                      id: newSongId,
                      blocks: newBlocks,
                      title: '${song.title} (Copie)'
                    );
                    
                    await widget.repo.saveSong(duplicatedSong, targetProject.id);
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chanson copiée dans ${targetProject.name}')));
                 }
               );
            }
          )
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Song>>(
      future: widget.repo.getSongsForProject(widget.project.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text("Erreur: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final songs = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: songs.isEmpty
              ? const Center(child: Text("Aucune chanson.\nAppuyez sur + pour créer.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: songs.length,
                  separatorBuilder: (c, i) => const Divider(color: Colors.white12),
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ListTile(
                      title: Text(song.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: Text('${song.blocks.length} bloc(s)', style: const TextStyle(color: Colors.white54)),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white54),
                        color: const Color(0xFF2A2A2A),
                        onSelected: (value) async {
                          if (value == 'add_to_setlist') {
                            await _showAddToSetlistDialog(song);
                          } else if (value == 'duplicate') {
                            await _showDuplicateSongDialog(song);
                          } else if (value == 'delete') {
                            await widget.repo.deleteSong(song.id);
                            _refresh();
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'add_to_setlist',
                            child: ListTile(leading: Icon(Icons.queue_music, color: Colors.white), title: Text('Ajouter à une Setlist', style: TextStyle(color: Colors.white))),
                          ),
                          const PopupMenuItem<String>(
                            value: 'duplicate',
                            child: ListTile(leading: Icon(Icons.copy, color: Colors.blueAccent), title: Text('Dupliquer dans un autre groupe', style: TextStyle(color: Colors.white))),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: ListTile(leading: Icon(Icons.delete, color: Colors.redAccent), title: Text('Supprimer', style: TextStyle(color: Colors.redAccent))),
                          ),
                        ],
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SongEditorScreen(song: song, projectId: widget.project.id))
                        );
                        _refresh();
                      },
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
               await Navigator.push(
                 context,
                 MaterialPageRoute(builder: (_) => SongEditorScreen(projectId: widget.project.id))
               );
               _refresh();
            },
          ),
        );
      },
    );
  }
}

class _SetlistsTab extends StatefulWidget {
  final Project project;
  final DatabaseRepository repo;
  const _SetlistsTab({required this.project, required this.repo});

  @override
  State<_SetlistsTab> createState() => _SetlistsTabState();
}

class _SetlistsTabState extends State<_SetlistsTab> {
  void _refresh() => setState(() {});

  Future<void> _showDuplicateSetlistDialog(Setlist setlist) async {
    final projects = await widget.repo.getProjects();
    final otherProjects = projects.where((p) => p.id != widget.project.id).toList();
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        title: const Text('Dupliquer dans le projet...', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: otherProjects.isEmpty 
          ? const Text("Aucun autre projet existant.", style: TextStyle(color: Colors.white54))
          : ListView.builder(
            shrinkWrap: true,
            itemCount: otherProjects.length,
            itemBuilder: (c, i) {
               final targetProject = otherProjects[i];
               return ListTile(
                 title: Text(targetProject.name, style: const TextStyle(color: Colors.white)),
                 onTap: () async {
                    Navigator.pop(ctx);
                    
                    // Uses JSON Export/Import serialization to natively regenerate all inner UUIDs 
                    // seamlessly (Setlist, Songs and Blocks are refreshed to prevent SQlite conflicts).
                    final jsonStr = ExportService().exportSetlist(setlist);
                    final newSetlist = ExportService().importSetlist(jsonStr);
                    if (newSetlist != null) {
                       final duplicated = newSetlist.copyWith(title: '${newSetlist.title} (Copie)');
                       await widget.repo.saveSetlist(duplicated, targetProject.id);
                       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Setlist copiée dans ${targetProject.name}')));
                    }
                 }
               );
            }
          )
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Setlist>>(
      future: widget.repo.getSetlistsForProject(widget.project.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text("Erreur: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final setlists = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: setlists.isEmpty
              ? const Center(child: Text("Aucune setlist.\nAppuyez sur + pour créer.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: setlists.length,
                  itemBuilder: (context, index) {
                    final setlist = setlists[index];
                    return Card(
                      color: const Color(0xFF222222),
                      child: ListTile(
                        title: Text(setlist.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text('${setlist.songs.length} chanson(s)', style: const TextStyle(color: Colors.white54)),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.white54),
                          color: const Color(0xFF2A2A2A),
                          onSelected: (value) async {
                            if (value == 'duplicate') {
                              await _showDuplicateSetlistDialog(setlist);
                            } else if (value == 'delete') {
                              await widget.repo.deleteSetlist(setlist.id);
                              _refresh();
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'duplicate',
                              child: ListTile(leading: Icon(Icons.copy, color: Colors.blueAccent), title: Text('Dupliquer dans un autre groupe', style: TextStyle(color: Colors.white))),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(leading: Icon(Icons.delete, color: Colors.redAccent), title: Text('Supprimer', style: TextStyle(color: Colors.redAccent))),
                            ),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => SetlistEditorScreen(setlist: setlist, projectId: widget.project.id)));
                          _refresh();
                        },
                      ),
                    );
                  },
                ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'import',
                backgroundColor: Colors.grey[800],
                child: const Icon(Icons.download, color: Colors.white),
                onPressed: () async {
                   await showImportDialog(context, widget.repo, widget.project.id);
                   _refresh();
                },
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'add',
                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () async {
                   await Navigator.push(context, MaterialPageRoute(builder: (_) => SetlistEditorScreen(projectId: widget.project.id)));
                   _refresh();
                },
              ),
            ]
          ),
        );
      },
    );
  }
}
