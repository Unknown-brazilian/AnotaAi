import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/brand.dart';
import '../../../l10n/app_localizations.dart';

/// Tela "Sobre o app": créditos e doação em Bitcoin via rede Lightning.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _lnAddress = AppConfig.lightningAddress;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.aboutApp)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ---- Créditos ----
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Brand.orange,
                  child: Icon(Icons.bolt, color: Brand.black, size: 40),
                ),
                const SizedBox(height: 12),
                const Text('AnotAí',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(t.appTagline, style: TextStyle(color: Theme.of(context).hintColor)),
                const SizedBox(height: 4),
                Text(t.versionLabel(AppConfig.appVersion),
                    style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                const SizedBox(height: 8),
                Text(t.madeBy,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 12),

          // ---- Apoie o projeto (Bitcoin / Lightning) ----
          Row(
            children: [
              const Icon(Icons.bolt, color: Brand.orange),
              const SizedBox(width: 8),
              Text(t.supportProject,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 4),
          Text(t.supportProjectSub, style: TextStyle(color: Theme.of(context).hintColor)),
          const SizedBox(height: 16),

          // Endereço Lightning em monospace + botão copiar.
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      _lnAddress,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                    ),
                  ),
                  IconButton(
                    tooltip: t.copy,
                    icon: const Icon(Icons.copy, color: Brand.orange),
                    onPressed: () => _copyAddress(context, t.addressCopied),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: Brand.orange, foregroundColor: Brand.black),
              icon: const Icon(Icons.bolt),
              label: Text(t.donateLightning),
              onPressed: () => _donate(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyAddress(BuildContext context, String message) async {
    await Clipboard.setData(const ClipboardData(text: _lnAddress));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  /// Abre a carteira Lightning instalada. NÃO usamos `canLaunchUrl` porque no
  /// Android 11+ esquemas customizados retornam false por visibilidade de
  /// pacotes; chamamos `launchUrl` direto e, em caso de erro/sem carteira,
  /// caímos no fallback de copiar o endereço.
  Future<void> _donate(BuildContext context) async {
    final t = AppLocalizations.of(context);
    try {
      final ok = await launchUrl(
        Uri.parse('lightning:$_lnAddress'),
        mode: LaunchMode.externalApplication,
      );
      if (!ok && context.mounted) {
        await _copyAddress(context, t.addressCopiedPaste);
      }
    } catch (_) {
      if (context.mounted) await _copyAddress(context, t.addressCopiedPaste);
    }
  }
}
