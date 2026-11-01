import 'package:flutter/material.dart';

import 'fx.dart';
import 'models.dart';
import 'theme.dart';

String formatGb(double v) =>
    v == v.roundToDouble() ? '${v.toInt()} GB' : '${v.toStringAsFixed(1)} GB';

Route<T> fadeRoute<T>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, a, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
        child: child,
      ),
    );

void showMsg(BuildContext context, String text,
    {SnackBarAction? action, bool force = false}) {
  if (!force && !appState.notifications) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(text, textDirection: TextDirection.rtl),
      action: action,
    ));
}

Path _poly(List<Offset> pts) {
  final p = Path()..moveTo(pts.first.dx, pts.first.dy);
  for (final o in pts.skip(1)) {
    p.lineTo(o.dx, o.dy);
  }
  return p..close();
}

// ---------------------------------------------------------------- logo
class GlacierLogo extends StatelessWidget {
  const GlacierLogo({super.key, this.size = 44});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size, height: size, child: CustomPaint(painter: _LogoPainter()));
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    Offset o(double x, double y) => Offset(x * w, y * h);
    final rect = Offset.zero & s;
    canvas.drawPath(
      _poly([o(.42, .92), o(.72, .40), o(1.0, .92)]),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [G.accentLight, G.accent],
        ).createShader(rect),
    );
    canvas.drawPath(
      _poly([o(0, .92), o(.36, .2), o(.74, .92)]),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [G.accent, G.accentDeep],
        ).createShader(rect),
    );
    canvas.drawPath(
      _poly([
        o(.36, .2),
        o(.25, .42),
        o(.32, .38),
        o(.37, .47),
        o(.43, .38),
        o(.48, .43),
      ]),
      Paint()..color = Colors.white.withValues(alpha: .92),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------- mountains
class MountainBackdrop extends StatelessWidget {
  const MountainBackdrop({super.key});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _MountainPainter(), size: Size.infinite);
}

class _MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    Offset o(double x, double y) => Offset(x * w, y * h);
    Path ridge(List<Offset> pts) {
      final p = Path()..moveTo(0, h);
      for (final q in pts) {
        p.lineTo(q.dx, q.dy);
      }
      p.lineTo(w, h);
      return p..close();
    }

    final rect = Offset.zero & s;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(.5, -.7),
          radius: 1.1,
          colors: [Color(0x553D9BFF), Color(0x00050A12)],
        ).createShader(rect),
    );
    final star = Paint()..color = Colors.white.withValues(alpha: .55);
    for (final p in const [
      Offset(.12, .14),
      Offset(.28, .08),
      Offset(.72, .1),
      Offset(.9, .2),
      Offset(.62, .05),
    ]) {
      canvas.drawCircle(o(p.dx, p.dy), 1.2, star);
    }
    canvas.drawPath(
      ridge([
        o(0, .62),
        o(.14, .46),
        o(.26, .58),
        o(.46, .2),
        o(.6, .42),
        o(.7, .34),
        o(.86, .55),
        o(1, .44),
      ]),
      Paint()..color = const Color(0xFF1B3A66).withValues(alpha: .8),
    );
    canvas.drawPath(
      _poly([
        o(.46, .2),
        o(.39, .33),
        o(.44, .30),
        o(.47, .36),
        o(.51, .30),
        o(.55, .34),
      ]),
      Paint()..color = Colors.white.withValues(alpha: .85),
    );
    canvas.drawPath(
      ridge([
        o(0, .82),
        o(.2, .66),
        o(.38, .78),
        o(.62, .6),
        o(.82, .74),
        o(1, .64),
      ]),
      Paint()..color = const Color(0xFF0F2342).withValues(alpha: .92),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------- penguin
class Penguin extends StatelessWidget {
  const Penguin({super.key, this.size = 80});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size, height: size, child: CustomPaint(painter: _PenguinPainter()));
}

