import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../actions.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'create.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onNav});
  final ValueChanged<int> onNav;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pc = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final ms = appState.machines;
            final featured = ms.take(4).toList();
            final dots = math.min(ms.length, 4);
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
              children: [
                Row(children: [
                  const GlacierLogo(size: 46),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appName,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1)),
                          SizedBox(height: 2),
                          Text(appTagline,
                              style: TextStyle(fontSize: 12, color: G.muted)),
                        ]),
                  ),
                  RoundIconButton(
                    icon: Icons.settings_outlined,
                    color: G.accent,
                    onTap: () => widget.onNav(3),
                  ),
                ]),
                const SizedBox(height: 18),
                if (featured.isEmpty)
                  _EmptyCard(
                    onCreate: () => Navigator.of(context)
                        .push(fadeRoute<void>(const CreatePage())),
                  )
                else ...[
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      controller: _pc,
                      itemCount: featured.length,
                      onPageChanged: (i) => setState(() => _page = i),
                      itemBuilder: (context, i) => _FeaturedCard(featured[i]),
                    ),
                  ),
                  if (dots > 1) ...[
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      for (var i = 0; i < dots; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _page ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _page ? G.accent : G.line,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                    ]),
                  ],
                ],
                const SizedBox(height: 22),
                Row(children: [
                  const Text('ماشین‌های من',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('${ms.length}',
                      style: const TextStyle(color: G.muted, fontSize: 15)),
                ]),
                const SizedBox(height: 12),
                for (final m in ms) _MachineRow(m),
                const SizedBox(height: 10),
                GCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(children: [
                      const Icon(Icons.storage_rounded, color: G.muted, size: 21),
                      const SizedBox(width: 10),
                      const Text('فضای ذخیره‌سازی',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(
                        '${appState.usedGb.toStringAsFixed(1)} GB / ${AppState.storageLimitGb.toInt()} GB',
                        style: const TextStyle(color: G.muted, fontSize: 13),
                      ),
                    ]),
                    const SizedBox(height: 14),
                    GBar(value: appState.usedGb / AppState.storageLimitGb),
                  ]),
                ),
              ],
            );
          },
        ),
      );
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard(this.m);
  final Machine m;

  @override
  Widget build(BuildContext context) {
    final d = m.distro;
    final running = m.running;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: G.accent.withValues(alpha: .35)),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF12294A), G.card],
        ),
      ),
      child: Stack(children: [
        const Positioned.fill(child: MountainBackdrop()),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, .5, 1],
                colors: [
                  Colors.transparent,
                  G.card.withValues(alpha: .5),
                  G.card,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 18,
          top: 46,
          child: d.id == 'alpine'
              ? const Penguin(size: 92)
              : DistroBadge(d, size: 78),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            StatusPill(appState.statusOf(m)),
            const SizedBox(height: 10),
            Text(m.name,
                style: const TextStyle(
                    fontSize: 34, fontWeight: FontWeight.w800, height: 1.1)),
            const SizedBox(height: 4),
            Text('${d.full} (${d.arch})',
                style: const TextStyle(color: G.muted, fontSize: 14)),
            const Spacer(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SpecText(Icons.memory_rounded, '${formatGb(m.ram)} RAM'),
              SpecText(Icons.developer_board_rounded, '${m.cpu} vCPU'),
              SpecText(Icons.storage_rounded, '${m.disk} GB دیسک'),
            ]),
            const SizedBox(height: 14),
            GButton(
              label: running ? 'کنسول' : 'اجرا',
              icon: Icons.play_arrow_rounded,
              onTap: () => launchMachine(context, m),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _MachineRow extends StatelessWidget {
  const _MachineRow(this.m);
  final Machine m;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GCard(
          onTap: () => openDetails(context, m),
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(children: [
            MachineAvatar(m, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(m.distro.full,
                        style: const TextStyle(color: G.muted, fontSize: 12.5)),
                  ]),
            ),
            StatusPill(appState.statusOf(m)),
            MachineMenu(m),
          ]),
        ),
      );
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => GCard(
        padding: const EdgeInsets.all(22),
        radius: 24,
        child: Column(children: [
          const GlacierLogo(size: 64),
          const SizedBox(height: 14),
          const Text('هنوز ماشینی نداری',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          GButton(
              label: 'ساخت ماشین جدید',
              icon: Icons.add_rounded,
              onTap: onCreate),
        ]),
      );
}
