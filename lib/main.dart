import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bg = Color(0xFF0B0A09), panel = Color(0xFF171615), panel2 = Color(0xFF22201E);
const accent = Color(0xFFFF650D), muted = Color(0xFFA6A09B), green = Color(0xFF59D69B), blue = Color(0xFF7BA8FF), line = Color(0xFF2B2825);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: bg, statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF11100F), systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const PocketVM());
}

class PocketVM extends StatelessWidget {
  const PocketVM({super.key});
  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark();
    return MaterialApp(
      debugShowCheckedModeBanner: false, title: 'ورچینو',
      theme: base.copyWith(
        scaffoldBackgroundColor: bg,
        textTheme: GoogleFonts.vazirmatnTextTheme(base.textTheme),
        primaryTextTheme: GoogleFonts.vazirmatnTextTheme(base.primaryTextTheme),
        colorScheme: const ColorScheme.dark(primary: accent, surface: panel, secondary: green),
        dividerColor: line,
        navigationBarTheme: const NavigationBarThemeData(
          height: 72, backgroundColor: Color(0xFF11100F), indicatorColor: Color(0x33FF650D),
          labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          iconTheme: WidgetStatePropertyAll(IconThemeData(size: 22)),
        ),
        filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
          minimumSize: const Size(0, 47), backgroundColor: accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13))),
        outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white, side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))),
        sliderTheme: const SliderThemeData(activeTrackColor: accent, thumbColor: accent, inactiveTrackColor: line, trackHeight: 3),
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating, backgroundColor: panel2),
      ),
      home: const Dashboard(),
    );
  }
}


class PocketVMLoadingScreen extends StatefulWidget {
  const PocketVMLoadingScreen({super.key});

  @override
  State<PocketVMLoadingScreen> createState() => _PocketVMLoadingScreenState();
}

