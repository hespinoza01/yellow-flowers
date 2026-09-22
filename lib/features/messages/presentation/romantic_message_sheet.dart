import 'package:flutter/material.dart';

/// Botón flotante que abre el mensaje romántico actual (el que corresponde
/// a la foto/canción actuales). Para ver un mensaje distinto hay que usar
/// el botón de "cambiar todo" en la pantalla principal, no hay refresh acá.
class RomanticMessageButton extends StatelessWidget {
  const RomanticMessageButton({super.key, required this.message});

  final String message;

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
      builder: (_) => _RomanticMessageSheet(message: message),
    );
  }
}

class _RomanticMessageSheet extends StatelessWidget {
  const _RomanticMessageSheet({required this.message});

  final String message;

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
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
