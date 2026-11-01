import 'package:flutter/material.dart';

import 'screens/downloads.dart';
import 'screens/home.dart';
import 'screens/machines.dart';
import 'screens/settings.dart';
import 'theme.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _i = 0;
  void _go(int i) => setState(() => _i = i);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(onNav: _go),
      const MachinesPage(),
      const DownloadsPage(),
      const SettingsPage(),
    ];
    return Scaffold(
      // A fresh page per tab so its entrance animation plays on every switch.
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        switchInCurve: Curves.easeOut,
        child: KeyedSubtree(key: ValueKey(_i), child: pages[_i]),
      ),
      bottomNavigationBar: _NavBar(index: _i, onTap: _go),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'خانه'),
    (Icons.desktop_windows_outlined, Icons.desktop_windows_rounded, 'ماشین‌ها'),
    (Icons.download_outlined, Icons.download_rounded, 'دانلودها'),
    (Icons.settings_outlined, Icons.settings_rounded, 'تنظیمات'),
  ];

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: G.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: G.line),
            ),
            child: Row(children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: i == index ? 1.12 : 1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          child: Icon(
                            i == index ? _items[i].$2 : _items[i].$1,
                            size: 25,
                            color: i == index ? G.accent : G.muted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _items[i].$3,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight:
                                i == index ? FontWeight.w700 : FontWeight.w500,
                            color: i == index ? G.accent : G.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ]),
          ),
        ),
      );
}
