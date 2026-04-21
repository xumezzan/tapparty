import 'package:flutter/material.dart';
import 'package:tapparty/widgets/ambient_background.dart';

class PartyScaffold extends StatelessWidget {
  const PartyScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 16, 24, 24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
