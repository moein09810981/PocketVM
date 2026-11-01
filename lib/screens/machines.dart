import 'package:flutter/material.dart';

import '../actions.dart';
import '../fx.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'create.dart';

class MachinesPage extends StatelessWidget {
  const MachinesPage({super.key});

  void _create(BuildContext context) =>
      Navigator.of(context).push(fadeRoute<void>(const CreatePage()));

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final ms = appState.machines;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: GTopBar(
                  title: 'ماشین‌های من',
                  action: RoundIconButton(
                    icon: Icons.add_rounded,
                    bordered: true,
                    color: G.accent,
                    onTap: () => _create(context),
                  ),
                ),
              ),
              Expanded(
                child: ms.isEmpty
                    ? EmptyState(
                        icon: Icons.desktop_windows_outlined,
                        title: 'هنوز ماشینی نساخته‌ای',
                        subtitle:
                            'یک ماشین مجازی بساز و سیستم‌عامل دلخواهت را روی گوشی اجرا کن',
                        actionLabel: 'ساخت ماشین جدید',
                        onAction: () => _create(context),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                        children: [
                          for (var i = 0; i < ms.length; i++)
                            FadeSlideIn(
                                index: i, child: _MachineCard(ms[i])),
                          const SizedBox(height: 6),
                          FadeSlideIn(
                            index: ms.length,
                            child: GCard(
                              padding: const EdgeInsets.all(16),
                              child: Column(children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      'تعداد ماشین‌ها  ${ms.length}',
                                      style: const TextStyle(
                                          color: G.muted, fontSize: 13)),
                                ),
                                const SizedBox(height: 10),
                                Row(children: [
                                  const Text('فضای اختصاص‌یافته',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Text(
                                    '${appState.allocatedGb.toInt()} GB / ${AppState.storageLimitGb.toInt()} GB',
                                    style: const TextStyle(
                                        color: G.muted, fontSize: 13),
                                  ),
                                ]),
                                const SizedBox(height: 12),
                                GBar(
                                    value: appState.allocatedGb /
                                        AppState.storageLimitGb),
                              ]),
                            ),
                          ),
                        ],
                      ),
              ),
            ]);
          },
        ),
      );
}

class _MachineCard extends StatelessWidget {
  const _MachineCard(this.m);
  final Machine m;

  Widget _chip(IconData icon, String text) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
          decoration: BoxDecoration(
            color: G.card2,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 15, color: G.muted),
            const SizedBox(width: 5),
            Flexible(
              child: Text(text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12)),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GCard(
          radius: 20,
          borderColor: m.running ? G.accent : G.line,
          onTap: () => openDetails(context, m),
          padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
          child: Column(children: [
            Row(children: [
              MachineAvatar(m, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(m.distro.full,
                          style:
                              const TextStyle(color: G.muted, fontSize: 13)),
                    ]),
              ),
              StatusPill(appState.statusOf(m)),
              MachineMenu(m),
            ]),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(children: [
                _chip(Icons.memory_rounded, '${formatGb(m.ram)} RAM'),
                const SizedBox(width: 8),
                _chip(Icons.developer_board_rounded, '${m.cpu} vCPU'),
                const SizedBox(width: 8),
                _chip(Icons.storage_rounded, '${m.disk} GB دیسک'),
              ]),
            ),
          ]),
        ),
      );
}
