import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onClose;

  const PopupDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onClose, child: const Text('Dismiss')),
          ],
        ),
      ),
    );
  }
}
