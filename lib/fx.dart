import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';
import 'widgets.dart';

/// Fades and slides its child in once, after a small staggered delay.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.dy = 18,
  });
  final Widget child;
  final int index;
  final double dy;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 440));
  late final Animation<double> _a =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    final delay = math.min(widget.index, 8) * 60;
    Future<void>.delayed(Duration(milliseconds: delay), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _a,
        child: widget.child,
        builder: (context, child) => Opacity(
          opacity: _a.value.clamp(0.0, 1.0).toDouble(),
          child: Transform.translate(
            offset: Offset(0, (1 - _a.value) * widget.dy),
            child: child,
          ),
        ),
      );
}

/// Slightly shrinks its child while a finger is pressing it.
class PressScale extends StatefulWidget {
  const PressScale({
    super.key,
    required this.child,
    this.enabled = true,
    this.scale = .975,
  });
  final Widget child;
  final bool enabled;
  final double scale;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v && mounted) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: widget.enabled ? (_) => _set(true) : null,
        onPointerUp: (_) => _set(false),
        onPointerCancel: (_) => _set(false),
        child: AnimatedScale(
          scale: _down ? widget.scale : 1,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      );
}

/// Pretty placeholder for screens with nothing to show.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          child: FadeSlideIn(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    G.accent.withValues(alpha: .22),
                    G.accent.withValues(alpha: .02),
                  ]),
                  border: Border.all(color: G.accent.withValues(alpha: .25)),
                ),
                child: Icon(icon, size: 46, color: G.accentLight),
              ),
              const SizedBox(height: 20),
              Text(title,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700)),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(subtitle!,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                        color: G.muted, fontSize: 13, height: 1.7)),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 22),
                SizedBox(
                  width: 230,
                  child: GButton(
                    label: actionLabel!,
                    icon: Icons.add_rounded,
                    height: 48,
                    onTap: onAction,
                  ),
                ),
              ],
            ]),
          ),
        ),
      );
}

/// Expanding rings of light (used behind the logo on splash and boot).
class RipplePainter extends CustomPainter {
  const RipplePainter({
    required this.t,
    this.center = const Offset(.5, .45),
    this.base = 56,
    this.spread = 140,
    this.rings = 3,
  });
  final double t;
  final Offset center;
  final double base, spread;
  final int rings;

  @override
  void paint(Canvas canvas, Size s) {
    final c = Offset(s.width * center.dx, s.height * center.dy);
    for (var i = 0; i < rings; i++) {
      final p = (t + i / rings) % 1.0;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = G.accent.withValues(alpha: (1 - p) * .28);
      canvas.drawCircle(c, base + spread * Curves.easeOut.transform(p), paint);
    }
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) =>
      oldDelegate.t != t;
}

/// A light streak sweeping over a track (indeterminate progress).
class IndeterminateBar extends StatefulWidget {
  const IndeterminateBar({super.key, this.width = 170, this.height = 4});
  final double width, height;

  @override
  State<IndeterminateBar> createState() => _IndeterminateBarState();
}

class _IndeterminateBarState extends State<IndeterminateBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1300))
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.height),
          child: ColoredBox(
            color: G.line,
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, _) => Align(
                alignment: Alignment(-1.6 + 3.2 * _c.value, 0),
                child: const FractionallySizedBox(
                  widthFactor: .42,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0x003D9BFF),
                        G.accentLight,
                        Color(0x003D9BFF),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

/// Full-screen animated loading / splash screen.
class GlacierLoader extends StatefulWidget {
  const GlacierLoader({super.key});

  @override
  State<GlacierLoader> createState() => _GlacierLoaderState();
}

class _GlacierLoaderState extends State<GlacierLoader>
    with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200))
    ..forward();
  late final AnimationController _loop = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2600))
    ..repeat();

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AnimatedBuilder(
          animation: Listenable.merge([_intro, _loop]),
          builder: (context, _) {
            final t = Curves.easeOutCubic.transform(_intro.value);
            final pop =
                Curves.easeOutBack.transform(math.min(1.0, _intro.value * 1.25));
            final pulse = .5 + .5 * math.sin(_loop.value * 2 * math.pi);
            return Stack(children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -.25),
                      radius: .85 + .1 * pulse,
                      colors: [
                        G.accent.withValues(alpha: .14 + .08 * pulse),
                        G.bg,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: -70 * (1 - t),
                height: 260,
                child: Opacity(
                    opacity: .55 * t, child: const MountainBackdrop()),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: RipplePainter(
                      t: _loop.value, center: const Offset(.5, .415)),
                ),
              ),
              Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Transform.translate(
                    offset: Offset(0, -6 * pulse),
                    child: Transform.scale(
                      scale: .55 + .45 * pop,
                      child: Opacity(
                          opacity: t, child: const GlacierLogo(size: 108)),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Opacity(
                    opacity: t,
                    child: Text('GLACIER',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 14 - 10 * t,
                        )),
                  ),
                  const SizedBox(height: 8),
                  Opacity(
                    opacity: t,
                    child: const Text(appTagline,
                        style: TextStyle(color: G.muted, fontSize: 13)),
                  ),
                  const SizedBox(height: 34),
                  Opacity(opacity: t, child: const IndeterminateBar()),
                ]),
              ),
            ]);
          },
        ),
      );
}
