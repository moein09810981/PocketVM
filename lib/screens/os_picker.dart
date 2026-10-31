import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class OsPickerPage extends StatefulWidget {
  const OsPickerPage({super.key, this.selectMode = false});

  /// true: tapping returns the chosen distro (used by the create screen).
  /// false: catalog mode, tapping the download button starts a download.
  final bool selectMode;

  @override
  State<OsPickerPage> createState() => _OsPickerPageState();
}

class _OsPickerPageState extends State<OsPickerPage> {
  OsCategory? _filter;

  @override
  Widget build(BuildContext context) {
    final chips = <(String, OsCategory?)>[
      ('سایر', OsCategory.other),
      ('اندروید', OsCategory.android),
      ('لینوکس', OsCategory.linux),
      ('همه', null),
    ];
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final list = distros
                .where((d) => _filter == null || d.category == _filter)
                .toList();
            return Column(children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: GTopBar(title: 'انتخاب سیستم‌عامل', back: true),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
                child: Row(children: [
                  for (final c in chips)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () => setState(() => _filter = c.$2),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: _filter == c.$2 ? G.gradient : null,
                              color: _filter == c.$2 ? null : G.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: _filter == c.$2
                                      ? Colors.transparent
                                      : G.line),
                            ),
                            child: Text(c.$1,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      _filter == c.$2 ? Colors.white : G.muted,
                                )),
                          ),
                        ),
                      ),
                    ),
                ]),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                  children: [for (final d in list) _tile(context, d)],
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }

  Widget _trailing(Distro d) {
    if (widget.selectMode) return const SizedBox.shrink();
    final it = appState.downloadOf(d.id);
    if (it?.status == DlStatus.done) {
      return const Icon(Icons.check_circle_rounded, color: G.green, size: 26);
    }
    if (it != null && it.status != DlStatus.paused) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.6,
          value: it.status == DlStatus.downloading ? it.progress : null,
          color: G.accent,
          backgroundColor: G.line,
        ),
      );
    }
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: G.accent.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: G.accent.withValues(alpha: .4)),
      ),
      child: const Icon(Icons.download_rounded, color: G.accent, size: 22),
    );
  }

  Widget _tile(BuildContext context, Distro d) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GCard(
          padding: const EdgeInsets.all(12),
          onTap: () {
            if (widget.selectMode) {
              Navigator.of(context).pop(d);
              return;
            }
            if (appState.isDownloaded(d.id)) {
              showMsg(context, '${d.name} قبلاً دانلود شده است');
            } else {
              appState.startDownload(d.id);
              showMsg(context, 'دانلود ${d.name} شروع شد');
            }
          },
          child: Row(children: [
            DistroBadge(d, size: 50),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.name,
                        style: const TextStyle(
                            fontSize: 15.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('${d.version} (${d.arch})',
                        style: const TextStyle(color: G.muted, fontSize: 12)),
                    Text(d.tagline,
                        style: const TextStyle(color: G.muted, fontSize: 12)),
                  ]),
            ),
            _trailing(d),
          ]),
        ),
      );
}
