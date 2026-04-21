import 'package:flutter/material.dart';
import 'package:tapparty/models/game_mode.dart';
import 'package:tapparty/theme/app_theme.dart';

const List<GameMode> gameModes = <GameMode>[
  GameMode(
    id: 'truth_or_dare',
    title: 'Truth or Dare',
    titleEn: 'Truth or Dare',
    subtitle: '70 скрытых заданий: признания, импровизация и весёлые наказания.',
    subtitleEn: '70 hidden tasks: confessions, improvisation and fun punishments.',
    accentColor: AppTheme.acid,
    icon: Icons.bolt_rounded,
    hiddenTaskCount: 70,
    examples: <String>[
      'Кто-то должен спеть припев любимой песни.',
      'Кто-то честно отвечает на неудобный вопрос.',
      'Кто-то делает 10 смешных танцевальных движений.',
    ],
    examplesEn: <String>[
      'Someone sings the chorus of their favorite song.',
      'Someone honestly answers an uncomfortable question.',
      'Someone does 10 funny dance moves.',
    ],
  ),
  GameMode(
    id: 'who_pays',
    title: 'Кто платит',
    titleEn: 'Who Pays',
    subtitle: '50 скрытых мини-сценариев, кто сегодня угощает или спонсирует бонус.',
    subtitleEn: '50 hidden mini-scenarios: who treats the group or sponsors a bonus today.',
    accentColor: AppTheme.pink,
    icon: Icons.payments_rounded,
    hiddenTaskCount: 50,
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
    id: 'who_does_it',
    title: 'Кто выполняет',
    titleEn: 'Who Does It',
    subtitle: '80 скрытых челленджей для вечеринок, пар и компаний друзей.',
    subtitleEn: '80 hidden challenges for parties, couples and friend groups.',
    accentColor: AppTheme.cyan,
    icon: Icons.celebration_rounded,
    hiddenTaskCount: 80,
    examples: <String>[
      'Кто-то делает 15 отжиманий.',
      'Кто-то рассказывает самую смешную историю.',
      'Кто-то изображает любимого героя 30 секунд.',
    ],
    examplesEn: <String>[
      'Someone does 15 push-ups.',
      'Someone tells the funniest story.',
      'Someone acts as their favorite character for 30 seconds.',
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
    hiddenTaskCount: 0,
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
