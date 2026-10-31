import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Console preview. The text below is a placeholder until QEMU is connected
/// and a real serial/VNC display is attached (phase 5).
class ConsolePage extends StatefulWidget {
  const ConsolePage({super.key, required this.machine});
  final Machine machine;
  @override
  State<ConsolePage> createState() => _ConsolePageState();
}

class _ConsolePageState extends State<ConsolePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _blink.dispose();
    super.dispose();
  }

  void _soon() => showMsg(context, 'به‌زودی');

  @override
  Widget build(BuildContext context) {
    final m = widget.machine;
    final d = m.distro;
    const mono = TextStyle(
      fontFamily: 'monospace',
      fontSize: 13,
      height: 1.55,
      color: Color(0xFFD7E3F4),
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(children: [
            Row(children: [
              MachineAvatar(m, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                      const Text('در حال اجرا',
                          style: TextStyle(
                              color: G.green,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ]),
              ),
              Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: G.gradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      appState.setRunning(m, false);
                      Navigator.of(context).pop();
                    },
                    child: const SizedBox(
                      width: 46,
                      height: 46,
                      child: Icon(Icons.stop_rounded,
                          color: G.onAccent, size: 26),
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerRight,
              child: TagPill('پیش‌نمایش — موتور QEMU هنوز متصل نیست',
                  color: G.accentLight),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF02050A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: G.line),
                ),
                child: SingleChildScrollView(
                  child: AnimatedBuilder(
                    animation: _blink,
                    builder: (context, _) => Text.rich(
                      TextSpan(style: mono, children: [
                        TextSpan(
                            text: 'Welcome to ${d.name} ${d.version}!\n'
                                'Kernel 6.6.28-0-lts on an aarch64 (tty1)\n\n'
                                '${d.id} login: '),
                        TextSpan(
                          text: '_',
                          style: TextStyle(
                              color: Colors.white
                                  .withValues(alpha: _blink.value)),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GCard(
              radius: 20,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: Row(children: [
                _Tool(Icons.keyboard_alt_outlined, 'صفحه‌کلید', _soon),
                _Tool(Icons.photo_camera_outlined, 'اسکرین‌شات', _soon),
                _Tool(Icons.settings_outlined, 'تنظیمات', _soon),
                _Tool(Icons.fullscreen_rounded, 'تمام‌صفحه', _soon),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Tool extends StatelessWidget {
  const _Tool(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              Icon(icon, color: G.accentLight, size: 24),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 11.5)),
            ]),
          ),
        ),
      );
}
