import 'dart:math';

import 'package:flutter/material.dart';

import '../data/romantic_messages.dart';

/// Botón flotante que abre un mensaje romántico random, con opción de ver
/// otro.
class RomanticMessageButton extends StatelessWidget {
  const RomanticMessageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showMessageSheet(context),
      backgroundColor: Colors.amber.shade700,
      foregroundColor: Colors.black,
      icon: const Icon(Icons.mail_outline),
      label: const Text('Ver mensaje'),
    );
  }

  void _showMessageSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _RomanticMessageSheet(),
    );
  }
}

class _RomanticMessageSheet extends StatefulWidget {
  const _RomanticMessageSheet();

  @override
  State<_RomanticMessageSheet> createState() => _RomanticMessageSheetState();
}

class _RomanticMessageSheetState extends State<_RomanticMessageSheet> {
  final _random = Random();
  late String _message = _pickRandom();

  String _pickRandom() =>
      RomanticMessages.all[_random.nextInt(RomanticMessages.all.length)];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber.shade700, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite, color: Colors.redAccent, size: 32),
            const SizedBox(height: 16),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () => setState(() => _message = _pickRandom()),
                  icon: const Icon(Icons.refresh, color: Colors.amber),
                  label: const Text(
                    'Otro mensaje',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
