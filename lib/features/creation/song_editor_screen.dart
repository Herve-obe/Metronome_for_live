import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metronome_for_live/core/models/song.dart';
import 'package:metronome_for_live/core/models/block.dart';
import 'package:metronome_for_live/core/database/database_repository.dart';
import 'package:metronome_for_live/features/creation/widgets/block_editor_dialog.dart';

class SongEditorScreen extends ConsumerStatefulWidget {
  final Song? song;
  final String projectId;
  
  const SongEditorScreen({super.key, this.song, required this.projectId});

  @override
  ConsumerState<SongEditorScreen> createState() => _SongEditorScreenState();
}

class _SongEditorScreenState extends ConsumerState<SongEditorScreen> {
  late TextEditingController _titleCtrl;
  late List<Block> _blocks;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.song?.title ?? 'Nouvelle Chanson');
    _blocks = widget.song?.blocks.toList() ?? [];
  }

  void _save() async {
    final repo = ref.read(databaseRepositoryProvider);
    final id = widget.song?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final newSong = Song(
      id: id,
      title: _titleCtrl.text,
      blocks: _blocks,
    );
    await repo.saveSong(newSong, widget.projectId);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Éditeur de Chanson', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
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
              decoration: const InputDecoration(
                 hintText: 'Titre de la chanson',
                 hintStyle: TextStyle(color: Colors.white30),
                 border: InputBorder.none,
              ),
            ),
          ),
          const Divider(color: Colors.white24),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _blocks.length,
              onReorder: (oldIdx, newIdx) {
                setState(() {
                  if (newIdx > oldIdx) newIdx -= 1;
                  final item = _blocks.removeAt(oldIdx);
                  _blocks.insert(newIdx, item);
                });
              },
              itemBuilder: (context, index) {
                final block = _blocks[index];
                return Card(
                  key: ValueKey(block.id),
                  color: const Color(0xFF222222),
                  child: ListTile(
                    leading: const Icon(Icons.drag_handle, color: Colors.white54),
                    title: Text('${index + 1}. ${block.name}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('${block.startBpm} BPM - ${block.signatureNumerator}/4', style: const TextStyle(color: Colors.white54)),
                    trailing: IconButton(
                       icon: const Icon(Icons.delete, color: Colors.redAccent),
                       onPressed: () => setState(() => _blocks.removeAt(index)),
                    ),
                    onTap: () async {
                      final updated = await showBlockEditorDialog(context, block);
                      if (updated != null) {
                        setState(() => _blocks[index] = updated);
                      }
                    },
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
        label: const Text("Ajouter un Bloc", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
           setState(() {
             _blocks.add(Block(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: 'Bloc ${_blocks.length + 1}',
                startBpm: 120,
                endBpm: 120,
                signatureNumerator: 4,
                signatureDenominator: 4,
                durationType: DurationType.manualLoop,
                variationType: VariationType.immediate,
                ttsEnabled: false,
                ttsCountInBeats: 4,
             ));
           });
        },
      ),
    );
  }
}
