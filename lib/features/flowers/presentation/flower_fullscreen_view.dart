import 'package:flutter/material.dart';

import '../../messages/presentation/romantic_message_sheet.dart';

class FlowerFullscreenView extends StatelessWidget {
  const FlowerFullscreenView({
    super.key,
    required this.assetPath,
    required this.message,
    required this.onRefreshAll,
    this.refreshing = false,
    this.banner,
  });

  final String? assetPath;
  final String message;
  final VoidCallback onRefreshAll;
  final bool refreshing;
  final Widget? banner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: refreshing ? null : onRefreshAll,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            icon: refreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.shuffle),
            label: const Text('Cambiar todo'),
          ),
          const SizedBox(height: 12),
          RomanticMessageButton(message: message),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (assetPath != null)
            Image.asset(assetPath!, fit: BoxFit.cover)
          else
            const _NoPhotosPlaceholder(),
          if (banner != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 32,
              child: banner!,
            ),
        ],
      ),
    );
  }
}

class _NoPhotosPlaceholder extends StatelessWidget {
  const _NoPhotosPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Agrega fotos de flores amarillas en\nassets/images/flowers/',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
