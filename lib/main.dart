import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models.dart';
import 'shell.dart';
import 'theme.dart';
import 'widgets.dart';

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
  @override
  void initState() {
    super.initState();
    appState.load();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: appState,
        builder: (context, _) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: appState.loaded
              ? const Shell(key: ValueKey('shell'))
              : const _Splash(key: ValueKey('splash')),
        ),
      );
}

class _Splash extends StatelessWidget {
  const _Splash({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -.2),
                  radius: .9,
                  colors: [G.accent.withValues(alpha: .16), G.bg],
                ),
              ),
            ),
          ),
          const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 240,
              child: Opacity(opacity: .5, child: MountainBackdrop())),
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const GlacierLogo(size: 96),
              const SizedBox(height: 22),
              const Text(appName,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text(appTagline,
                  style: TextStyle(color: G.muted, fontSize: 13)),
              const SizedBox(height: 32),
              const SizedBox(
                  width: 150,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: LinearProgressIndicator(
                          minHeight: 4,
                          backgroundColor: G.line,
                          valueColor: AlwaysStoppedAnimation(G.accent)))),
            ]),
          ),
        ]),
      );
}
