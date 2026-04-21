import 'package:flutter/material.dart';

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
}
