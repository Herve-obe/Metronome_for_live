import 'package:flutter/material.dart';
import 'package:metronome_for_live/core/models/block.dart';

Future<Block?> showBlockEditorDialog(BuildContext context, Block initialBlock) {
  final nameCtrl = TextEditingController(text: initialBlock.name);
  final bpmCtrl = TextEditingController(text: initialBlock.startBpm.toString());
  final numCtrl = TextEditingController(text: initialBlock.signatureNumerator.toString());
  
  return showDialog<Block>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF222222),
      title: const Text('Paramètres du Bloc', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nom (ex: Intro, Refrain)', 
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: bpmCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Tempo (BPM)', 
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: numCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Temps par mesure (Signature)', 
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler', style: TextStyle(color: Colors.white54))),
        TextButton(
          onPressed: () {
            final bpm = int.tryParse(bpmCtrl.text) ?? initialBlock.startBpm;
            final sig = int.tryParse(numCtrl.text) ?? initialBlock.signatureNumerator;
            Navigator.pop(ctx, initialBlock.copyWith(
              name: nameCtrl.text,
              startBpm: bpm,
              endBpm: bpm,
              signatureNumerator: sig,
            ));
          }, 
          child: const Text('Sauvegarder', style: TextStyle(color: Colors.blueAccent))
        ),
      ],
    ),
  );
}
