import 'package:flutter/material.dart';

class FlowerFullscreenView extends StatelessWidget {
  const FlowerFullscreenView({
    super.key,
    required this.assetPath,
    this.banner,
  });

  final String? assetPath;
  final Widget? banner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
