import 'package:flutter/material.dart';
import 'package:tapparty/models/game_mode.dart';
import 'package:tapparty/theme/app_theme.dart';

const List<GameMode> gameModes = <GameMode>[
  GameMode(
    id: 'truth',
    title: 'Правда',
    titleEn: 'Truth',
    subtitle: 'Больше 100 вопросов на честность: признания, секреты и неожиданные ответы.',
    subtitleEn: 'Over 100 honesty questions: confessions, secrets and unexpected answers.',
    accentColor: AppTheme.acid,
    icon: Icons.bolt_rounded,
    badgeText: '> 100 вопросов',
    badgeTextEn: '> 100 questions',
    examples: <String>[
      'Кто-то честно отвечает на неудобный вопрос.',
      'Кто-то называет свою самую странную привычку.',
      'Кто-то признаётся, чего боится больше всего.',
    ],
    examplesEn: <String>[
      'Someone honestly answers an uncomfortable question.',
      'Someone reveals their strangest habit.',
      'Someone admits what they are most afraid of.',
    ],
  ),
  GameMode(
    id: 'who_pays',
    title: 'Кто платит',
    titleEn: 'Who Pays',
    subtitle: 'Случайный игрок платит за всю компанию — просто положите пальцы и узнайте кто.',
    subtitleEn: 'A random player pays for the group — just place your fingers and find out who.',
    accentColor: AppTheme.pink,
    icon: Icons.payments_rounded,

    examples: <String>[
      'Кто-то платит за кофе.',
      'Кто-то заказывает всем мороженое.',
      'Кто-то оплачивает следующую поездку.',
    ],
    examplesEn: <String>[
      'Someone pays for coffee.',
      'Someone orders ice cream for everyone.',
      'Someone covers the next ride.',
    ],
  ),
  GameMode(
    id: 'dare',
    title: 'Действие',
    titleEn: 'Dare',
    subtitle: 'Больше 100 заданий: импровизация, кривляния и весёлые задания для компании.',
    subtitleEn: 'Over 100 challenges: improvisation, silly acts and fun tasks for the group.',
    accentColor: AppTheme.cyan,
    icon: Icons.celebration_rounded,
    badgeText: '> 100 заданий',
    badgeTextEn: '> 100 challenges',
    examples: <String>[
      'Кто-то изображает уверенного пингвина.',
      'Кто-то делает мини-стендап про понедельники.',
      'Кто-то показывает самый театральный способ сесть на стул.',
    ],
    examplesEn: <String>[
      'Someone acts like a very confident penguin.',
      'Someone does a mini stand-up about Mondays.',
      'Someone shows the most dramatic way to sit in a chair.',
    ],
  ),
  GameMode(
    id: 'custom_task',
    title: 'Custom task',
    titleEn: 'Custom task',
    subtitle: 'Ручной режим. Ты сам задаёшь правило, если нужен свой сценарий.',
    subtitleEn: 'Manual mode. Set your own rule for a custom scenario.',
    accentColor: AppTheme.violet,
    icon: Icons.auto_awesome_rounded,

    requiresManualTaskInput: true,
    examples: <String>[
      'Кто-то поёт песню без музыки.',
      'Кто-то идёт за снеками.',
      'Кто-то показывает смешную эмоцию на камеру.',
    ],
    examplesEn: <String>[
      'Someone sings a song without music.',
      'Someone goes to grab snacks.',
      'Someone makes a funny face at the camera.',
    ],
  ),
];
