import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.mode.examples.first);
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

  @override
  Widget build(BuildContext context) {
    final String trimmedTask = _controller.text.trim();

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
            'Своё задание',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Это вторичный режим. Используй его, если хочешь задать свой сценарий вручную вместо скрытых челленджей.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            maxLines: 5,
            minLines: 5,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: const InputDecoration(
              hintText:
                  'Например: Кто-то поёт без музыки, говорит тост или идёт за снеками.',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Быстрые примеры',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.mode.examples.map((String example) {
              return ActionChip(
                backgroundColor: Colors.white.withValues(alpha: 0.06),
                side: const BorderSide(color: AppTheme.stroke),
                label: Text(
                  example,
                  style: const TextStyle(color: AppTheme.textPrimary),
                ),
                onPressed: () => _controller.text = example,
              );
            }).toList(),
          ),
          const Spacer(),
          NeonButton(
            label: 'Продолжить',
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