class _PenguinPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    Rect r(double l, double t, double ww, double hh) =>
        Rect.fromLTWH(l * w, t * h, ww * w, hh * h);
    const dark = Color(0xFF151A24);
    final orange = Paint()..color = const Color(0xFFFFA726);
    c.drawOval(r(.16, .84, .30, .13), orange);
    c.drawOval(r(.54, .84, .30, .13), orange);
    c.drawOval(r(.03, .40, .16, .36), Paint()..color = dark);
    c.drawOval(r(.81, .40, .16, .36), Paint()..color = dark);
    c.drawOval(r(.12, .04, .76, .86), Paint()..color = dark);
    c.drawOval(r(.27, .40, .46, .48), Paint()..color = const Color(0xFFF2F4F8));
    final white = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF0B0F16);
    c.drawCircle(Offset(.40 * w, .27 * h), w * .065, white);
    c.drawCircle(Offset(.60 * w, .27 * h), w * .065, white);
    c.drawCircle(Offset(.41 * w, .28 * h), w * .03, pupil);
    c.drawCircle(Offset(.59 * w, .28 * h), w * .03, pupil);
    c.drawOval(r(.40, .34, .20, .09), orange);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------- badges
class DistroBadge extends StatelessWidget {
  const DistroBadge(this.d, {super.key, this.size = 46});
  final Distro d;
  final double size;
  @override
  Widget build(BuildContext context) {
    final Widget inner = d.glyph != null
        ? Text(d.glyph!,
            style: TextStyle(
                color: Colors.white,
                fontSize: size * .55,
                fontWeight: FontWeight.w900,
                height: 1))
        : Icon(d.icon, color: Colors.white, size: size * .55);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * .28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [d.color, Color.lerp(d.color, Colors.black, .4)!],
        ),
      ),
      child: inner,
    );
  }
}

/// Alpine is shown as the generic "Linux" penguin, like the mockup.
class DistroAvatar extends StatelessWidget {
  const DistroAvatar(this.d, {super.key, this.size = 48});
  final Distro d;
  final double size;
  @override
  Widget build(BuildContext context) {
    if (d.id == 'alpine') {
      return Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * .1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF16233A),
          border: Border.all(color: G.line),
        ),
        child: const Penguin(),
      );
    }
    return DistroBadge(d, size: size);
  }
}

class MachineAvatar extends StatelessWidget {
  const MachineAvatar(this.machine, {super.key, this.size = 48});
  final Machine machine;
  final double size;
  @override
  Widget build(BuildContext context) =>
      DistroAvatar(machine.distro, size: size);
}

class TagPill extends StatelessWidget {
  const TagPill(this.text, {super.key, this.color = G.muted, this.dot = false});
  final String text;
  final Color color;
  final bool dot;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (dot) ...[
            Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
          ],
          Text(text,
              style: TextStyle(
                  color: color, fontSize: 12.5, fontWeight: FontWeight.w600)),
        ]),
      );
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.status, {super.key});
  final VmStatus status;
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case VmStatus.running:
        return const TagPill('در حال اجرا', color: G.green, dot: true);
      case VmStatus.ready:
        return const TagPill('آماده', color: G.green, dot: true);
      case VmStatus.stopped:
        return const TagPill('متوقف');
    }
  }
}

class SpecText extends StatelessWidget {
  const SpecText(this.icon, this.text, {super.key});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 17, color: G.muted),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12.5)),
      ]);
}

class RadioDot extends StatelessWidget {
  const RadioDot({super.key, required this.selected});
  final bool selected;
  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: selected ? G.accent : G.line, width: 2),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: selected ? 12 : 0,
          height: selected ? 12 : 0,
          decoration:
              const BoxDecoration(color: G.accent, shape: BoxShape.circle),
        ),
      );
}

