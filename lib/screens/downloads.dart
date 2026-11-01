import 'package:flutter/material.dart';

import '../fx.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'os_picker.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});
  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  static const _tabs = ['همه', 'در حال دانلود', 'تکمیل شده'];
  int _tab = 0;

  void _catalog() =>
      Navigator.of(context).push(fadeRoute<void>(const OsPickerPage()));

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final all = appState.downloads;
            final list = all.where((d) {
              if (_tab == 1) return d.status != DlStatus.done;
              if (_tab == 2) return d.status == DlStatus.done;
              return true;
            }).toList();
            return Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
                child: Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: G.accent.withValues(alpha: .15),
                    ),
                    child: const Icon(Icons.download_rounded,
                        color: G.accent, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Text('دانلودها',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  RoundIconButton(
                    icon: Icons.add_rounded,
                    bordered: true,
                    color: G.accent,
                    onTap: _catalog,
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: G.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: G.line),
                  ),
                  child: Row(children: [
                    for (var i = 0; i < _tabs.length; i++)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tab = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: i == _tab ? G.gradient : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(_tabs[i],
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: i == _tab ? Colors.white : G.muted,
                                )),
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: list.isEmpty
                    ? EmptyState(
                        icon: Icons.cloud_download_outlined,
                        title: 'دانلودی وجود ندارد',
                        subtitle: 'از کاتالوگ، سیستم‌عامل مورد نظرت را دانلود کن',
                        actionLabel: 'سیستم‌عامل‌ها',
                        onAction: _catalog,
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                        children: [
                          for (var i = 0; i < list.length; i++)
                            FadeSlideIn(
                              key: ValueKey(list[i].distroId),
                              index: i,
                              child: _tile(list[i]),
                            ),
                        ],
                      ),
              ),
            ]);
          },
        ),
      );

  Widget _tile(DownloadItem it) {
    final d = distroById(it.distroId);
    final pct = (it.progress * 100).round();
    final active =
        it.status == DlStatus.downloading || it.status == DlStatus.paused;
    Widget trailing;
    switch (it.status) {
      case DlStatus.downloading:
        trailing = _pauseColumn(
            Icons.pause_rounded, pct, () => appState.pauseDownload(d.id));
        break;
      case DlStatus.paused:
        trailing = _pauseColumn(
            Icons.play_arrow_rounded, pct, () => appState.startDownload(d.id));
        break;
      case DlStatus.queued:
        trailing = const TagPill('در صف');
        break;
      case DlStatus.done:
        trailing = Row(mainAxisSize: MainAxisSize.min, children: [
          const TagPill('تکمیل شد', color: G.green),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: G.muted),
            onPressed: () => appState.removeDownload(d.id),
          ),
        ]);
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GCard(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          DistroBadge(d, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${d.name} ${d.version} (${d.arch})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(formatGb(d.sizeGb),
                      style: const TextStyle(color: G.muted, fontSize: 12.5)),
                  if (active) ...[
                    const SizedBox(height: 8),
                    GBar(value: it.progress, height: 5),
                  ],
                ]),
          ),
          const SizedBox(width: 10),
          trailing,
        ]),
      ),
    );
  }

  Widget _pauseColumn(IconData icon, int pct, VoidCallback onTap) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        RoundIconButton(icon: icon, size: 36, color: G.accentLight, onTap: onTap),
        const SizedBox(height: 2),
        Text('$pct%', style: const TextStyle(color: G.muted, fontSize: 12)),
      ]);
}
