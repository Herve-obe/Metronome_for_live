import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:metronome_for_live/core/services/export_service.dart';
import 'package:metronome_for_live/core/database/database_repository.dart';

Future<void> showImportDialog(BuildContext context, DatabaseRepository repo, String projectId) async {
  final ctrl = TextEditingController();
  
  // Tentative de collage automatique depuis le presse-papier
  final clipboardData = await Clipboard.getData('text/plain');
  if (clipboardData != null && clipboardData.text != null) {
      if (clipboardData.text!.contains('{"id"')) {
         ctrl.text = clipboardData.text!;
      }
  }

  if (!context.mounted) return;
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF222222),
      title: const Text('Importer une Setlist', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Collez le code JSON envoyé par votre groupe :", style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 10),
          TextField(
            controller: ctrl,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: const InputDecoration(
              hintText: '{"id":"...", "title":"...", "songs":[]}',
              hintStyle: TextStyle(color: Colors.white24),
              filled: true,
              fillColor: Colors.black,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler', style: TextStyle(color: Colors.white54))),
        TextButton(
          onPressed: () async {
            final imported = ExportService().importSetlist(ctrl.text);
            if (imported != null) {
              await repo.saveSetlist(imported, projectId);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Setlist importée avec succès !')));
              }
            } else {
              if (ctx.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code JSON invalide ou corrompu')));
            }
          }, 
          child: const Text('Importer', style: TextStyle(color: Colors.blueAccent))
        ),
      ],
    )
  );
}
