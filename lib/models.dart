import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OsCategory { linux, android, other }

enum VmStatus { running, ready, stopped }

enum DlStatus { queued, downloading, paused, done }

class Distro {
  const Distro({
    required this.id,
    required this.name,
    required this.tagline,
    required this.version,
    required this.sizeGb,
    required this.category,
    required this.color,
    this.arch = 'ARM64',
    this.icon,
    this.glyph,
  });
  final String id, name, tagline, version, arch;
  final double sizeGb;
  final OsCategory category;
  final Color color;
  final IconData? icon;
  final String? glyph;
  String get full => '$name $version';
}

const List<Distro> distros = [
  Distro(
      id: 'alpine',
      name: 'Alpine Linux',
      tagline: 'سریع و سبک',
      version: '3.20',
      sizeGb: 1.2,
      category: OsCategory.linux,
      color: Color(0xFF0D597F),
      icon: Icons.landscape_rounded),
  Distro(
      id: 'debian',
      name: 'Debian',
      tagline: 'پایدار و حرفه‌ای',
      version: '12',
      sizeGb: 3.8,
      category: OsCategory.linux,
      color: Color(0xFFC9183A),
      icon: Icons.album_rounded),
  Distro(
      id: 'ubuntu',
      name: 'Ubuntu',
      tagline: 'محبوب و قدرتمند',
      version: '24.04',
      sizeGb: 4.1,
      category: OsCategory.linux,
      color: Color(0xFFE95420),
      icon: Icons.workspaces_rounded),
  Distro(
      id: 'fedora',
      name: 'Fedora',
      tagline: 'مدرن و ایمن',
      version: '41',
      sizeGb: 2.2,
      category: OsCategory.linux,
      color: Color(0xFF3C6EB4),
      glyph: 'f'),
  Distro(
      id: 'arch',
      name: 'Arch Linux',
      tagline: 'سریع و مینیمال',
      version: 'Rolling',
      sizeGb: 1.0,
      category: OsCategory.linux,
      color: Color(0xFF1793D1),
      glyph: 'A'),
  Distro(
      id: 'android',
      name: 'Android-x86',
      tagline: 'اندروید روی ماشین مجازی',
      version: '9.0',
      sizeGb: 1.1,
      category: OsCategory.android,
      color: Color(0xFF2FAE6B),
      arch: 'x86_64',
      icon: Icons.android_rounded),
  Distro(
      id: 'freebsd',
      name: 'FreeBSD',
      tagline: 'پایدار و امن',
      version: '14.1',
      sizeGb: 0.9,
      category: OsCategory.other,
      color: Color(0xFFAB2B28),
      glyph: 'F'),
];

Distro distroById(String id) =>
    distros.firstWhere((d) => d.id == id, orElse: () => distros.first);

class Machine {
  Machine({
    required this.id,
    required this.name,
    required this.distroId,
    this.ram = 1.0,
    this.cpu = 2,
    this.disk = 8,
    this.running = false,
  });
  final String id;
  String name;
  final String distroId;
  double ram;
  int cpu;
  int disk;
  bool running;

  Distro get distro => distroById(distroId);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'distro': distroId,
        'ram': ram,
        'cpu': cpu,
        'disk': disk,
      };

  factory Machine.fromJson(Map<String, dynamic> j) => Machine(
        id: j['id'] as String,
        name: j['name'] as String,
        distroId: j['distro'] as String,
        ram: (j['ram'] as num).toDouble(),
        cpu: (j['cpu'] as num).toInt(),
        disk: (j['disk'] as num).toInt(),
      );
}

class DownloadItem {
  DownloadItem({
    required this.distroId,
    this.status = DlStatus.queued,
    this.progress = 0,
  });
  final String distroId;
  DlStatus status;
  double progress;

  Map<String, dynamic> toJson() =>
      {'d': distroId, 's': status.index, 'p': progress};

  factory DownloadItem.fromJson(Map<String, dynamic> j) {
    final idx = (j['s'] as num)
        .toInt()
        .clamp(0, DlStatus.values.length - 1)
        .toInt();
    var s = DlStatus.values[idx];
    if (s == DlStatus.downloading || s == DlStatus.queued) s = DlStatus.paused;
    return DownloadItem(
      distroId: j['d'] as String,
      status: s,
      progress: (j['p'] as num).toDouble(),
    );
  }
}

final appState = AppState();

/// App-wide state. The download queue is a UI placeholder (simulated
/// progress) until the real downloader is written in phase 4.
class AppState extends ChangeNotifier {
  static const storageLimitGb = 32.0;

