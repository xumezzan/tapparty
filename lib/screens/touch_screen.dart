import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tapparty/data/hidden_tasks.dart';
import 'package:tapparty/l10n/strings.dart';
import 'package:tapparty/models/game_mode.dart';
import 'package:tapparty/screens/result_screen.dart';
import 'package:tapparty/theme/app_theme.dart';
import 'package:tapparty/widgets/party_scaffold.dart';

class TouchScreen extends StatefulWidget {
  const TouchScreen({super.key, required this.mode, this.customTaskText});

  final GameMode mode;
  final String? customTaskText;

  @override
  State<TouchScreen> createState() => _TouchScreenState();
}

enum _TouchPhase { waiting, countingDown, selecting, chosen }

class _TouchPoint {
  const _TouchPoint({
    required this.pointerId,
    required this.slot,
    required this.position,
    required this.color,
  });

  final int pointerId;
  final int slot;
  final Offset position;
  final Color color;

  _TouchPoint copyWith({Offset? position}) {
    return _TouchPoint(
      pointerId: pointerId,
      slot: slot,
      position: position ?? this.position,
      color: color,
    );
  }
}

class _TouchScreenState extends State<TouchScreen>
    with SingleTickerProviderStateMixin {
  static const int _minPlayers = 2;
  static const int _maxPlayers = 5;
  static const double _touchSize = 78;
  static const Duration _holdDuration = Duration(milliseconds: 1500);
  static const Duration _revealDelay = Duration(milliseconds: 900);

  static const List<Color> _touchColors = <Color>[
    AppTheme.acid,
    AppTheme.pink,
    AppTheme.cyan,
    AppTheme.gold,
    AppTheme.violet,
  ];

  final Random _random = Random();
  final Map<int, _TouchPoint> _touches = <int, _TouchPoint>{};
  late final AnimationController _pulseController;
  late final bool _isHiddenTask;
  late final String _taskText;

  Timer? _countdownTimer;
  Timer? _selectionStepTimer;
  Timer? _resultTimer;

  _TouchPhase _phase = _TouchPhase.waiting;
  double _countdownProgress = 0;
  int? _focusedPointerId;
  int? _winnerPointerId;
  int _selectionElapsedMs = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _isHiddenTask = widget.customTaskText == null;
    _taskText = widget.customTaskText ?? _pickHiddenTask();
  }

  @override
  void dispose() {
    _cancelAllTimers();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PartyScaffold(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size padSize = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppTheme.stroke),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (PointerDownEvent event) {
                  _handlePointerDown(event, padSize);
                },
                onPointerMove: (PointerMoveEvent event) {
                  _handlePointerMove(event, padSize);
                },
                onPointerUp: (PointerUpEvent event) {
                  _handlePointerEnd(event.pointer);
                },
                onPointerCancel: (PointerCancelEvent event) {
                  _handlePointerEnd(event.pointer);
                },
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (BuildContext context, Widget? child) {
                    return Stack(
                      children: <Widget>[
                        const Positioned.fill(child: _PadGrid()),
                        Positioned.fill(
                          child: _SelectionWash(
                            phase: _phase,
                            accentColor: widget.mode.accentColor,
                            pulseValue: _pulseController.value,
                          ),
                        ),
                        if (_touches.isEmpty)
                          Positioned.fill(
                            child: _EmptyState(
                              isHiddenTask: _isHiddenTask,
                              maxPlayers: _maxPlayers,
                            ),
                          ),
                        ..._touches.values.map(
                          (_TouchPoint touch) => _TouchBubble(
                            key: ValueKey<int>(touch.pointerId),
                            touch: touch,
                            left: touch.position.dx - (_touchSize / 2),
                            top: touch.position.dy - (_touchSize / 2),
                            size: _touchSize,
                            phase: _phase,
                            pulseValue: _pulseController.value,
                            isFocused: _focusedPointerId == touch.pointerId,
                            isWinner: _winnerPointerId == touch.pointerId,
                            fadeOthers:
                                _winnerPointerId != null &&
                                _winnerPointerId != touch.pointerId,
                          ),
                        ),
                        if (_touches.isNotEmpty)
                          Positioned(
                            bottom: 18,
                            left: 14,
                            right: 14,
                            child: IgnorePointer(
                              child: _PlayerBar(
                                touches: _touches.values.toList()
                                  ..sort(
                                    (_TouchPoint a, _TouchPoint b) =>
                                        a.slot.compareTo(b.slot),
                                  ),
                                focusedPointerId: _focusedPointerId,
                                winnerPointerId: _winnerPointerId,
                                phase: _phase,
                                pulseValue: _pulseController.value,
                              ),
                            ),
                          ),
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: _TouchHud(
                            mode: widget.mode,
                            phase: _phase,
                            playerCount: _touches.length,
                            maxPlayers: _maxPlayers,
                            countdownProgress: _countdownProgress,
                            isHiddenTask: _isHiddenTask,
                            onBack: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event, Size padSize) {
    if (_phase == _TouchPhase.chosen) {
      return;
    }
    if (_touches.containsKey(event.pointer) || _touches.length >= _maxPlayers) {
      return;
    }

    final int slot = _nextFreeSlot();
    final Offset position = _clampPosition(event.localPosition, padSize);

    setState(() {
      _touches[event.pointer] = _TouchPoint(
        pointerId: event.pointer,
        slot: slot,
        position: position,
        color: _touchColors[slot - 1],
      );
    });

    unawaited(HapticFeedback.selectionClick());
    _restartCountdownIfNeeded();
  }

  void _handlePointerMove(PointerMoveEvent event, Size padSize) {
    if (_phase == _TouchPhase.selecting || _phase == _TouchPhase.chosen) {
      return;
    }

    final _TouchPoint? currentTouch = _touches[event.pointer];
    if (currentTouch == null) {
      return;
    }

    final Offset position = _clampPosition(event.localPosition, padSize);
    setState(() {
      _touches[event.pointer] = currentTouch.copyWith(position: position);
    });
  }

  void _handlePointerEnd(int pointerId) {
    if (!_touches.containsKey(pointerId)) {
      return;
    }
    if (_phase == _TouchPhase.chosen) {
      return;
    }

    setState(() {
      _touches.remove(pointerId);
    });

    _restartCountdownIfNeeded();
  }

  void _restartCountdownIfNeeded() {
    _cancelSelectionTimers();

    if (_touches.length < _minPlayers) {
      setState(() {
        _phase = _TouchPhase.waiting;
        _countdownProgress = 0;
        _focusedPointerId = null;
        _winnerPointerId = null;
      });
      return;
    }

    setState(() {
      _phase = _TouchPhase.countingDown;
      _countdownProgress = 0;
      _focusedPointerId = null;
      _winnerPointerId = null;
    });
    unawaited(HapticFeedback.lightImpact());

    const int tickMs = 50;
    int elapsedMs = 0;

    _countdownTimer = Timer.periodic(const Duration(milliseconds: tickMs), (
      Timer timer,
    ) {
      if (!mounted || _phase != _TouchPhase.countingDown) {
        timer.cancel();
        return;
      }
      if (_touches.length < _minPlayers) {
        timer.cancel();
        return;
      }

      elapsedMs += tickMs;
      final double progress = (elapsedMs / _holdDuration.inMilliseconds).clamp(
        0.0,
        1.0,
      );

      setState(() {
        _countdownProgress = progress;
      });

      if (elapsedMs >= _holdDuration.inMilliseconds) {
        timer.cancel();
        _startSelection();
      }
    });
  }

  void _startSelection() {
    if (_touches.length < _minPlayers) {
      _restartCountdownIfNeeded();
      return;
    }

    final List<int> ids = _touches.keys.toList();
    final int winnerId = ids[_random.nextInt(ids.length)];

    setState(() {
      _phase = _TouchPhase.selecting;
      _selectionElapsedMs = 0;
      _focusedPointerId = null;
      _winnerPointerId = null;
    });
    unawaited(HapticFeedback.mediumImpact());

    _runSelectionStep(winnerId: winnerId, lastPointerId: null);
  }

  void _runSelectionStep({required int winnerId, required int? lastPointerId}) {
    if (!mounted || _phase != _TouchPhase.selecting) {
      return;
    }
    if (!_touches.containsKey(winnerId) || _touches.length < _minPlayers) {
      _restartCountdownIfNeeded();
      return;
    }

    final List<int> ids = _touches.keys.toList();
    const int totalMs = 2400;
    const int startIntervalMs = 70;
    const int endIntervalMs = 280;

    final double progress = (_selectionElapsedMs / totalMs).clamp(0.0, 1.0);
    final int intervalMs =
        startIntervalMs +
        ((endIntervalMs - startIntervalMs) * progress * progress).round();

    int pickedPointerId;
    if (progress > 0.86) {
      pickedPointerId = winnerId;
    } else {
      pickedPointerId = ids[_random.nextInt(ids.length)];
      if (ids.length > 1 && pickedPointerId == lastPointerId) {
        pickedPointerId = ids.firstWhere((int id) => id != lastPointerId);
      }
    }

    setState(() {
      _focusedPointerId = pickedPointerId;
    });
    if (progress < 0.9) {
      unawaited(HapticFeedback.selectionClick());
    } else {
      unawaited(HapticFeedback.lightImpact());
    }

    _selectionElapsedMs += intervalMs;

    if (_selectionElapsedMs >= totalMs) {
      _finishSelection(winnerId);
      return;
    }

    _selectionStepTimer = Timer(Duration(milliseconds: intervalMs), () {
      _runSelectionStep(winnerId: winnerId, lastPointerId: pickedPointerId);
    });
  }

  void _finishSelection(int winnerId) {
    if (!_touches.containsKey(winnerId)) {
      _restartCountdownIfNeeded();
      return;
    }

    setState(() {
      _phase = _TouchPhase.chosen;
      _focusedPointerId = winnerId;
      _winnerPointerId = winnerId;
    });
    unawaited(HapticFeedback.heavyImpact());

    _resultTimer = Timer(_revealDelay, () {
      if (!mounted) {
        return;
      }

      final _TouchPoint? winner = _touches[winnerId];
      if (winner == null) {
        _restartCountdownIfNeeded();
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ResultScreen(
            mode: widget.mode,
            taskText: _taskText,
            customTaskText: widget.customTaskText,
            selectedPlayerLabel: S.player(winner.slot),
          ),
        ),
      );
    });
  }

  String _pickHiddenTask() {
    final List<String> tasks = hiddenTasksForMode(widget.mode.id);
    if (tasks.isEmpty) {
      return widget.mode.examples.first;
    }
    return tasks[_random.nextInt(tasks.length)];
  }

  int _nextFreeSlot() {
    final Set<int> usedSlots = _touches.values
        .map((_TouchPoint touch) => touch.slot)
        .toSet();
    for (int slot = 1; slot <= _maxPlayers; slot++) {
      if (!usedSlots.contains(slot)) {
        return slot;
      }
    }
    return 1;
  }

  Offset _clampPosition(Offset position, Size padSize) {
    final double min = _touchSize / 2;
    final double x = position.dx.clamp(min, padSize.width - min);
    final double y = position.dy.clamp(min, padSize.height - min);
    return Offset(x, y);
  }

  void _cancelSelectionTimers() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _selectionStepTimer?.cancel();
    _selectionStepTimer = null;
    _resultTimer?.cancel();
    _resultTimer = null;
  }

  void _cancelAllTimers() {
    _cancelSelectionTimers();
  }
}

class _TouchHud extends StatelessWidget {
  const _TouchHud({
    required this.mode,
    required this.phase,
    required this.playerCount,
    required this.maxPlayers,
    required this.countdownProgress,
    required this.isHiddenTask,
    required this.onBack,
  });

  final GameMode mode;
  final _TouchPhase phase;
  final int playerCount;
  final int maxPlayers;
  final double countdownProgress;
  final bool isHiddenTask;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              onPressed: onBack,
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.background.withValues(alpha: 0.68),
                foregroundColor: AppTheme.textPrimary,
              ),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _HudChip(
                      label: mode.title,
                      backgroundColor: mode.accentColor,
                      foregroundColor: AppTheme.background,
                    ),
                    _HudChip(
                      label: '$playerCount/$maxPlayers',
                      icon: Icons.touch_app_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: AppTheme.background.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _phaseLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(fontSize: 14),
                    ),
                  ),
                  if (phase == _TouchPhase.countingDown)
                    Text(
                      '${(countdownProgress * 100).round()}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
              if (phase == _TouchPhase.countingDown) ...<Widget>[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: countdownProgress,
                    backgroundColor: Colors.white.withValues(alpha: 0.06),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.acid,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String get _phaseLabel {
    return switch (phase) {
      _TouchPhase.waiting =>
        playerCount == 0 ? S.placeFingersPrompt : S.needOneMore,
      _TouchPhase.countingDown => S.keepFingers,
      _TouchPhase.selecting => S.gameSelecting,
      _TouchPhase.chosen => S.revealingResult,
    };
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final Color bg =
        backgroundColor ?? AppTheme.background.withValues(alpha: 0.7);
    final Color fg = foregroundColor ?? AppTheme.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: backgroundColor == null ? AppTheme.stroke : bg,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 15, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: fg, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isHiddenTask, required this.maxPlayers});

  final bool isHiddenTask;
  final int maxPlayers;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.textMuted.withValues(alpha: 0.28),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.touch_app_rounded,
                  color: AppTheme.textMuted,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                S.placeFingers,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 8),
              Text(
                isHiddenTask
                    ? S.hiddenHint(maxPlayers)
                    : S.customHint(maxPlayers),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PadGrid extends StatelessWidget {
  const _PadGrid();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    const double gap = 28;

    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SelectionWash extends StatelessWidget {
  const _SelectionWash({
    required this.phase,
    required this.accentColor,
    required this.pulseValue,
  });

  final _TouchPhase phase;
  final Color accentColor;
  final double pulseValue;

  @override
  Widget build(BuildContext context) {
    final bool active =
        phase == _TouchPhase.selecting || phase == _TouchPhase.chosen;
    final double opacity = active
        ? 0.12 + (pulseValue * 0.08)
        : phase == _TouchPhase.countingDown
        ? 0.05
        : 0;

    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: opacity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                accentColor.withValues(alpha: 0.34),
                accentColor.withValues(alpha: 0.08),
                Colors.transparent,
              ],
              radius: 0.92,
            ),
          ),
        ),
      ),
    );
  }
}

