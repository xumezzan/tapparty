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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF0A0B12),
            Color(0xFF08090F),
            Color(0xFF050609),
          ],
        ),
      ),
      child: Stack(
        children: const <Widget>[
          Positioned(
            top: -60,
            right: -50,
            child: _GlowCircle(size: 260, color: AppTheme.violet, opacity: 0.20),
          ),
          Positioned(
            top: 180,
            left: -60,
            child: _GlowCircle(size: 180, color: AppTheme.cyan, opacity: 0.16),
          ),
          Positioned(
            bottom: -80,
            right: -40,
            child: _GlowCircle(size: 240, color: AppTheme.pink, opacity: 0.18),
          ),
          Positioned(
            bottom: 200,
            left: 30,
            child: _GlowCircle(size: 100, color: AppTheme.acid, opacity: 0.14),
          ),
          Positioned(
            top: 320,
            right: 60,
            child: _GlowCircle(size: 80, color: AppTheme.gold, opacity: 0.12),
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
              blurRadius: 100,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
