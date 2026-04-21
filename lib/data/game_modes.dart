import 'package:flutter/material.dart';
import 'package:tapparty/models/game_mode.dart';
import 'package:tapparty/theme/app_theme.dart';

const List<GameMode> gameModes = <GameMode>[
  GameMode(
    id: 'truth_or_dare',
    title: 'Truth or Dare',
    subtitle:
        '70 скрытых заданий: признания, импровизация и весёлые наказания.',
    accentColor: AppTheme.acid,
    icon: Icons.bolt_rounded,
    hiddenTaskCount: 70,
    examples: <String>[
      'Кто-то должен спеть припев любимой песни.',
      'Кто-то честно отвечает на неудобный вопрос.',
      'Кто-то делает 10 смешных танцевальных движений.',
    ],
  ),
  GameMode(
    id: 'who_pays',
    title: 'Кто платит',
    subtitle:
        '50 скрытых мини-сценариев, кто сегодня угощает или спонсирует бонус.',
    accentColor: AppTheme.pink,
    icon: Icons.payments_rounded,
    hiddenTaskCount: 50,
    examples: <String>[
      'Кто-то платит за кофе.',
      'Кто-то заказывает всем мороженое.',
      'Кто-то оплачивает следующую поездку.',
    ],
  ),
  GameMode(
    id: 'who_does_it',
    title: 'Кто выполняет',
    subtitle: '80 скрытых челленджей для вечеринок, пар и компаний друзей.',
    accentColor: AppTheme.cyan,
    icon: Icons.celebration_rounded,
    hiddenTaskCount: 80,
    examples: <String>[
      'Кто-то делает 15 отжиманий.',
      'Кто-то рассказывает самую смешную историю.',
      'Кто-то изображает любимого героя 30 секунд.',
    ],
  ),
  GameMode(
    id: 'custom_task',
    title: 'Custom task',
    subtitle: 'Ручной режим. Ты сам задаёшь правило, если нужен свой сценарий.',
    accentColor: AppTheme.violet,
    icon: Icons.auto_awesome_rounded,
    hiddenTaskCount: 0,
    requiresManualTaskInput: true,
    examples: <String>[
      'Кто-то поёт песню без музыки.',
      'Кто-то идёт за снеками.',
      'Кто-то показывает смешную эмоцию на камеру.',
    ],
  ),
];
