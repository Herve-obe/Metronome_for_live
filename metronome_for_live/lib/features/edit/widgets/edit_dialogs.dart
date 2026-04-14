import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Dialogue de création d'un élément.
Future<void> showCreateDialog({
  required BuildContext context,
  required String title,
  required String nameLabel,
  String? extraField,
  required void Function(String name, String? extra) onConfirm,
}) async {
  final nameController = TextEditingController();
  final extraController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(labelText: nameLabel),
            textCapitalization: TextCapitalization.sentences,
          ),
          if (extraField != null) ...[
            const SizedBox(height: 12),
            TextField(
              controller: extraController,
              decoration: InputDecoration(labelText: extraField),
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isNotEmpty) {
              onConfirm(
                name,
                extraField != null ? extraController.text.trim() : null,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Créer'),
        ),
      ],
    ),
  );
}

/// Dialogue de renommage.
Future<void> showRenameDialog({
  required BuildContext context,
  required String title,
  required String currentName,
  required void Function(String newName) onConfirm,
}) async {
  final controller = TextEditingController(text: currentName);

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Nom'),
        textCapitalization: TextCapitalization.sentences,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              onConfirm(name);
              Navigator.pop(context);
            }
          },
          child: const Text('Renommer'),
        ),
      ],
    ),
  );
}

/// Dialogue de confirmation de suppression.
Future<void> showDeleteDialog({
  required BuildContext context,
  required String itemName,
  required VoidCallback onConfirm,
}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Supprimer'),
      content: Text(
        'Voulez-vous vraiment supprimer "$itemName" ?\n\n'
        'Cette action est irréversible.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
          child: const Text('Supprimer'),
        ),
      ],
    ),
  );
}