class _TouchBubble extends StatelessWidget {
  const _TouchBubble({
    super.key,
    required this.touch,
    required this.left,
    required this.top,
    required this.size,
    required this.phase,
    required this.pulseValue,
    required this.isFocused,
    required this.isWinner,
    required this.fadeOthers,
  });

  final _TouchPoint touch;
  final double left;
  final double top;
  final double size;
  final _TouchPhase phase;
  final double pulseValue;
  final bool isFocused;
  final bool isWinner;
  final bool fadeOthers;

  @override
  Widget build(BuildContext context) {
    final bool isIdleBreathing =
        phase == _TouchPhase.waiting || phase == _TouchPhase.countingDown;
    final double breathingScale = 0.97 + (pulseValue * 0.05);
    final double focusScale = 1.08 + (pulseValue * 0.07);
    final double winnerScale = 1.16 + (pulseValue * 0.09);
    final double scale = isWinner
        ? winnerScale
        : isFocused
        ? focusScale
        : fadeOthers
        ? 0.82
        : isIdleBreathing
        ? breathingScale
        : 1;

    final double opacity = isWinner
        ? 1
        : fadeOthers
        ? 0.18
        : isFocused
        ? 1
        : 0.96;
    final double glowBlur = isWinner
        ? 34 + (pulseValue * 12)
        : isFocused
        ? 28 + (pulseValue * 10)
        : 20 + (pulseValue * 6);
    final double glowAlpha = isWinner
        ? 0.55
        : isFocused
        ? 0.48
        : 0.34;
    final double innerSize = size * 0.38;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 70),
      left: left,
      top: top,
      child: IgnorePointer(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 160),
          scale: scale,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            opacity: opacity,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                // ── main bubble ──
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        Colors.white.withValues(alpha: 0.75),
                        touch.color,
                        touch.color.withValues(alpha: 0.95),
                      ],
                      stops: const <double>[0.0, 0.18, 1.0],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: touch.color.withValues(alpha: glowAlpha),
                        blurRadius: glowBlur,
                        spreadRadius: 2,
                      ),
                      if (isFocused || isWinner)
                        BoxShadow(
                          color: Colors.white.withValues(
                            alpha: isWinner ? 0.85 : 0.50,
                          ),
                          blurRadius: 0,
                          spreadRadius: isWinner ? 5 : 3,
                        ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: innerSize,
                      height: innerSize,
                      decoration: BoxDecoration(
                        color: AppTheme.background.withValues(alpha: 0.76),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: isWinner
                          ? Icon(
                              Icons.star_rounded,
                              size: size * 0.28,
                              color: touch.color,
                            )
                          : null,
                    ),
                  ),
                ),
                // ── floating label above finger ──
                Positioned(
                  top: -42,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.easeOutBack,
                      builder: (
                        BuildContext ctx,
                        double v,
                        Widget? child,
                      ) {
                        return Transform.translate(
                          offset: Offset(0, (1 - v.clamp(0.0, 1.0)) * 10),
                          child: Transform.scale(
                            scale: v.clamp(0.0, 1.5),
                            child: Opacity(
                              opacity: v.clamp(0.0, 1.0),
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: EdgeInsets.symmetric(
                          horizontal: isWinner ? 14 : 11,
                          vertical: isWinner ? 7 : 5,
                        ),
                        decoration: BoxDecoration(
                          color: touch.color,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: touch.color.withValues(
                                alpha: isWinner ? 0.70 : isFocused ? 0.50 : 0.35,
                              ),
                              blurRadius: isWinner ? 20 : isFocused ? 14 : 8,
                              spreadRadius: isWinner ? 3 : 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (isWinner) ...<Widget>[
                              Icon(
                                Icons.star_rounded,
                                size: 13,
                                color: AppTheme.background,
                              ),
                              const SizedBox(width: 5),
                            ],
                            Text(
                              '${touch.slot}',
                              style: TextStyle(
                                fontSize: isWinner ? 15 : 13,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.background,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerBar extends StatelessWidget {
  const _PlayerBar({
    required this.touches,
    required this.focusedPointerId,
    required this.winnerPointerId,
    required this.phase,
    required this.pulseValue,
  });

  final List<_TouchPoint> touches;
  final int? focusedPointerId;
  final int? winnerPointerId;
  final _TouchPhase phase;
  final double pulseValue;

  @override
  Widget build(BuildContext context) {
    final bool isSelecting = phase == _TouchPhase.selecting;
    final bool isChosen = phase == _TouchPhase.chosen;

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: touches.map((_TouchPoint touch) {
          final bool isFocused = focusedPointerId == touch.pointerId;
          final bool isWinner = winnerPointerId == touch.pointerId;
          final bool dimmed =
              (isSelecting || isChosen) && !isFocused && !isWinner;
          return _PlayerChip(
            touch: touch,
            isFocused: isFocused,
            isWinner: isWinner,
            dimmed: dimmed,
            pulseValue: pulseValue,
          );
        }).toList(),
      ),
    );
  }
}

class _PlayerChip extends StatelessWidget {
  const _PlayerChip({
    required this.touch,
    required this.isFocused,
    required this.isWinner,
    required this.dimmed,
    required this.pulseValue,
  });

  final _TouchPoint touch;
  final bool isFocused;
  final bool isWinner;
  final bool dimmed;
  final double pulseValue;

  @override
  Widget build(BuildContext context) {
    final double scale = isWinner
        ? 1.18 + pulseValue * 0.06
        : isFocused
        ? 1.10 + pulseValue * 0.04
        : 1.0;
    final double bgAlpha = isWinner || isFocused ? 1.0 : 0.15;
    final double opacity = dimmed ? 0.22 : 1.0;

    return AnimatedScale(
      duration: const Duration(milliseconds: 140),
      scale: scale,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 140),
        opacity: opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: touch.color.withValues(alpha: bgAlpha),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: touch.color.withValues(
                alpha: isWinner || isFocused ? 1.0 : 0.5,
              ),
              width: isWinner ? 2.5 : 1.5,
            ),
            boxShadow: (isWinner || isFocused)
                ? <BoxShadow>[
                    BoxShadow(
                      color: touch.color.withValues(
                        alpha: isWinner ? 0.55 : 0.35,
                      ),
                      blurRadius: isWinner ? 20 : 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isWinner) ...<Widget>[
                Icon(
                  Icons.star_rounded,
                  size: 13,
                  color: AppTheme.background,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                S.player(touch.slot),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isWinner || isFocused
                      ? AppTheme.background
                      : touch.color,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