  final machines = <Machine>[];
  final downloads = <DownloadItem>[];
  bool loaded = false;
  bool notifications = true;
  String perfMode = 'balanced';
  Timer? _ticker;

  Future<void> load() async {
    var restored = false;
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString('glacier.state');
      if (raw != null) {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        machines.addAll((j['machines'] as List)
            .map((e) => Machine.fromJson(e as Map<String, dynamic>)));
        downloads.addAll((j['downloads'] as List)
            .map((e) => DownloadItem.fromJson(e as Map<String, dynamic>)));
        notifications = j['notifications'] as bool? ?? true;
        perfMode = j['perf'] as String? ?? 'balanced';
        restored = true;
      }
    } catch (_) {
      machines.clear();
      downloads.clear();
    }
    if (!restored) _seed();
    await Future<void>.delayed(const Duration(milliseconds: 700));
    loaded = true;
    notifyListeners();
  }

  void _seed() {
    machines
      ..add(Machine(
          id: 'm1',
          name: 'Linux',
          distroId: 'alpine',
          ram: 1.2,
          cpu: 2,
          disk: 8))
      ..add(Machine(
          id: 'm2',
          name: 'Ubuntu',
          distroId: 'ubuntu',
          ram: 1,
          cpu: 1,
          disk: 10))
      ..add(Machine(
          id: 'm3',
          name: 'Debian',
          distroId: 'debian',
          ram: 1,
          cpu: 1,
          disk: 8));
    downloads.add(DownloadItem(
        distroId: 'alpine', status: DlStatus.done, progress: 1));
  }

  Future<void> save() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(
        'glacier.state',
        jsonEncode({
          'machines': machines.map((m) => m.toJson()).toList(),
          'downloads': downloads.map((d) => d.toJson()).toList(),
          'notifications': notifications,
          'perf': perfMode,
        }),
      );
    } catch (_) {
      // UI keeps working if local storage is unavailable.
    }
  }

  void changed({bool persist = true}) {
    notifyListeners();
    if (persist) save();
  }

  // ---------- machines ----------
  Machine addMachine({
    required String name,
    required Distro distro,
    required double ram,
    required int cpu,
    required int disk,
  }) {
    final m = Machine(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      distroId: distro.id,
      ram: ram,
      cpu: cpu,
      disk: disk,
    );
    machines.add(m);
    changed();
    return m;
  }

  void removeMachine(Machine m) {
    machines.remove(m);
    changed();
  }

  void setRunning(Machine m, bool value) {
    m.running = value;
    changed(persist: false);
  }

  VmStatus statusOf(Machine m) {
    if (m.running) return VmStatus.running;
    return isDownloaded(m.distroId) ? VmStatus.ready : VmStatus.stopped;
  }

  double get allocatedGb =>
      machines.fold<int>(0, (s, m) => s + m.disk).toDouble();

  // ---------- downloads ----------
  DownloadItem? downloadOf(String id) {
    for (final d in downloads) {
      if (d.distroId == id) return d;
    }
    return null;
  }

  bool isDownloaded(String id) => downloadOf(id)?.status == DlStatus.done;

  double get usedGb => downloads
      .where((d) => d.status == DlStatus.done)
      .fold<double>(0, (s, d) => s + distroById(d.distroId).sizeGb);

  void startDownload(String id) {
    final d = downloadOf(id);
    if (d == null) {
      downloads.insert(0, DownloadItem(distroId: id));
    } else if (d.status == DlStatus.paused) {
      d.status = DlStatus.queued;
    } else {
      return;
    }
    _ticker ??= Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
    changed();
  }

  void pauseDownload(String id) {
    final d = downloadOf(id);
    if (d == null || d.status == DlStatus.done) return;
    d.status = DlStatus.paused;
    changed();
  }

  void removeDownload(String id) {
    downloads.removeWhere((d) => d.distroId == id);
    changed();
  }

  void _tick() {
    DownloadItem? active;
    for (final d in downloads) {
      if (d.status == DlStatus.downloading) {
        active = d;
        break;
      }
    }
    if (active == null) {
      for (final d in downloads.reversed) {
        if (d.status == DlStatus.queued) {
          active = d;
          d.status = DlStatus.downloading;
          break;
        }
      }
    }
    if (active == null) {
      _ticker?.cancel();
      _ticker = null;
      return;
    }
    active.progress += 0.012;
    if (active.progress >= 1) {
      active.progress = 1;
      active.status = DlStatus.done;
      changed();
    } else {
      notifyListeners();
    }
  }
}
