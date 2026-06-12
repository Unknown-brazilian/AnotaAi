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
import '../../providers/providers.dart';
import '../profile/profile_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          _header('Conta'),
          ListTile(
            leading: const Icon(Icons.account_circle, color: Brand.orange),
            title: const Text('Perfil do usuário'),
            subtitle: Text(s.defaultWorkerName.isEmpty
                ? 'Nome e segurança (PIN/biometria)'
                : '${s.defaultWorkerName} · nome e segurança'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),

          _header('Aparência'),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Tema'),
            subtitle: Text(switch (s.themeMode) {
              AppThemeMode.system => 'Seguir o sistema',
              AppThemeMode.light => 'Claro',
              AppThemeMode.dark => 'Escuro',
            }),
            trailing: DropdownButton<AppThemeMode>(
              value: s.themeMode,
              onChanged: (v) => notifier.update(s.copyWith(themeMode: v)),
              items: const [
                DropdownMenuItem(value: AppThemeMode.system, child: Text('Sistema')),
                DropdownMenuItem(value: AppThemeMode.light, child: Text('Claro')),
                DropdownMenuItem(value: AppThemeMode.dark, child: Text('Escuro')),
              ],
            ),
          ),

          _header('Valores'),
          ListTile(
            leading: const Icon(Icons.euro),
            title: const Text('Moeda padrão'),
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
            title: const Text('Mostrar valores em Real (BRL)'),
            subtitle: const Text('Exibe a conversão ao lado de euro/libra'),
            value: s.showBrl,
            onChanged: (v) => notifier.update(s.copyWith(showBrl: v)),
          ),

          _header('Bitcoin'),
          ListTile(
            leading: const Icon(Icons.percent),
            title: const Text('Percentual de poupança em Bitcoin'),
            subtitle: Text('${(s.bitcoinSavingsPct * 100).round()}% dos ganhos'),
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

          _header('Lembretes'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active),
            title: const Text('Lembrete diário'),
            subtitle: Text(s.reminderEnabled
                ? 'Todo dia às ${s.reminderHour.toString().padLeft(2, '0')}:${s.reminderMinute.toString().padLeft(2, '0')}'
                : 'Desligado'),
            value: s.reminderEnabled,
            onChanged: (v) => _toggleReminder(context, ref, s, v),
          ),
          if (s.reminderEnabled)
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Horário do lembrete'),
              trailing: TextButton(
                onPressed: () => _pickReminderTime(context, ref, s),
                child: Text(
                    '${s.reminderHour.toString().padLeft(2, '0')}:${s.reminderMinute.toString().padLeft(2, '0')}'),
              ),
            ),

          _header('Backup e restauração'),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Fazer backup'),
            subtitle: const Text('Salva banco + fotos em um arquivo ZIP'),
            onTap: () => _doBackup(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restaurar backup'),
            subtitle: const Text('Importa um arquivo ZIP do AnotAí'),
            onTap: () => _doRestore(context, ref),
          ),

          _header('Idioma'),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Português (Brasil)'),
            subtitle: Text('Inglês e Espanhol em breve'),
          ),

          _header('Sobre'),
          ListTile(
            leading: const Icon(Icons.currency_bitcoin, color: Brand.orange),
            title: const Text('Comece a poupar em Bitcoin'),
            subtitle: const Text('Abrir cadastro na Binance'),
            onTap: () => launchUrl(Uri.parse(AppConfig.binanceReferralUrl),
                mode: LaunchMode.externalApplication),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('AnotAí'),
            subtitle: Text('Controle de diárias · v1.0.1'),
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
      if (context.mounted) _snack(context, 'Permissão de notificações negada.');
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
    try {
      final stamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final file = await ref.read(backupServiceProvider).createBackup(stamp: stamp);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'application/zip')],
        text: 'Backup do AnotAí',
      ));
    } catch (e) {
      if (context.mounted) _snack(context, 'Falha no backup: $e');
    }
  }

  Future<void> _doRestore(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Restaurar backup'),
        content: const Text(
            'Isto substitui TODOS os dados atuais pelos do arquivo. O app será fechado ao final — reabra para concluir. Continuar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Restaurar')),
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
            title: const Text('Backup restaurado'),
            content: const Text('Reabra o AnotAí para ver seus dados restaurados.'),
            actions: [
              FilledButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Fechar app'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) _snack(context, 'Falha ao restaurar: $e');
    }
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
