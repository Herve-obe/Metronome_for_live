import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metronome_for_live/core/models/song.dart';
import 'package:metronome_for_live/core/database/database_repository.dart';
import 'package:metronome_for_live/core/database/project_state.dart';
import 'package:metronome_for_live/core/audio/metronome_engine.dart';

class RehearsalScreen extends ConsumerWidget {
  const RehearsalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(currentProjectProvider);
    final currentSong = ref.watch(currentSongProvider);
    final engine = ref.read(metronomeEngineProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Répétition / Gig', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          if (currentSong != null)
            TextButton.icon(
              icon: const Icon(Icons.close, color: Colors.redAccent),
              label: const Text('QUITTER', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onPressed: () {
                engine.stop();
                ref.read(currentSongProvider.notifier).state = null;
              },
            )
        ],
      ),
      body: project == null 
          ? const Center(child: Text("Accédez à Création pour ouvrir un projet", style: TextStyle(color: Colors.white54)))
          : (currentSong == null ? _buildSongSelector(context, ref, project.id) : _buildPlayer(context, ref, engine, currentSong)),
    );
  }

  Widget _buildSongSelector(BuildContext context, WidgetRef ref, String projectId) {
    final repo = ref.read(databaseRepositoryProvider);
    return FutureBuilder<List<Song>>(
      future: repo.getSongsForProject(projectId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final songs = snapshot.data!;
        if (songs.isEmpty) return const Center(child: Text("Aucune chanson à répéter", style: TextStyle(color: Colors.white54)));

        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (ctx, i) {
            final song = songs[i];
            return ListTile(
              leading: const Icon(Icons.play_circle_fill, color: Colors.blueAccent, size: 40),
              title: Text(song.title, style: const TextStyle(color: Colors.white, fontSize: 18)),
              subtitle: Text('${song.blocks.length} bloc(s)', style: const TextStyle(color: Colors.white54)),
              onTap: () {
                final engine = ref.read(metronomeEngineProvider);
                engine.loadSong(song);
              },
            );
          },
        );
      }
    );
  }

  Widget _buildPlayer(BuildContext context, WidgetRef ref, MetronomeEngine engine, Song song) {
    final isPlaying = ref.watch(metronomePlayingProvider);
    final blockIdx = ref.watch(currentBlockIndexProvider);
    final measure = ref.watch(currentMeasureInBlockProvider);
    final beat = ref.watch(metronomeBeatProvider);
    final bpm = ref.watch(metronomeBpmProvider);
    final totalMeasures = ref.watch(metronomeTotalMeasuresProvider);

    if (song.blocks.isEmpty) return const Center(child: Text("Cette chanson est vide", style: TextStyle(color: Colors.white54)));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(song.title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: song.blocks.length,
            itemBuilder: (ctx, i) {
              final b = song.blocks[i];
              final isActive = i == blockIdx;
              return Container(
                color: isActive ? Colors.blueAccent.withValues(alpha: 0.1) : Colors.transparent,
                child: ListTile(
                  leading: Icon(isActive ? Icons.volume_up : Icons.music_note, color: isActive ? Colors.blueAccent : Colors.white54),
                  title: Text(b.name, style: TextStyle(color: isActive ? Colors.blueAccent : Colors.white70, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
                  subtitle: Text('${b.startBpm} BPM - ${b.signatureNumerator}/4', style: const TextStyle(color: Colors.white54)),
                  trailing: isActive 
                      ? Text('$measure / ${b.fixedMeasuresCount ?? "∞"}', style: const TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold))
                      : null,
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          color: const Color(0xFF0F0F0F),
          child: Column(
            children: [
              Text('$bpm BPM', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
              Text('Mesure : $measure ${totalMeasures != null ? '/ $totalMeasures' : ''}  |  Temps : $beat', style: const TextStyle(color: Colors.white54, fontSize: 16)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 80,
                    icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.blueAccent),
                    onPressed: () => isPlaying ? engine.stop() : engine.start(),
                  ),
                ],
              )
            ],
          )
        )
      ],
    );
  }
}
