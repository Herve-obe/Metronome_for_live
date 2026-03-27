import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metronome_for_live/core/models/setlist.dart';
import 'package:metronome_for_live/core/models/song.dart';
import 'package:metronome_for_live/core/database/database_repository.dart';
import 'package:metronome_for_live/features/creation/widgets/qr_export_dialog.dart';

class SetlistEditorScreen extends ConsumerStatefulWidget {
  final Setlist? setlist;
  final String projectId;
  
  const SetlistEditorScreen({super.key, this.setlist, required this.projectId});

  @override
  ConsumerState<SetlistEditorScreen> createState() => _SetlistEditorScreenState();
}

class _SetlistEditorScreenState extends ConsumerState<SetlistEditorScreen> {
  late TextEditingController _titleCtrl;
  late List<Song> _songs;
  List<Song> _allProjectSongs = [];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.setlist?.title ?? 'Nouvelle Setlist');
    _songs = widget.setlist?.songs.toList() ?? [];
    _loadAllSongs();
  }

  Future<void> _loadAllSongs() async {
     final repo = ref.read(databaseRepositoryProvider);
     final songs = await repo.getSongsForProject(widget.projectId);
     if (mounted) {
       setState(() {
         _allProjectSongs = songs;
       });
     }
  }

  void _save() async {
    final repo = ref.read(databaseRepositoryProvider);
    final id = widget.setlist?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final newSetlist = Setlist(
      id: id,
      title: _titleCtrl.text.isEmpty ? "Setlist sans nom" : _titleCtrl.text,
      date: widget.setlist?.date,
      location: widget.setlist?.location,
      songs: _songs,
    );
    await repo.saveSetlist(newSetlist, widget.projectId);
    if (mounted) Navigator.pop(context);
  }

  void _showAddSongDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF222222),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Ajouter des chansons", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                 itemCount: _allProjectSongs.length,
                 itemBuilder: (context, index) {
                   final song = _allProjectSongs[index];
                   return ListTile(
                     leading: const Icon(Icons.music_note, color: Colors.blueAccent),
                     title: Text(song.title, style: const TextStyle(color: Colors.white)),
                     onTap: () {
                       setState(() {
                          if (!_songs.any((s) => s.id == song.id)) {
                            _songs.add(song);
                          }
                       });
                       Navigator.pop(ctx);
                     },
                   );
                 }
              ),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Éditeur de Setlist', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (widget.setlist != null)
            IconButton(
              icon: const Icon(Icons.qr_code, color: Colors.white),
              onPressed: () => showQrExportDialog(context, widget.setlist!),
            ),
          TextButton.icon(
            icon: const Icon(Icons.check, color: Colors.greenAccent), 
            label: const Text('SAVE', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            onPressed: _save
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _titleCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(hintText: 'Titre de la Setlist', hintStyle: TextStyle(color: Colors.white30), border: InputBorder.none),
            ),
          ),
          const Divider(color: Colors.white24),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: _songs.length,
              onReorder: (oldIdx, newIdx) {
                setState(() {
                  if (newIdx > oldIdx) newIdx -= 1;
                  final item = _songs.removeAt(oldIdx);
                  _songs.insert(newIdx, item);
                });
              },
              itemBuilder: (context, index) {
                final song = _songs[index];
                return ListTile(
                  key: ValueKey(song.id),
                  leading: const Icon(Icons.drag_handle, color: Colors.white54),
                  title: Text('${index + 1}. ${song.title}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                     icon: const Icon(Icons.close, color: Colors.redAccent), // Enlever de la setlist sans supprimer du projet
                     onPressed: () => setState(() => _songs.removeAt(index)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Chanson", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: _showAddSongDialog,
      ),
    );
  }
}
