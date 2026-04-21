import 'package:flutter/material.dart';
import 'package:tapparty/l10n/app_locale.dart';
import 'package:tapparty/l10n/strings.dart';
import 'package:tapparty/screens/mode_selection_screen.dart';
import 'package:tapparty/theme/app_theme.dart';
import 'package:tapparty/widgets/neon_button.dart';
import 'package:tapparty/widgets/party_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PartyScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppTheme.stroke),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.acid,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'party game for friends',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const _LangToggle(),
            ],
          ),
          const Spacer(),
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: 'tap',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                TextSpan(
                  text: '.',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(color: AppTheme.acid),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            S.homeDescription,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 28),
          const _PreviewDots(),
          const SizedBox(height: 28),
          NeonButton(
            label: S.start,
            icon: Icons.play_arrow_rounded,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ModeSelectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LangToggle extends StatelessWidget {
  const _LangToggle();

  @override
  Widget build(BuildContext context) {
    final String current = AppLocale.notifier.value;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.stroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _LangPill(label: 'RU', selected: current == 'ru', onTap: () => AppLocale.set('ru')),
          const SizedBox(width: 4),
          _LangPill(label: 'EN', selected: current == 'en', onTap: () => AppLocale.set('en')),
        ],
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  const _LangPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppTheme.acid : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? AppTheme.background : AppTheme.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _PreviewDots extends StatelessWidget {
  const _PreviewDots();

  @override
  Widget build(BuildContext context) {
    const colors = <Color>[
      AppTheme.acid,
      AppTheme.pink,
      AppTheme.cyan,
      AppTheme.gold,
    ];

    return Row(
      children: colors
          .map(
            (Color color) => Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
