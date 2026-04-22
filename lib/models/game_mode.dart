import 'package:flutter/material.dart';
import 'package:tapparty/l10n/app_locale.dart';

class GameMode {
  const GameMode({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.icon,
    this.badgeText,
    this.badgeTextEn,
    required this.examples,
    this.titleEn,
    this.subtitleEn,
    this.examplesEn,
    this.requiresManualTaskInput = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String? titleEn;
  final String? subtitleEn;
  final Color accentColor;
  final IconData icon;
  final String? badgeText;
  final String? badgeTextEn;
  final List<String> examples;
  final List<String>? examplesEn;
  final bool requiresManualTaskInput;

  String get localizedTitle =>
      AppLocale.isEn && titleEn != null ? titleEn! : title;

  String get localizedSubtitle =>
      AppLocale.isEn && subtitleEn != null ? subtitleEn! : subtitle;

  String? get localizedBadgeText {
    if (AppLocale.isEn && badgeTextEn != null) {
      return badgeTextEn!;
    }
    return badgeText;
  }

  List<String> get localizedExamples =>
      AppLocale.isEn && examplesEn != null ? examplesEn! : examples;
}
