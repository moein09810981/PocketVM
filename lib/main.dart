import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fx.dart';
import 'models.dart';
import 'shell.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: G.bg,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const GlacierApp());
}

class GlacierApp extends StatelessWidget {
  const GlacierApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: buildTheme(),
        home: const _Root(),
      );
}

class _Root extends StatefulWidget {
  const _Root();
  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  // The loading screen is shown at least this long so its animation can play.
  bool _minTimeDone = false;

  @override
  void initState() {
    super.initState();
    appState.load();
    Future<void>.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _minTimeDone = true);
    });
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: appState,
        builder: (context, _) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          child: appState.loaded && _minTimeDone
              ? const Shell(key: ValueKey('shell'))
              : const GlacierLoader(key: ValueKey('splash')),
        ),
      );
}
