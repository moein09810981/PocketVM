import 'package:flutter/material.dart';

import '../actions.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.machine});
  final Machine machine;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _open = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: appState,
            builder: (context, _) {
              final m = widget.machine;
              final d = m.distro;
              return Column(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: GTopBar(title: 'جزئیات ماشین مجازی', back: true),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
                    children: [
                      GCard(
                        radius: 22,
                        padding: const EdgeInsets.all(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF16305A), G.card],
                        ),
                        child: Row(children: [
                          MachineAvatar(m, size: 58),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.name,
                                      style: const TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 2),
                                  Text('${d.full} (${d.arch})',
                                      style: const TextStyle(
                                          color: G.muted, fontSize: 13)),
                                  const SizedBox(height: 8),
                                  StatusPill(appState.statusOf(m)),
                                ]),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      GCard(
                        radius: 16,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SpecText(Icons.memory_rounded,
                                  '${formatGb(m.ram)} RAM'),
                              SpecText(Icons.developer_board_rounded,
                                  '${m.cpu} vCPU'),
                              SpecText(Icons.storage_rounded,
                                  '${m.disk} GB دیسک'),
                            ]),
                      ),
                      const SizedBox(height: 22),
                      InkWell(
                        onTap: () => setState(() => _open = !_open),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(children: [
                            const Text('تنظیمات سریع',
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w700)),
                            const Spacer(),
                            AnimatedRotation(
                              turns: _open ? 0 : -.25,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: G.muted),
                            ),
                          ]),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.topCenter,
                        child: !_open
                            ? const SizedBox(width: double.infinity)
                            : Column(children: [
                                const SizedBox(height: 8),
                                ResourceSlider(
                                  label: 'حافظه',
                                  icon: Icons.memory_rounded,
                                  valueText: formatGb(m.ram),
                                  value: m.ram,
                                  min: .5,
                                  max: 4,
                                  divisions: 7,
                                  enabled: !m.running,
                                  onChanged: (v) {
                                    m.ram = v;
                                    appState.changed(persist: false);
                                  },
                                  onChangeEnd: (_) => appState.save(),
                                ),
                                const SizedBox(height: 10),
                                ResourceSlider(
                                  label: 'پردازنده (vCPU)',
                                  icon: Icons.developer_board_rounded,
                                  valueText: '${m.cpu}',
                                  value: m.cpu.toDouble(),
                                  min: 1,
                                  max: 8,
                                  divisions: 7,
                                  enabled: !m.running,
                                  onChanged: (v) {
                                    m.cpu = v.round();
                                    appState.changed(persist: false);
                                  },
                                  onChangeEnd: (_) => appState.save(),
                                ),
                                const SizedBox(height: 10),
                                ResourceSlider(
                                  label: 'فضای ذخیره‌سازی',
                                  icon: Icons.storage_rounded,
                                  valueText: '${m.disk} GB',
                                  value: m.disk.toDouble(),
                                  min: 4,
                                  max: 128,
                                  divisions: 31,
                                  enabled: !m.running,
                                  onChanged: (v) {
                                    m.disk = v.round();
                                    appState.changed(persist: false);
                                  },
                                  onChangeEnd: (_) => appState.save(),
                                ),
                                if (m.running)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      'برای تغییر منابع ابتدا ماشین را خاموش کنید',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: G.muted, fontSize: 12.5),
                                    ),
                                  ),
                              ]),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
                  child: GButton(
                    label: m.running ? 'کنسول' : 'اجرا',
                    icon: Icons.play_arrow_rounded,
                    onTap: () => launchMachine(context, m),
                  ),
                ),
              ]);
            },
          ),
        ),
      );
}
