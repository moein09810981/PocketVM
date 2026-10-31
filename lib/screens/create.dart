import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'os_picker.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // Visual order (left to right): سایر | دیسک | پیکربندی | سیستم‌عامل
  static const _tabs = ['سیستم‌عامل', 'پیکربندی', 'دیسک', 'سایر'];

  int _tab = 0;
  Distro _distro = distros.first;
  final _name = TextEditingController();
  double _ram = 1.0;
  int _cpu = 2;
  int _disk = 8;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final d = await Navigator.of(context)
        .push<Distro>(fadeRoute<Distro>(const OsPickerPage(selectMode: true)));
    if (d != null && mounted) setState(() => _distro = d);
  }

  void _next() {
    if (_tab < _tabs.length - 1) {
      setState(() => _tab++);
      return;
    }
    final text = _name.text.trim();
    appState.addMachine(
      name: text.isEmpty ? _distro.name : text,
      distro: _distro,
      ram: _ram,
      cpu: _cpu,
      disk: _disk,
    );
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    if (appState.notifications) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text('ماشین جدید ساخته شد',
                textDirection: TextDirection.rtl)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = _tab == _tabs.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: GTopBar(title: 'ساخت ماشین مجازی', back: true),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
            child: GCard(
              onTap: _pick,
              radius: 22,
              padding: const EdgeInsets.all(14),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF16305A), G.card],
              ),
              child: Row(children: [
                DistroAvatar(_distro, size: 56),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            _distro.id == 'alpine' ? 'Linux' : _distro.name,
                            style: const TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        const Text('انتخاب سیستم‌عامل',
                            style: TextStyle(color: G.muted, fontSize: 13)),
                      ]),
                ),
                const Icon(Icons.unfold_more_rounded, color: G.muted),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: G.line))),
              child: Row(children: [
                for (final i in [3, 2, 1, 0])
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _tab = i),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(_tabs[i],
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: i == _tab ? G.accent : G.muted,
                              )),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2.5,
                          color: i == _tab ? G.accent : Colors.transparent,
                        ),
                      ]),
                    ),
                  ),
              ]),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: ListView(
                key: ValueKey(_tab),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                children: _content(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
            child: GButton(
              label: last ? 'ساخت ماشین' : 'ادامه',
              icon: last ? Icons.check_rounded : Icons.play_arrow_rounded,
              onTap: _next,
            ),
          ),
        ]),
      ),
    );
  }

  List<Widget> _content() {
    switch (_tab) {
      case 0:
        final opts = distros
            .where((d) => d.category == OsCategory.linux)
            .take(4)
            .toList();
        if (!opts.any((d) => d.id == _distro.id)) opts.insert(0, _distro);
        return [
          const Align(
            alignment: Alignment.centerRight,
            child: Text('انتخاب توزیع',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 12),
          for (final d in opts) _distroTile(d),
        ];
      case 1:
        return [
          TextField(
            controller: _name,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'نام ماشین',
              hintStyle: const TextStyle(color: G.muted),
              filled: true,
              fillColor: G.card,
              prefixIcon: const Icon(Icons.edit_outlined, color: G.muted),
              border: _border(G.line),
              enabledBorder: _border(G.line),
              focusedBorder: _border(G.accent),
            ),
          ),
          const SizedBox(height: 14),
          ResourceSlider(
            label: 'حافظه',
            icon: Icons.memory_rounded,
            valueText: formatGb(_ram),
            value: _ram,
            min: .5,
            max: 4,
            divisions: 7,
            onChanged: (v) => setState(() => _ram = v),
          ),
          const SizedBox(height: 10),
          ResourceSlider(
            label: 'پردازنده (vCPU)',
            icon: Icons.developer_board_rounded,
            valueText: '$_cpu',
            value: _cpu.toDouble(),
            min: 1,
            max: 8,
            divisions: 7,
            onChanged: (v) => setState(() => _cpu = v.round()),
          ),
        ];
      case 2:
        return [
          ResourceSlider(
            label: 'فضای ذخیره‌سازی',
            icon: Icons.storage_rounded,
            valueText: '$_disk GB',
            value: _disk.toDouble(),
            min: 4,
            max: 128,
            divisions: 31,
            onChanged: (v) => setState(() => _disk = v.round()),
          ),
          const SizedBox(height: 12),
          const Text(
            'ظرفیت دیسک مجازی ماشین؛ فضای واقعی فقط به اندازهٔ استفاده مصرف می‌شود',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: G.muted, fontSize: 12.5, height: 1.7),
          ),
        ];
      default:
        final name = _name.text.trim().isEmpty ? _distro.name : _name.text.trim();
        return [
          GCard(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _row('نام', name),
              _row('سیستم‌عامل', '${_distro.full} (${_distro.arch})'),
              _row('حافظه', formatGb(_ram)),
              _row('پردازنده', '$_cpu vCPU'),
              _row('دیسک', '$_disk GB'),
            ]),
          ),
        ];
    }
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c),
      );

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Text(k, style: const TextStyle(color: G.muted, fontSize: 14)),
          const Spacer(),
          Text(v, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
        ]),
      );

  Widget _distroTile(Distro d) {
    final sel = d.id == _distro.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GCard(
        onTap: () => setState(() => _distro = d),
        borderColor: sel ? G.accent : G.line,
        color: sel ? G.accent.withValues(alpha: .09) : G.card,
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          DistroBadge(d, size: 48),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text('${d.tagline} · ${d.arch}',
                      style: const TextStyle(color: G.muted, fontSize: 12.5)),
                ]),
          ),
          RadioDot(selected: sel),
        ]),
      ),
    );
  }
}
