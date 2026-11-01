import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _sheet(BuildContext context, String title, Widget Function() body) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: G.card,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            ListenableBuilder(
                listenable: appState, builder: (context, _) => body()),
          ]),
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [
          Text(k, style: const TextStyle(color: G.muted, fontSize: 14)),
          const Spacer(),
          Text(v,
              style:
                  const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
        ]),
      );

  Widget _note(String t) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(t,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: G.muted, fontSize: 12.5, height: 1.7)),
      );

  Widget _perfOption(String id, String title, String sub) {
    final sel = appState.perfMode == id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GCard(
        radius: 16,
        borderColor: sel ? G.accent : G.line,
        color: sel ? G.accent.withValues(alpha: .09) : G.card2,
        onTap: () {
          appState.perfMode = id;
          appState.changed();
        },
        child: Row(children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(sub,
                      style: const TextStyle(color: G.muted, fontSize: 12.5)),
                ]),
          ),
          RadioDot(selected: sel),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String, VoidCallback)>[
      (
        Icons.settings_outlined,
        'عمومی',
        'زبان، ظاهر، اعلان‌ها',
        () => _sheet(
              context,
              'عمومی',
              () => Column(children: [
                    _kv('زبان', 'فارسی'),
                    _kv('ظاهر', 'آبی کوهستانی'),
                    Row(children: [
                      const Text('اعلان‌ها',
                          style: TextStyle(color: G.muted, fontSize: 14)),
                      const Spacer(),
                      Switch(
                        value: appState.notifications,
                        activeTrackColor: G.accent,
                        onChanged: (v) {
                          appState.notifications = v;
                          appState.changed();
                        },
                      ),
                    ]),
                  ]),
            ),
      ),
      (
        Icons.language_rounded,
        'شبکه',
        'اتصال و دسترسی اینترنت',
        () => _sheet(
              context,
              'شبکه',
              () => _note(
                  'تنظیمات شبکهٔ ماشین‌ها پس از اتصال موتور QEMU فعال می‌شود'),
            ),
      ),
      (
        Icons.inventory_2_outlined,
        'ذخیره‌سازی',
        'مدیریت فضای ذخیره‌سازی',
        () => _sheet(
              context,
              'ذخیره‌سازی',
              () => Column(children: [
                    _kv('ایمج‌های دانلودشده',
                        '${appState.usedGb.toStringAsFixed(1)} GB'),
                    _kv('تعداد ماشین‌ها', '${appState.machines.length}'),
                    _kv('دیسک اختصاص‌یافته',
                        '${appState.allocatedGb.toInt()} GB'),
                  ]),
            ),
      ),
      (
        Icons.speed_rounded,
        'عملکرد',
        'مدیریت و بهینه‌سازی',
        () => _sheet(
              context,
              'عملکرد',
              () => Column(children: [
                    _perfOption('balanced', 'متعادل',
                        'تعادل بین سرعت و مصرف باتری'),
                    _perfOption('fps', 'حداکثر FPS',
                        'بیشترین سرعت، گرما و مصرف بیشتر'),
                    _perfOption('battery', 'صرفه‌جویی باتری',
                        'سرعت کمتر، مصرف کمتر'),
                  ]),
            ),
      ),
      (
        Icons.info_outline_rounded,
        'درباره',
        'نسخه و اطلاعات برنامه',
        () => _sheet(
              context,
              'درباره',
              () => Column(children: [
                    const GlacierLogo(size: 64),
                    const SizedBox(height: 12),
                    const Text(appName,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('v$appVersion',
                        style: TextStyle(color: G.muted, fontSize: 13)),
                    _note(
                        'نسخهٔ فعلی نمونهٔ رابط کاربری است و هنوز سیستم‌عامل مهمان را اجرا نمی‌کند'),
                  ]),
            ),
      ),
    ];
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        children: [
          const Text('تنظیمات',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),
          for (final it in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GCard(
                onTap: it.$4,
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: G.card2,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(it.$1, color: G.accentLight, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it.$2,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(it.$3,
                              style: const TextStyle(
                                  color: G.muted, fontSize: 12.5)),
                        ]),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: G.muted),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}
