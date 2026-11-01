import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../fx.dart';
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

class _BootPageState extends State<BootPage> with TickerProviderStateMixin {
  late final AnimationController _c;
  late final AnimationController _loop;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3200));
    _loop = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat();
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
    _loop.dispose();
    super.dispose();
  }

  String _stage(double v) {
    if (v < .22) return 'Loading kernel...';
    if (v < .48) return 'Mounting filesystems...';
    if (v < .74) return 'Starting services...';
    return 'Starting system...';
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
        child: AnimatedBuilder(
          animation: Listenable.merge([_c, _loop]),
          builder: (context, _) {
            final pulse = .5 + .5 * math.sin(_loop.value * 2 * math.pi);
            final stage = _stage(_c.value);
            return Stack(children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -.2),
                      radius: .9,
                      colors: [
                        G.accent.withValues(alpha: .14 + .08 * pulse),
                        G.bg,
                      ],
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
              Positioned.fill(
                child: CustomPaint(
                  painter: RipplePainter(
                      t: _loop.value,
                      center: const Offset(.5, .385),
                      base: 70,
                      spread: 150),
                ),
              ),
              SafeArea(
                child: Column(children: [
                  const Spacer(flex: 5),
                  Transform.scale(
                    scale: 1 + .035 * pulse,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: G.accent.withValues(alpha: .25 + .2 * pulse),
                              blurRadius: 40 + 20 * pulse,
                              spreadRadius: 2),
                        ],
                      ),
                      child: MachineAvatar(widget.machine, size: 120),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(d.name,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 22,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(stage,
                          key: ValueKey(stage),
                          style:
                              const TextStyle(color: G.muted, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(width: 200, child: GBar(value: _c.value, height: 5)),
                  const SizedBox(height: 10),
                  Text('${(_c.value * 100).round()}%',
                      style: const TextStyle(color: G.muted, fontSize: 12.5)),
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
            ]);
          },
        ),
      ),
    );
  }
}
