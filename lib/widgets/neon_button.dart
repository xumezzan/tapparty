import 'package:flutter/material.dart';
import 'package:tapparty/theme/app_theme.dart';

class NeonButton extends StatelessWidget {
  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppTheme.acid,
    this.outlined = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final bool outlined;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final Color backgroundColor = outlined
        ? Colors.white.withValues(alpha: 0.05)
        : enabled
        ? color
        : AppTheme.stroke;
    final Color foregroundColor = outlined
        ? AppTheme.textPrimary
        : enabled
        ? AppTheme.background
        : AppTheme.textMuted;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: outlined ? AppTheme.stroke : backgroundColor,
              ),
              boxShadow: outlined
                  ? null
                  : <BoxShadow>[
                      BoxShadow(
                        color: color.withValues(alpha: enabled ? 0.34 : 0.0),
                        blurRadius: 24,
                        offset: const Offset(0, 14),
                      ),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 18, color: foregroundColor),
                  const SizedBox(width: 10),
                ],
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: foregroundColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
