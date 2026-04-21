import 'package:flutter/material.dart';
import 'package:tapparty/data/game_modes.dart';
import 'package:tapparty/l10n/app_locale.dart';
import 'package:tapparty/l10n/strings.dart';
import 'package:tapparty/models/game_mode.dart';
import 'package:tapparty/screens/task_input_screen.dart';
import 'package:tapparty/screens/touch_screen.dart';
import 'package:tapparty/theme/app_theme.dart';
import 'package:tapparty/widgets/party_scaffold.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PartyScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.06),
            ),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(height: 18),
          Text(
            S.chooseMode,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            S.chooseModeHint,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: gameModes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 14),
              itemBuilder: (BuildContext context, int index) {
                final GameMode mode = gameModes[index];
                return _ModeCard(mode: mode);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.mode});

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    final bool isEn = AppLocale.isEn;
    final String title =
        isEn && mode.titleEn != null ? mode.titleEn! : mode.title;
    final String subtitle =
        isEn && mode.subtitleEn != null ? mode.subtitleEn! : mode.subtitle;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => mode.requiresManualTaskInput
                  ? TaskInputScreen(mode: mode)
                  : TouchScreen(mode: mode),
            ),
          );
        },
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: AppTheme.stroke),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: mode.accentColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: mode.accentColor.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(mode.icon, color: AppTheme.background),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        if (mode.badgeText != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: AppTheme.stroke),
                            ),
                            child: Text(
                              isEn && mode.badgeTextEn != null
                                  ? mode.badgeTextEn!
                                  : mode.badgeText!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