class _PocketVMLoadingScreenState extends State<PocketVMLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Positioned(
            top: -110,
            right: -90,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: .07),
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -100,
            child: Container(
              width: 330,
              height: 330,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: blue.withValues(alpha: .045),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final pulse = .92 + (_controller.value < .5
                    ? _controller.value
                    : 1 - _controller.value) * .16;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 124,
                      height: 124,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.scale(
                            scale: .92 + _controller.value * .24,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: accent.withValues(
                                    alpha: (1 - _controller.value) * .42,
                                  ),
                                  width: 1.4,
                                ),
                              ),
                            ),
                          ),
                          Transform.rotate(
                            angle: _controller.value * 6.28318,
                            child: SizedBox(
                              width: 104,
                              height: 104,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                value: _controller.value,
                                backgroundColor: line,
                                valueColor: const AlwaysStoppedAnimation<Color>(accent),
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: pulse,
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFFFF922E), Color(0xFFFF5A00)],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.withValues(alpha: .28),
                                    blurRadius: 28,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.developer_board_rounded,
                                color: Color(0xFF200C0A),
                                size: 39,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'ورچینو',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .3,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'محیط مجازی، مرتب و ساده',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                    const SizedBox(height: 34),
                    SizedBox(
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          minHeight: 3,
                          value: null,
                          backgroundColor: line,
                          valueColor: const AlwaysStoppedAnimation<Color>(accent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'در حال آماده‌سازی محیط…',
                      style: TextStyle(color: Color(0xFF777F90), fontSize: 10),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Machine {
  String name, os;
  int ram, cpu, disk;
  bool running;
  Machine(this.name, this.os, this.ram, this.cpu, this.disk, {this.running = false});
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int page = 0, ram = 2, cpu = 2, disk = 16;
  String os = 'Ubuntu';
  String machineFilter = 'همه';
  String machineSearch = '';

  List<Machine> get visibleMachines => machines.where((m) {
    final statusMatches = machineFilter == 'همه' ||
        (machineFilter == 'روشن' && m.running) ||
        (machineFilter == 'خاموش' && !m.running);
    final query = machineSearch.trim().toLowerCase();
    final searchMatches = query.isEmpty ||
        m.name.toLowerCase().contains(query) ||
        m.os.toLowerCase().contains(query);
    return statusMatches && searchMatches;
  }).toList();
  bool compact = false, notifications = true;
  final machines = <Machine>[];
  final logs = <String>[];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('pocketvm.machines');
      if (saved != null) {
        final decoded = jsonDecode(saved) as List<dynamic>;
        machines
          ..clear()
          ..addAll(decoded.map((item) {
            final m = item as Map<String, dynamic>;
            return Machine(m['name'] as String, m['os'] as String,
              m['ram'] as int, m['cpu'] as int, m['disk'] as int,
              running: false);
          }));
      }
      if (machines.isEmpty) {
        machines.add(Machine('Ubuntu Linux', 'Ubuntu', 2, 2, 16));
      }
      compact = prefs.getBool('pocketvm.compact') ?? false;
      notifications = prefs.getBool('pocketvm.notifications') ?? true;
      final savedLogs = prefs.getStringList('pocketvm.logs');
      if (savedLogs != null) logs.addAll(savedLogs);
      if (logs.isEmpty) logs.add('برنامه آماده شد.');
    } catch (_) {
      if (machines.isEmpty) machines.add(Machine('Ubuntu Linux', 'Ubuntu', 2, 2, 16));
      if (logs.isEmpty) logs.add('برنامه آماده شد.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (mounted) setState(() => loaded = true);
  }

  Future<void> _persistState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pocketvm.machines', jsonEncode(machines.map((m) => {
        'name': m.name, 'os': m.os, 'ram': m.ram, 'cpu': m.cpu, 'disk': m.disk,
      }).toList()));
      await prefs.setBool('pocketvm.compact', compact);
      await prefs.setBool('pocketvm.notifications', notifications);
      await prefs.setStringList('pocketvm.logs', logs.take(30).toList());
    } catch (_) {
      // The UI remains usable if local storage is temporarily unavailable.
    }
  }

  void notice(String message) {
    if (!notifications) return;
    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(message)));
  }
  void record(String message) {
    logs.insert(0, TimeOfDay.now().format(context) + ' • ' + message);
    if (logs.length > 30) logs.removeLast();
    _persistState();
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) return const PocketVMLoadingScreen();
    final pages = [homePage(), machinesPage(), createPage(), imagesPage(), settingsPage()];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: bg, statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF11100F), systemNavigationBarIconBrightness: Brightness.light),
      child: Scaffold(
        body: SafeArea(bottom: false, child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 360),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, a) => FadeTransition(
            opacity: a,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, .035), end: Offset.zero,
              ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
              child: ScaleTransition(
                scale: Tween<double>(begin: .985, end: 1).animate(
                  CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
                child: child,
              ),
            ),
          ),
          child: KeyedSubtree(key: ValueKey(page), child: pages[page]),
        )),
        bottomNavigationBar: NavigationBar(
          animationDuration: const Duration(milliseconds: 420),
          selectedIndex: page, onDestinationSelected: (i) {
            if (i == page) return;
            setState(() => page = i);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'خانه'),
            NavigationDestination(icon: Icon(Icons.devices_outlined), label: 'ماشین‌ها'),
            NavigationDestination(icon: Icon(Icons.add_circle_outline_rounded), label: 'ساخت'),
            NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'ایمیج‌ها'),
            NavigationDestination(icon: Icon(Icons.tune_rounded), label: 'تنظیمات'),
          ]),
      ),
    );
  }

  Widget list(List<Widget> children) => ListView(padding: const EdgeInsets.fromLTRB(18, 16, 18, 28), children: children);
  Widget brand() => Row(children: [
    Container(width: 46, height: 46, decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFFFF922E), Color(0xFFFF5A00)]),
      borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: accent.withValues(alpha: .18), blurRadius: 17, offset: const Offset(0, 5))]),
      child: const Icon(Icons.view_in_ar_rounded, color: Color(0xFFB9D7FF), size: 26)),
    const SizedBox(width: 12),
    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('ورچینو', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, letterSpacing: -.5)),
      Text('محیط مجازی، مرتب و ساده', style: TextStyle(color: muted, fontSize: 11)),
    ])),
    IconButton(tooltip: 'تنظیمات', onPressed: () => setState(() => page = 4),
      style: IconButton.styleFrom(backgroundColor: panel, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
      icon: const Icon(Icons.tune_rounded, color: muted)),
  ]);
  Widget heading(String title, String sub, IconData icon) => Row(children: [
    Container(width: 46, height: 46, decoration: BoxDecoration(color: accent.withValues(alpha: .1),
      border: Border.all(color: accent.withValues(alpha: .15)), borderRadius: BorderRadius.circular(14)),
      child: Icon(icon, color: accent, size: 23)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
      Text(sub, style: const TextStyle(color: muted, fontSize: 12)),
    ])),
  ]);
  Widget section(String title, {String? action, VoidCallback? onTap}) => Row(children: [
    Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
    if (action != null) TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: accent))),
  ]);

  Widget homePage() => list([
    Row(children: [
      Container(width: 43, height: 43, decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFF922E), Color(0xFFFF5A00)]),
        borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.view_in_ar_rounded, color: Color(0xFFB9D7FF), size: 25)),
      const SizedBox(width: 10),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('ورچینو', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
        Text('مدیریت محیط‌های مجازی', style: TextStyle(color: muted, fontSize: 10)),
      ])),
      IconButton(onPressed: () => setState(() => page = 4),
        style: IconButton.styleFrom(backgroundColor: panel, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
        icon: const Icon(Icons.tune_rounded, color: muted)),
    ]),
    const SizedBox(height: 19),
    Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight, end: Alignment.bottomLeft,
          colors: [Color(0xFF292019), Color(0xFF171615), Color(0xFF171615)],
        ),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: accent.withValues(alpha: .22)),
        boxShadow: [BoxShadow(color: accent.withValues(alpha: .06), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('محیط کاری من', style: TextStyle(color: muted, fontSize: 11)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(color: green.withValues(alpha: .1), borderRadius: BorderRadius.circular(20)),
            child: const Row(children: [Icon(Icons.circle, color: green, size: 6), SizedBox(width: 5),
              Text('آماده', style: TextStyle(color: green, fontSize: 10, fontWeight: FontWeight.w700))])),
        ]),
        const SizedBox(height: 12),
        const Text('ماشین‌های مجازی\nخودت را مدیریت کن', style: TextStyle(fontSize: 25, height: 1.4, fontWeight: FontWeight.w900)),
        const SizedBox(height: 7),
        const Text('پیکربندی منابع و نگهداری محیط‌های لینوکسی در یک مکان.',
          style: TextStyle(color: muted, height: 1.7, fontSize: 11)),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: FilledButton.icon(
          onPressed: () => setState(() => page = 2),
          style: FilledButton.styleFrom(shape: const StadiumBorder(), minimumSize: const Size(0, 49)),
          icon: const Icon(Icons.add_rounded, size: 20), label: const Text('ساخت ماشین جدید'))),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () => setState(() => page = 1),
          style: OutlinedButton.styleFrom(shape: const StadiumBorder(), minimumSize: const Size(0, 45)),
          icon: const Icon(Icons.devices_rounded, size: 18), label: const Text('مشاهده ماشین‌ها'))),
      ]),
    ),
    const SizedBox(height: 22),
    section('نمای کلی'), const SizedBox(height: 10),
    Row(children: [
      Expanded(child: stat('ماشین‌ها', machines.length.toString(), Icons.devices_rounded, accent)),
      const SizedBox(width: 8),
      Expanded(child: stat('روشن', machines.where((m) => m.running).length.toString(), Icons.power_settings_new_rounded, green)),
      const SizedBox(width: 8),
      Expanded(child: stat('فضا', machines.fold<int>(0, (s, m) => s + m.disk).toString() + ' GB', Icons.storage_rounded, blue)),
    ]),
    const SizedBox(height: 22),
    section('ماشین‌های من', action: 'مشاهده همه', onTap: () => setState(() => page = 1)),
    const SizedBox(height: 10),
    if (machines.isEmpty)
      empty('هنوز ماشینی نداری', 'اولین پیکربندی خودت را ایجاد کن.', Icons.devices_other_rounded, () => setState(() => page = 2))
    else ...machines.take(2).map(machineCard),
    info('وضعیت موتور مجازی', 'رابط مدیریت آماده است؛ اجرای واقعی سیستم‌عامل هنوز به موتور QEMU متصل نشده است.', Icons.info_outline_rounded),
  ]);

  Widget stat(String label, String value, IconData icon, Color color) => Container(
    padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.white.withValues(alpha: .045))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 20), const SizedBox(height: 12),
      FittedBox(alignment: Alignment.centerLeft, fit: BoxFit.scaleDown, child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
      const SizedBox(height: 3), Text(label, style: const TextStyle(color: muted, fontSize: 10)),
    ]),
  );

  Widget machinesPage() => list([
    Row(children: [
      Expanded(child: heading('ماشین‌ها', 'مدیریت محیط‌های مجازی', Icons.devices_rounded)),
      IconButton(onPressed: () => setState(() => page = 2), icon: const Icon(Icons.add_rounded, color: accent),
        style: IconButton.styleFrom(backgroundColor: accent.withValues(alpha: .12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)))),
    ]),
    const SizedBox(height: 18),
    Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(
      color: panel, borderRadius: BorderRadius.circular(17), border: Border.all(color: line)),
      child: Row(children: [
        Expanded(child: _machineSummary('کل محیط‌ها', machines.length.toString(), Icons.devices_rounded, accent)),
        Container(width: 1, height: 38, color: line),
        Expanded(child: _machineSummary('در حال اجرا', machines.where((m) => m.running).length.toString(), Icons.play_circle_outline_rounded, green)),
      ])),
    const SizedBox(height: 15),
    Container(
      decoration: BoxDecoration(
        color: panel, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: line),
      ),
      child: TextField(
        onChanged: (value) => setState(() => machineSearch = value),
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: 'جست‌وجوی نام یا سیستم‌عامل…',
          hintStyle: const TextStyle(color: muted, fontSize: 11),
          prefixIcon: const Icon(Icons.search_rounded, color: muted, size: 20),
          suffixIcon: machineSearch.isEmpty ? null : IconButton(
            onPressed: () => setState(() => machineSearch = ''),
            icon: const Icon(Icons.close_rounded, color: muted, size: 18),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    ),
    const SizedBox(height: 13),
    Row(children: ['همه', 'روشن', 'خاموش'].map((filter) => Expanded(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 6),
        child: ChoiceChip(
          label: Center(child: Text(filter)),
          selected: machineFilter == filter,
          onSelected: (_) => setState(() => machineFilter = filter),
          selectedColor: accent.withValues(alpha: .18),
          backgroundColor: panel,
          side: BorderSide(color: machineFilter == filter ? accent.withValues(alpha: .5) : line),
          elevation: machineFilter == filter ? 1 : 0,
          pressElevation: 2,
          labelStyle: TextStyle(color: machineFilter == filter ? accent : muted, fontSize: 11, fontWeight: FontWeight.w800),
          showCheckmark: false,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    )).toList()),
    const SizedBox(height: 12),
    Row(children: [
      const Expanded(child: Text('همه ماشین‌ها', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900))),
      Text(visibleMachines.length.toString() + ' مورد', style: const TextStyle(color: muted, fontSize: 11)),
    ]),
    const SizedBox(height: 11),
    if (machines.isEmpty)
      empty('هنوز ماشینی نداری', 'اولین محیط مجازی خودت را بساز.', Icons.devices_other_rounded, () => setState(() => page = 2))
    else if (visibleMachines.isEmpty)
      info('موردی پیدا نشد', 'در فیلتر «' + machineFilter + '» ماشینی وجود ندارد.', Icons.filter_alt_off_rounded)
    else ...visibleMachines.map((m) => machineCard(m)),
    info('وضعیت موتور مجازی', 'این صفحه فعلاً پیکربندی‌ها را مدیریت می‌کند؛ اجرای واقعی سیستم‌عامل هنوز به QEMU متصل نیست.', Icons.info_outline_rounded),
  ]);

  Widget _machineSummary(String title, String value, IconData icon, Color color) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(children: [
      Icon(icon, color: color, size: 21), const SizedBox(width: 9),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
        Text(title, style: const TextStyle(color: muted, fontSize: 10)),
      ]),
    ]),
  );

    Widget createPage() => list([
    heading('ماشین جدید', 'یک پیکربندی تازه بساز', Icons.add_box_rounded),
    const SizedBox(height: 20),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
      color: panel, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('۱  انتخاب سیستم‌عامل', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        ...[
          ('Ubuntu', Icons.circle_outlined),
          ('Debian', Icons.all_inclusive_rounded),
          ('Alpine Linux', Icons.terrain_rounded),
          ('Other Linux', Icons.terminal_rounded),
        ].map((entry) => AnimatedContainer(
          duration: const Duration(milliseconds: 160), margin: const EdgeInsets.only(bottom: 7),
          decoration: BoxDecoration(color: os == entry.$1 ? accent.withValues(alpha: .09) : panel2,
            borderRadius: BorderRadius.circular(13), border: Border.all(color: os == entry.$1 ? accent.withValues(alpha: .6) : Colors.transparent)),
          child: ListTile(dense: true, onTap: () => setState(() => os = entry.$1),
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Icon(entry.$2, key: ValueKey(os == entry.$1), color: os == entry.$1 ? accent : muted, size: 20),
            ),
            title: Text(entry.$1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            trailing: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(os == entry.$1 ? Icons.radio_button_checked : Icons.radio_button_off,
                key: ValueKey(os == entry.$1), color: os == entry.$1 ? accent : muted, size: 19),
            ))),
        ),
      ]),
    ),
    const SizedBox(height: 15),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
      color: panel, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('۲  تخصیص منابع', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        resource('حافظه RAM', ram.toString() + ' GB', ram.toDouble(), 1, 8, (v) => setState(() => ram = v.round()), Icons.memory_rounded),
        resource('پردازنده', cpu.toString() + ' هسته', cpu.toDouble(), 1, 4, (v) => setState(() => cpu = v.round()), Icons.developer_board_rounded),
        resource('فضای دیسک', disk.toString() + ' GB', disk.toDouble(), 8, 64, (v) => setState(() => disk = v.round()), Icons.storage_rounded),
      ]),
    ),
    const SizedBox(height: 13),
    Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(
      color: accent.withValues(alpha: .07), borderRadius: BorderRadius.circular(16), border: Border.all(color: accent.withValues(alpha: .18))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('خلاصه پیکربندی', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        const SizedBox(height: 9),
        Text(os + '  •  ' + ram.toString() + ' GB RAM  •  ' + cpu.toString() + ' CPU  •  ' + disk.toString() + ' GB',
          style: const TextStyle(color: muted, fontSize: 11)),
      ]),
    ),
    const SizedBox(height: 14),
    SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () {
      setState(() { machines.add(Machine(os + ' ' + (machines.length + 1).toString(), os, ram, cpu, disk)); record('پیکربندی ماشین ذخیره شد؛ سیستم‌عامل هنوز اجرا نمی‌شود.'); page = 1; });
      _persistState(); notice('ماشین به فهرست اضافه شد.');
    }, icon: const Icon(Icons.add_rounded), label: const Text('ذخیره پیکربندی'))),
    const SizedBox(height: 7),
    const Text('در نسخه فعلی، این کار پیکربندی نمایشی می‌سازد و سیستم‌عامل اجرا نمی‌شود.',
      textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 10, height: 1.6)),
  ]);

    Widget resource(String title, String value, double v, double min, double max, ValueChanged<double> change, IconData icon) => Container(
    margin: const EdgeInsets.only(bottom: 9), padding: const EdgeInsets.fromLTRB(14, 11, 14, 5),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(15), border: Border.all(color: line)),
    child: Column(children: [
      Row(children: [Icon(icon, color: accent, size: 19), const SizedBox(width: 9), Expanded(child: Text(title)),
        Text(value, style: const TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 12))]),
      Slider(value: v.clamp(min, max).toDouble(), min: min, max: max, divisions: (max - min).round(), onChanged: change),
    ]),
  );

  Widget machineCard(Machine m) => TweenAnimationBuilder<double>(
    key: ObjectKey(m),
    tween: Tween<double>(begin: .94, end: 1),
    duration: const Duration(milliseconds: 420),
    curve: Curves.easeOutCubic,
    builder: (context, value, child) => Opacity(
      opacity: value.clamp(0, 1),
      child: Transform.translate(
        offset: Offset(0, 14 * (1 - value)),
        child: Transform.scale(scale: value, child: child),
      ),
    ),
    child: AnimatedContainer(
    duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic,
    margin: EdgeInsets.only(bottom: compact ? 7 : 10),
    padding: EdgeInsets.all(compact ? 12 : 15),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18),
      border: Border.all(color: m.running ? green.withValues(alpha: .25) : line),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .1), blurRadius: 13, offset: const Offset(0, 4))]),
    child: Column(children: [
      Row(children: [
        Container(width: 43, height: 43, decoration: BoxDecoration(color: accent.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
          child: const Icon(Icons.computer_rounded, color: accent, size: 23)),
        const SizedBox(width: 11),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(m.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
          Text(m.os + ' • Linux', style: const TextStyle(color: muted, fontSize: 10)),
        ])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(color: (m.running ? green : muted).withValues(alpha: .1), borderRadius: BorderRadius.circular(20)),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Text(
              m.running ? 'روشن' : 'خاموش',
              key: ValueKey(m.running),
              style: TextStyle(color: m.running ? green : muted, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          )),
      ]),
      const SizedBox(height: 13), Container(height: 1, color: line), const SizedBox(height: 12),
      Row(children: [
        metric(Icons.memory_rounded, m.ram.toString() + ' GB', 'RAM'),
        metric(Icons.developer_board_rounded, m.cpu.toString(), 'CPU'),
        metric(Icons.storage_rounded, m.disk.toString() + ' GB', 'دیسک'),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: FilledButton.icon(onPressed: () { setState(() { m.running = !m.running; record(m.running ? 'پیکربندی ' + m.name + ' برای اجرا علامت‌گذاری شد؛ موتور QEMU متصل نیست.' : 'وضعیت ' + m.name + ' به خاموش برگشت.'); }); _persistState(); },
          style: FilledButton.styleFrom(backgroundColor: m.running ? panel2 : accent, minimumSize: const Size(0, 41)),
          icon: Icon(m.running ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 18), label: Text(m.running ? 'خاموش کردن' : 'روشن کردن'))),
        const SizedBox(width: 6),
        IconButton(tooltip: 'جزئیات ماشین', onPressed: () => showMachineDetails(m),
          style: IconButton.styleFrom(backgroundColor: panel2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          icon: const Icon(Icons.info_outline_rounded, color: blue)),
        const SizedBox(width: 4),
        IconButton(tooltip: 'حذف ماشین', onPressed: () => deleteMachine(m),
          style: IconButton.styleFrom(backgroundColor: panel2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          icon: const Icon(Icons.delete_outline_rounded, color: muted)),
      ]),
    ]),
  ),
  );

  void showMachineDetails(Machine m) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: panel,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(
                color: line, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              Row(children: [
                Container(width: 48, height: 48, decoration: BoxDecoration(
                  color: accent.withValues(alpha: .12), borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.computer_rounded, color: accent, size: 25)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                  Text(m.os + ' • پیکربندی لینوکس', style: const TextStyle(color: muted, fontSize: 11)),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: (m.running ? green : muted).withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(20)),
                  child: Text(m.running ? 'روشن' : 'خاموش',
                    style: TextStyle(color: m.running ? green : muted, fontSize: 10, fontWeight: FontWeight.w800))),
              ]),
              const SizedBox(height: 20),
              const Text('منابع تخصیص‌یافته', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _detailResource(Icons.memory_rounded, 'حافظه RAM', m.ram.toString() + ' GB')),
                const SizedBox(width: 8),
                Expanded(child: _detailResource(Icons.developer_board_rounded, 'پردازنده', m.cpu.toString() + ' هسته')),
              ]),
              const SizedBox(height: 8),
              _detailResource(Icons.storage_rounded, 'فضای دیسک', m.disk.toString() + ' GB'),
              const SizedBox(height: 14),
              info('وضعیت اجرا', m.running
                ? 'این ماشین فقط در رابط برنامه روشن علامت‌گذاری شده است؛ اجرای واقعی سیستم‌عامل هنوز فعال نیست.'
                : 'این پیکربندی ذخیره شده است. برای اجرای واقعی سیستم‌عامل، اتصال موتور QEMU لازم است.',
                Icons.info_outline_rounded),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(sheetContext),
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('بستن جزئیات'))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailResource(IconData icon, String label, String value) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: panel2, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: line)),
    child: Row(children: [
      Icon(icon, color: accent, size: 19),
      const SizedBox(width: 9),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: muted, fontSize: 10)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
      ])),
    ]),
  );

  Widget metric(IconData icon, String value, String label) => Expanded(child: Row(children: [
    Icon(icon, color: muted, size: 15), const SizedBox(width: 5),
    Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
      Text(label, style: const TextStyle(fontSize: 9, color: muted)),
    ])),
  ]));

  Future<void> deleteMachine(Machine m) async {
    final yes = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      backgroundColor: panel2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('حذف ماشین؟', style: TextStyle(fontWeight: FontWeight.w900)),
      content: Text('«' + m.name + '» از فهرست نمایشی حذف می‌شود.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('انصراف', style: TextStyle(color: muted))),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف')),
      ],
    ));
    if (yes == true && mounted) {
      setState(() { machines.remove(m); record('ماشین ' + m.name + ' حذف شد.'); });
      _persistState();
      notice('ماشین حذف شد.');
    }
  }

  Widget imagesPage() => list([
    heading('کتابخانه ایمیج', 'مدیریت منابع سیستم‌عامل', Icons.inventory_2_rounded),
    const SizedBox(height: 18),
    Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF25201B), Color(0xFF171615)],
          begin: Alignment.topRight, end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: accent.withValues(alpha: .18)),
      ),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: accent.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
          child: const Icon(Icons.archive_rounded, color: accent),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('کتابخانه محلی', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
          SizedBox(height: 4),
          Text('فهرست پیشنهادی سیستم‌عامل‌ها', style: TextStyle(color: muted, fontSize: 10)),
        ])),
        const Text('۳ مورد', style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w800)),
      ]),
    ),
    const SizedBox(height: 18),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
      color: panel, borderRadius: BorderRadius.circular(17), border: Border.all(color: line)),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: accent.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
          child: const Icon(Icons.folder_open_rounded, color: accent)),
        const SizedBox(width: 12),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('مخزن ایمیج‌ها', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
          SizedBox(height: 3),
          Text('مدیریت فایل‌های نصب سیستم‌عامل', style: TextStyle(color: muted, fontSize: 10)),
        ])),
        const Icon(Icons.cloud_off_rounded, color: muted),
      ]),
    ),
    const SizedBox(height: 20),
    const Text('سیستم‌عامل‌های پیشنهادی', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
    const SizedBox(height: 10),
    imageItem('Ubuntu 24.04 LTS', 'مناسب استفاده عمومی • Linux', Icons.circle_outlined, blue),
    imageItem('Debian 12', 'پایدار و قابل اتکا • Linux', Icons.all_inclusive_rounded, accent),
    imageItem('Alpine Linux', 'سبک و کم‌حجم • Linux', Icons.terrain_rounded, green),
    const SizedBox(height: 5),
    info('دانلود هنوز فعال نیست', 'این موارد فعلاً فقط نمونه‌های رابط کاربری هستند؛ فایل ISO دریافت یا نصب نمی‌شود.', Icons.info_outline_rounded),
  ]);

    Widget imageItem(String title, String sub, IconData icon, Color color) => TweenAnimationBuilder<double>(
    key: ValueKey(title),
    tween: Tween<double>(begin: .96, end: 1),
    duration: const Duration(milliseconds: 360),
    curve: Curves.easeOutCubic,
    builder: (context, value, child) => Opacity(
      opacity: value.clamp(0, 1),
      child: Transform.translate(offset: Offset(0, 9 * (1 - value)), child: child),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => notice('اطلاعات این ایمیج فعلاً نمایشی است و دانلود فعال نیست.'),
        child: Container(
          margin: const EdgeInsets.only(bottom: 9),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), border: Border.all(color: line)),
          child: Row(children: [
            Container(width: 43, height: 43, decoration: BoxDecoration(color: color.withValues(alpha: .1), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: color)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              Text(sub, style: const TextStyle(color: muted, fontSize: 10)),
            ])),
            const Icon(Icons.chevron_left_rounded, color: muted),
          ]),
        ),
      ),
    ),
  );

  Widget settingsPage() => list([
    heading('تنظیمات', 'شخصی‌سازی ورچینو', Icons.tune_rounded),
    const SizedBox(height: 18),
    Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: panel, borderRadius: BorderRadius.circular(17),
        border: Border.all(color: line),
      ),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFF922E), Color(0xFFFF5A00)]),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.view_in_ar_rounded, color: Color(0xFFB9D7FF)),
        ),
        const SizedBox(width: 11),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ورچینو', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
          SizedBox(height: 3),
          Text('پیش‌نمایش رابط کاربری', style: TextStyle(color: muted, fontSize: 10)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(color: accent.withValues(alpha: .1), borderRadius: BorderRadius.circular(20)),
          child: const Text('Preview', style: TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.w800)),
        ),
      ]),
    ),
    const SizedBox(height: 20),
    const Text('رابط کاربری', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
    const SizedBox(height: 10),
    setting(Icons.palette_outlined, 'پوسته برنامه', 'تیره با تأکید نارنجی', const Icon(Icons.check_circle_rounded, color: accent)),
    setting('view', 'کارت‌های فشرده', 'نمایش اطلاعات در فضای کمتر',
      Switch(value: compact, activeColor: accent, onChanged: (v) => setState(() { compact = v; _persistState(); }))),
    setting(Icons.notifications_none_rounded, 'اعلان‌های داخل برنامه', 'نمایش پیام‌های وضعیت',
      Switch(value: notifications, activeColor: accent, onChanged: (v) => setState(() { notifications = v; _persistState(); }))),
    const SizedBox(height: 18),
    const Text('درباره برنامه', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
    const SizedBox(height: 10),
    setting(Icons.memory_rounded, 'موتور مجازی', 'اتصال QEMU هنوز انجام نشده', const Icon(Icons.info_outline_rounded, color: muted)),
    setting(Icons.font_download_outlined, 'فونت', 'Vazirmatn', const Icon(Icons.check_rounded, color: green)),
    setting(Icons.code_rounded, 'فناوری', 'Flutter • Dart', const Icon(Icons.chevron_left_rounded, color: muted)),
    const SizedBox(height: 18),
    Row(children: [
      const Expanded(child: Text('گزارش فعالیت', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900))),
      TextButton(onPressed: () => setState(() { logs.clear(); _persistState(); }), child: const Text('پاک‌کردن', style: TextStyle(color: accent))),
    ]),
    const SizedBox(height: 8),
    if (logs.isEmpty) info('گزارشی وجود ندارد', 'فعالیت‌های بعدی اینجا نمایش داده می‌شوند.', Icons.receipt_long_outlined)
    else Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), border: Border.all(color: line)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: logs.take(8).map((s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.circle, color: accent, size: 6), const SizedBox(width: 9),
          Expanded(child: Text(s, style: const TextStyle(color: muted, fontSize: 11, height: 1.5))),
        ]),
      )).toList())),
    const SizedBox(height: 16),
    const Center(child: Text('ورچینو  •  Preview', style: TextStyle(color: Color(0xFF626B7B), fontSize: 10))),
  ]);

    Widget setting(dynamic icon, String title, String sub, Widget trailing) {
    final IconData data = icon == 'view' ? Icons.view_agenda_outlined : icon as IconData;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(15), border: Border.all(color: line)),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
          leading: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 38, height: 38,
            decoration: BoxDecoration(color: panel2, borderRadius: BorderRadius.circular(11)),
            child: Icon(data, color: muted, size: 20),
          ),
          title: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
          subtitle: Text(sub, style: const TextStyle(fontSize: 10, color: muted)),
          trailing: trailing,
        ),
      ),
    );
  }

  Widget info(String title, String body, IconData icon) => AnimatedContainer(
    duration: const Duration(milliseconds: 280),
    curve: Curves.easeOutCubic,
    margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), border: Border.all(color: line)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: accent, size: 21), const SizedBox(width: 11),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
        const SizedBox(height: 5), Text(body, style: const TextStyle(color: muted, fontSize: 11, height: 1.7)),
      ])),
    ]),
  );

  Widget empty(String title, String sub, IconData icon, VoidCallback action) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)),
    child: Column(children: [
      Container(width: 58, height: 58, decoration: BoxDecoration(color: accent.withValues(alpha: .1), borderRadius: BorderRadius.circular(18)), child: Icon(icon, color: accent, size: 28)),
      const SizedBox(height: 14), Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
      const SizedBox(height: 5), Text(sub, textAlign: TextAlign.center, style: const TextStyle(color: muted, fontSize: 11, height: 1.6)),
      const SizedBox(height: 15), OutlinedButton.icon(onPressed: action, icon: const Icon(Icons.add, size: 17), label: const Text('ساخت ماشین')),
    ]),
  );
}
