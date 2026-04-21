import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tapparty/l10n/app_locale.dart';
import 'package:tapparty/l10n/strings.dart';
import 'package:tapparty/models/game_mode.dart';
import 'package:tapparty/screens/touch_screen.dart';
import 'package:tapparty/theme/app_theme.dart';
import 'package:tapparty/widgets/neon_button.dart';
import 'package:tapparty/widgets/party_scaffold.dart';

class TaskInputScreen extends StatefulWidget {
  const TaskInputScreen({super.key, required this.mode});

  final GameMode mode;

  @override
  State<TaskInputScreen> createState() => _TaskInputScreenState();
}

class _TaskInputScreenState extends State<TaskInputScreen> {
  late final TextEditingController _controller;
  final Random _random = Random();

  List<String> get _examples {
    final bool isEn = AppLocale.isEn;
    final List<String>? en = widget.mode.examplesEn;
    return isEn && en != null ? en : widget.mode.examples;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
  }

  void _pickRandom() {
    final List<String> examples = _examples;
    final String current = _controller.text.trim();
    String picked;
    if (examples.length > 1) {
      String candidate;
      do {
        candidate = examples[_random.nextInt(examples.length)];
      } while (candidate == current && examples.length > 1);
      picked = candidate;
    } else {
      picked = examples.first;
    }
    _controller.text = picked;
    _controller.selection = TextSelection.collapsed(offset: picked.length);
  }

  @override
  Widget build(BuildContext context) {
    final String trimmedTask = _controller.text.trim();
    final List<String> examples = _examples;

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
            S.customTaskTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            S.customTaskHint,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            maxLines: 5,
            minLines: 5,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(hintText: S.inputPlaceholder),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Text(
                S.quickExamples,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _pickRandom,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppTheme.stroke),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.shuffle_rounded,
                        size: 13,
                        color: AppTheme.acid,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        S.randomBtn,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.acid,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: examples.map((String example) {
              return ActionChip(
                backgroundColor: Colors.white.withValues(alpha: 0.06),
                side: const BorderSide(color: AppTheme.stroke),
                label: Text(
                  example,
                  style: const TextStyle(color: AppTheme.textPrimary),
                ),
                onPressed: () {
                  _controller.text = example;
                  _controller.selection = TextSelection.collapsed(
                    offset: example.length,
                  );
                },
              );
            }).toList(),
          ),
          const Spacer(),
          NeonButton(
            label: S.continueBtn,
            color: widget.mode.accentColor,
            icon: Icons.arrow_forward_rounded,
            onPressed: trimmedTask.isEmpty
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => TouchScreen(
                          mode: widget.mode,
                          customTaskText: trimmedTask,
                        ),
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }
}