// ---------------------------------------------------------------- layout
class GCard extends StatelessWidget {
  const GCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 18,
    this.color,
    this.borderColor,
    this.gradient,
    this.onTap,
  });
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color? color;
  final Color? borderColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(radius);
    return PressScale(
      enabled: onTap != null,
      child: Material(
        color: Colors.transparent,
        borderRadius: br,
        child: Ink(
          decoration: BoxDecoration(
            color: gradient == null ? (color ?? G.card) : null,
            gradient: gradient,
            borderRadius: br,
            border: Border.all(color: borderColor ?? G.line),
          ),
          child: InkWell(
            borderRadius: br,
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// Main action button. The primary style has a soft pulsing glow.
class GButton extends StatefulWidget {
  const GButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.outlined = false,
    this.height = 54,
  });
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool outlined;
  final double height;

  @override
  State<GButton> createState() => _GButtonState();
}

class _GButtonState extends State<GButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glow = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1900));

  bool get _wantsGlow => !widget.outlined && widget.onTap != null;

  @override
  void initState() {
    super.initState();
    if (_wantsGlow) _glow.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant GButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_wantsGlow && !_glow.isAnimating) {
      _glow.repeat(reverse: true);
    } else if (!_wantsGlow && _glow.isAnimating) {
      _glow.stop();
    }
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fg = widget.outlined ? G.text : G.onAccent;
    final br = BorderRadius.circular(17);
    return PressScale(
      scale: .97,
      enabled: widget.onTap != null,
      child: Opacity(
        opacity: widget.onTap == null ? .5 : 1,
        child: AnimatedBuilder(
          animation: _glow,
          child: InkWell(
            borderRadius: br,
            onTap: widget.onTap,
            child: SizedBox(
              height: widget.height,
              child: Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 24, color: fg),
                    const SizedBox(width: 8),
                  ],
                  Text(widget.label,
                      style: TextStyle(
                          color: fg, fontSize: 17, fontWeight: FontWeight.w800)),
                ]),
              ),
            ),
          ),
          builder: (context, child) {
            final g = Curves.easeInOut.transform(_glow.value);
            return Material(
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: widget.outlined ? null : G.gradient,
                  color: widget.outlined ? G.card2 : null,
                  borderRadius: br,
                  boxShadow: widget.outlined
                      ? null
                      : [
                          BoxShadow(
                              color: G.accent.withValues(alpha: .18 + .22 * g),
                              blurRadius: 14 + 12 * g,
                              offset: const Offset(0, 6)),
                        ],
                ),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.bordered = false,
    this.size = 42,
  });
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final bool bordered;
  final double size;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bordered ? G.accent.withValues(alpha: .1) : null,
              border: bordered ? Border.all(color: G.accent, width: 1.4) : null,
            ),
            child: Icon(icon, color: color ?? G.text, size: size * .55),
          ),
        ),
      );
}

class GTopBar extends StatelessWidget {
  const GTopBar({super.key, required this.title, this.back = false, this.action});
  final String title;
  final bool back;
  final Widget? action;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 60,
        child: Stack(alignment: Alignment.center, children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          if (back)
            Align(
              alignment: Alignment.centerLeft,
              child: RoundIconButton(
                icon: Icons.chevron_left_rounded,
                size: 44,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
          if (action != null)
            Align(alignment: Alignment.centerRight, child: action),
        ]),
      );
}

class GBar extends StatelessWidget {
  const GBar({super.key, required this.value, this.height = 6});
  final double value;
  final double height;
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: Container(
          height: height,
          color: G.line,
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0).toDouble(),
            heightFactor: 1,
            child: const DecoratedBox(
                decoration: BoxDecoration(gradient: G.gradient)),
          ),
        ),
      );
}

class ResourceSlider extends StatelessWidget {
  const ResourceSlider({
    super.key,
    required this.label,
    required this.icon,
    required this.valueText,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.onChangeEnd,
    this.enabled = true,
  });
  final String label, valueText;
  final IconData icon;
  final double value, min, max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;
  final bool enabled;

  @override
  Widget build(BuildContext context) => GCard(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 4),
        radius: 16,
        child: Column(children: [
          Row(children: [
            Icon(icon, size: 19, color: G.muted),
            const SizedBox(width: 10),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.w600))),
            Text(valueText,
                style: const TextStyle(color: G.muted, fontSize: 13)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: G.muted, size: 20),
          ]),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(trackHeight: 3),
            child: Slider(
              value: value.clamp(min, max).toDouble(),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: enabled ? onChanged : null,
              onChangeEnd: enabled ? onChangeEnd : null,
            ),
          ),
        ]),
      );
}
