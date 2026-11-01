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

Future<void> renameMachine(BuildContext context, Machine m) async {
  final name = await showDialog<String>(
    context: context,
    builder: (_) => _RenameDialog(initial: m.name),
  );
  final clean = name?.trim() ?? '';
  if (clean.isEmpty || clean == m.name) return;
  m.name = clean;
  appState.changed();
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.initial});
  final String initial;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final TextEditingController _c =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c),
      );

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: G.card2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('تغییر نام ماشین',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: TextField(
          controller: _c,
          autofocus: true,
          maxLength: 24,
          onSubmitted: (v) => Navigator.pop(context, v),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: G.card,
            border: _border(G.line),
            enabledBorder: _border(G.line),
            focusedBorder: _border(G.accent),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف', style: TextStyle(color: G.muted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: G.accent, foregroundColor: G.onAccent),
            onPressed: () => Navigator.pop(context, _c.text),
            child: const Text('ذخیره'),
          ),
        ],
      );
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
          switch (v) {
            case 'open':
              openDetails(context, m);
            case 'rename':
              renameMachine(context, m);
            default:
              confirmDelete(context, m);
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(
              value: 'open',
              child: Text('جزئیات', textDirection: TextDirection.rtl)),
          PopupMenuItem(
              value: 'rename',
              child: Text('تغییر نام', textDirection: TextDirection.rtl)),
          PopupMenuItem(
              value: 'delete',
              child: Text('حذف',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: G.danger))),
        ],
      );
}
