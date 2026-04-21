import 'package:flutter/material.dart';
import 'package:tapparty/l10n/strings.dart';
import 'package:tapparty/models/game_mode.dart';
import 'package:tapparty/screens/mode_selection_screen.dart';
import 'package:tapparty/screens/task_input_screen.dart';
import 'package:tapparty/screens/touch_screen.dart';
import 'package:tapparty/theme/app_theme.dart';
import 'package:tapparty/widgets/neon_button.dart';
import 'package:tapparty/widgets/party_scaffold.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.mode,
    required this.taskText,
    required this.customTaskText,
    required this.selectedPlayerLabel,
  });

  final GameMode mode;
  final String taskText;
  final String? customTaskText;
  final String selectedPlayerLabel;

  bool get _isWhoPays => mode.id == 'who_pays';

  @override
  Widget build(BuildContext context) {
    final bool isHiddenTask = customTaskText == null;

    return PartyScaffold(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.92, end: 1),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double value, Widget? child) {
          final double opacity = ((value - 0.92) / 0.08).clamp(0.0, 1.0);
          return Opacity(
            opacity: opacity,
            child: Transform.scale(scale: value, child: child),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Spacer(),
            Center(
              child: _WinnerGlow(
                accentColor: mode.accentColor,
                playerLabel: selectedPlayerLabel,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: mode.accentColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _isWhoPays ? S.youPay : S.youAreChosen,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: AppTheme.background),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                _isWhoPays ? S.pays : S.performs,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 12,
                  letterSpacing: 1.1,
                  color: AppTheme.textMuted,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                selectedPlayerLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  color: mode.accentColor,
                ),
              ),
            ),
            const SizedBox(height: 26),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppTheme.stroke),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _isWhoPays
                        ? S.payScenario
                        : isHiddenTask
                        ? S.hiddenChallenge
                        : S.task,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    taskText,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const Spacer(),
            NeonButton(
              label: S.playAgain,
              color: mode.accentColor,
              icon: Icons.replay_rounded,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => TouchScreen(
                      mode: mode,
                      customTaskText: customTaskText,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            NeonButton(
              label: isHiddenTask ? S.chooseModeBtnLabel : S.newTask,
              outlined: true,
              icon: isHiddenTask
                  ? Icons.grid_view_rounded
                  : Icons.edit_rounded,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => isHiddenTask
                        ? const ModeSelectionScreen()
                        : TaskInputScreen(mode: mode),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            NeonButton(
              label: S.home,
              outlined: true,
              icon: Icons.home_rounded,
              onPressed: () {
                Navigator.of(context).popUntil((Route<dynamic> route) {
                  return route.isFirst;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WinnerGlow extends StatelessWidget {
  const _WinnerGlow({required this.accentColor, required this.playerLabel});

  final Color accentColor;
  final String playerLabel;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutBack,
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 166,
        height: 166,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              Colors.white.withValues(alpha: 0.85),
              accentColor,
              accentColor.withValues(alpha: 0.9),
            ],
            stops: const <double>[0.0, 0.16, 1.0],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: accentColor.withValues(alpha: 0.5),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.background.withValues(alpha: 0.76),
            ),
            alignment: Alignment.center,
            child: Text(
              playerLabel.replaceFirst('Игрок ', '').replaceFirst('Player ', ''),
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 38),
            ),
          ),
        ),
      ),
    );
  }
}
