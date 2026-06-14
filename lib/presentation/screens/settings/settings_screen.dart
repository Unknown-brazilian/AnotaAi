import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/brand.dart';
import '../../../core/enums.dart';
import '../../../domain/services/settings_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../profile/profile_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        children: [
          _header(t.account),
          ListTile(
            leading: const Icon(Icons.account_circle, color: Brand.orange),
            title: Text(t.profile),
            subtitle: Text(s.defaultWorkerName.isEmpty
                ? t.profileNameSecurity
                : s.defaultWorkerName),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),

          _header(t.appearance),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(t.theme),
            subtitle: Text(switch (s.themeMode) {
              AppThemeMode.system => t.themeSystem,
              AppThemeMode.light => t.themeLight,
              AppThemeMode.dark => t.themeDark,
            }),
            trailing: DropdownButton<AppThemeMode>(
              value: s.themeMode,
              onChanged: (v) => notifier.update(s.copyWith(themeMode: v)),
              items: [
                DropdownMenuItem(value: AppThemeMode.system, child: Text(t.system)),
                DropdownMenuItem(value: AppThemeMode.light, child: Text(t.themeLight)),
                DropdownMenuItem(value: AppThemeMode.dark, child: Text(t.themeDark)),
              ],
            ),
          ),

          _header(t.values),
          ListTile(
            leading: const Icon(Icons.euro),
            title: Text(t.defaultCurrency),
            trailing: DropdownButton<Currency>(
              value: s.defaultCurrency,
              onChanged: (v) => notifier.update(s.copyWith(defaultCurrency: v)),
              items: Currency.values
                  .map((c) => DropdownMenuItem(value: c, child: Text('${c.symbol} ${c.code}')))
                  .toList(),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.currency_exchange),
            title: Text(t.showBrlTitle),
            subtitle: Text(t.showBrlSub),
            value: s.showBrl,
            onChanged: (v) => notifier.update(s.copyWith(showBrl: v)),
          ),

          _header(t.navBitcoin),
          ListTile(
            leading: const Icon(Icons.percent),
            title: Text(t.bitcoinSavingsPct),
            subtitle: Text(t.pctOfEarnings((s.bitcoinSavingsPct * 100).round())),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Slider(
              value: (s.bitcoinSavingsPct * 100).clamp(1, 50),
              min: 1,
              max: 50,
              divisions: 49,
              label: '${(s.bitcoinSavingsPct * 100).round()}%',
              onChanged: (v) => notifier.update(s.copyWith(bitcoinSavingsPct: v / 100)),
            ),
          ),

          _header(t.reminders),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active),
            title: Text(t.dailyReminder),
            subtitle: Text(s.reminderEnabled
                ? t.dailyAt(
                    '${s.reminderHour.toString().padLeft(2, '0')}:${s.reminderMinute.toString().padLeft(2, '0')}')
                : t.off),
            value: s.reminderEnabled,
            onChanged: (v) => _toggleReminder(context, ref, s, v),
          ),
          if (s.reminderEnabled)
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(t.reminderTime),
              trailing: TextButton(
                onPressed: () => _pickReminderTime(context, ref, s),
                child: Text(
                    '${s.reminderHour.toString().padLeft(2, '0')}:${s.reminderMinute.toString().padLeft(2, '0')}'),
              ),
            ),

          _header(t.backupRestore),
          ListTile(
            leading: const Icon(Icons.backup),
            title: Text(t.doBackup),
            subtitle: Text(t.doBackupSub),
            onTap: () => _doBackup(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: Text(t.restoreBackup),
            subtitle: Text(t.restoreBackupSub),
            onTap: () => _doRestore(context, ref),
          ),

          _header(t.language),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(t.language),
            subtitle: Text(AppLocalizations.nameOf(s.locale)),
            trailing: DropdownButton<String>(
              value: s.locale,
              onChanged: (v) => notifier.update(s.copyWith(locale: v)),
              items: AppLocalizations.supportedCodes
                  .map((c) => DropdownMenuItem(value: c, child: Text(AppLocalizations.nameOf(c))))
                  .toList(),
            ),
          ),

          _header(t.about),
          ListTile(
            leading: const Icon(Icons.currency_bitcoin, color: Brand.orange),
            title: Text(t.startSavingBitcoin),
            subtitle: Text(t.openBinanceSignup),
            onTap: () => launchUrl(Uri.parse(AppConfig.binanceReferralUrl),
                mode: LaunchMode.externalApplication),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('AnotAí'),
            subtitle: Text('${t.appTagline} · v1.0.2'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(text,
            style: const TextStyle(
                color: Brand.orange, fontWeight: FontWeight.bold, fontSize: 13)),
      );

  Future<void> _toggleReminder(BuildContext context, WidgetRef ref, AppSettings s, bool enable) async {
    final notif = ref.read(notificationServiceProvider);
    if (!enable) {
      await notif.cancelDailyReminder();
      ref.read(settingsProvider.notifier).update(s.copyWith(reminderEnabled: false));
      return;
    }
    final granted = await notif.requestPermission();
    if (!granted) {
      if (context.mounted) _snack(context, AppLocalizations.of(context).notifPermissionDenied);
      return;
    }
    await notif.scheduleDailyReminder(s.reminderHour, s.reminderMinute);
    ref.read(settingsProvider.notifier).update(s.copyWith(reminderEnabled: true));
  }

  Future<void> _pickReminderTime(BuildContext context, WidgetRef ref, AppSettings s) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: s.reminderHour, minute: s.reminderMinute),
    );
    if (picked != null) {
      final next = s.copyWith(reminderHour: picked.hour, reminderMinute: picked.minute);
      await ref.read(settingsProvider.notifier).update(next);
      await ref.read(notificationServiceProvider).scheduleDailyReminder(picked.hour, picked.minute);
    }
  }

  Future<void> _doBackup(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context);
    try {
      final stamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final file = await ref.read(backupServiceProvider).createBackup(stamp: stamp);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'application/zip')],
        text: t.backupShareText,
      ));
    } catch (e) {
      if (context.mounted) _snack(context, t.backupFail(e));
    }
  }

  Future<void> _doRestore(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.restoreBackup),
        content: Text(t.restoreConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(t.restore)),
        ],
      ),
    );
    if (confirm != true) return;

    final picked = await FilePicker.platform.pickFiles(type: FileType.any);
    if (picked == null || picked.files.single.path == null) return;

    try {
      // Fecha o banco antes de sobrescrever o arquivo no disco.
      await ref.read(databaseProvider).close();
      await ref.read(backupServiceProvider).restoreBackup(File(picked.files.single.path!));
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(t.restoreDone),
            content: Text(t.restoreReopen),
            actions: [
              FilledButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(t.closeApp),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) _snack(context, t.restoreFail(e));
    }
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
