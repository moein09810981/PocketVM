import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'console.dart';

class BootPage extends StatefulWidget {
  const BootPage({super.key, required this.machine});
  final Machine machine;
  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2800));
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        appState.setRunning(widget.machine, true);
        Navigator.of(context).pushReplacement(
            fadeRoute<void>(ConsolePage(machine: widget.machine)));
      }
    });
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.machine.distro;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragEnd: (e) {
          if ((e.primaryVelocity ?? 0) < -300) Navigator.of(context).maybePop();
        },
        child: Stack(children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -.2),
                  radius: .9,
                  colors: [G.accent.withValues(alpha: .18), G.bg],
                ),
              ),
            ),
          ),
          const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 280,
              child: Opacity(opacity: .55, child: MountainBackdrop())),
          SafeArea(
            child: Column(children: [
              const Spacer(flex: 5),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: G.accent.withValues(alpha: .35),
                        blurRadius: 50,
                        spreadRadius: 2),
                  ],
                ),
                child: MachineAvatar(widget.machine, size: 120),
              ),
              const SizedBox(height: 22),
              Text(d.name,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Starting system...',
                  style: TextStyle(color: G.muted, fontSize: 14)),
              const SizedBox(height: 22),
              SizedBox(
                width: 190,
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => GBar(value: _c.value, height: 5),
                ),
              ),
              const Spacer(flex: 5),
              const Icon(Icons.keyboard_arrow_up_rounded, color: G.muted),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 18),
                child: Text(
                  'برای بازگشت به برنامه، از پایین سوایپ کنید',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: G.muted, fontSize: 12.5),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
