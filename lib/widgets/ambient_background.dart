import 'package:flutter/material.dart';
import 'package:tapparty/theme/app_theme.dart';

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Positioned.fill(child: _BackgroundLayer()),
        child,
      ],
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppTheme.background,
            Color(0xFF090A11),
            Color(0xFF06070B),
          ],
        ),
      ),
      child: Stack(
        children: const <Widget>[
          Positioned(
            top: -90,
            right: -70,
            child: _GlowCircle(size: 220, color: AppTheme.pink, opacity: 0.30),
          ),
          Positioned(
            top: 140,
            left: -40,
            child: _GlowCircle(size: 160, color: AppTheme.cyan, opacity: 0.22),
          ),
          Positioned(
            bottom: -70,
            left: -50,
            child: _GlowCircle(
              size: 220,
              color: AppTheme.violet,
              opacity: 0.22,
            ),
          ),
          Positioned(
            bottom: 160,
            right: 20,
            child: _GlowCircle(size: 120, color: AppTheme.acid, opacity: 0.18),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: 90,
              spreadRadius: 16,
            ),
          ],
        ),
      ),
    );
  }
}
