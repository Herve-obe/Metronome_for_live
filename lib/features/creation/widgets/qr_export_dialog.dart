import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:metronome_for_live/core/models/setlist.dart';
import 'package:metronome_for_live/core/services/export_service.dart';

void showQrExportDialog(BuildContext context, Setlist setlist) {
  final jsonString = ExportService().exportSetlist(setlist);
  
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF222222),
      title: Text('Partager: ${setlist.title}', style: const TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: QrImageView(
                data: jsonString,
                version: QrVersions.auto,
                size: 250.0,
                backgroundColor: Colors.white,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Scannez ce QR Code, ou copiez le texte brut en cliquant ci-dessous :", style: TextStyle(color: Colors.white54, fontSize: 12), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text("Copier le code JSON"),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonString));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code JSON copié au presse-papier')));
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fermer', style: TextStyle(color: Colors.white54))),
      ],
    )
  );
}
