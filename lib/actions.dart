import 'package:flutter/material.dart';

import 'models.dart';
import 'screens/boot.dart';
import 'screens/console.dart';
import 'screens/details.dart';
import 'theme.dart';
import 'widgets.dart';

void openDetails(BuildContext context, Machine m) {
  Navigator.of(context).push(fadeRoute<void>(DetailsPage(machine: m)));
}

/// Starts a machine. Until QEMU is connected (phase 5) the boot and console
/// screens are a visual preview only.
void launchMachine(BuildContext context, Machine m) {
  if (m.running) {
    Navigator.of(context).push(fadeRoute<void>(ConsolePage(machine: m)));
    return;
  }
  if (!appState.isDownloaded(m.distroId)) {
    showMsg(
      context,
      'ابتدا ایمج ${m.distro.name} را دانلود کنید',
      force: true,
      action: SnackBarAction(
        label: 'دانلود',
        textColor: G.accentLight,
        onPressed: () => appState.startDownload(m.distroId),
      ),
    );
    return;
  }
  Navigator.of(context).push(fadeRoute<void>(BootPage(machine: m)));
}

Future<void> confirmDelete(BuildContext context, Machine m) async {
  final yes = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: G.card2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text('حذف ماشین',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontWeight: FontWeight.w800)),
      content: Text('«${m.name}» حذف شود؟', textDirection: TextDirection.rtl),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('انصراف', style: TextStyle(color: G.muted)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE5484D)),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('حذف'),
        ),
      ],
    ),
  );
  if (yes == true) appState.removeMachine(m);
}

class MachineMenu extends StatelessWidget {
  const MachineMenu(this.m, {super.key});
  final Machine m;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert_rounded, color: G.muted),
        color: G.card2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onSelected: (v) {
          if (v == 'open') {
            openDetails(context, m);
          } else {
            confirmDelete(context, m);
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(
              value: 'open',
              child: Text('جزئیات', textDirection: TextDirection.rtl)),
          PopupMenuItem(
              value: 'delete',
              child: Text('حذف',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: G.danger))),
        ],
      );
}
