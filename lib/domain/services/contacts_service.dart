import 'package:flutter_contacts/flutter_contacts.dart';

/// Dados mínimos de um contato do aparelho usados pelo app.
class PickedContact {
  final String id;
  final String name;
  final String phone;
  const PickedContact({required this.id, required this.name, required this.phone});
}

/// Acesso aos contatos do aparelho (`flutter_contacts`).
///
/// No Android, os contatos da conta Google ficam sincronizados no provedor de
/// contatos do sistema — então ler/gravar aqui reflete na conta Google do
/// usuário, sem precisar de OAuth/People API. Tudo degrada com segurança:
/// se a permissão for negada, os métodos retornam null/false.
class ContactsService {
  /// Pede a permissão (leitura + escrita). Retorna se foi concedida.
  Future<bool> ensurePermission({bool readonly = false}) async {
    try {
      return await FlutterContacts.requestPermission(readonly: readonly);
    } catch (_) {
      return false;
    }
  }

  /// Abre o seletor nativo de contatos e devolve nome + primeiro telefone.
  Future<PickedContact?> pickContact() async {
    if (!await ensurePermission(readonly: true)) return null;
    try {
      final picked = await FlutterContacts.openExternalPick();
      if (picked == null) return null;
      // O seletor às vezes traz só o id; busca os dados completos.
      final full = await FlutterContacts.getContact(picked.id,
              withProperties: true) ??
          picked;
      final phone = full.phones.isNotEmpty ? full.phones.first.number : '';
      return PickedContact(id: full.id, name: full.displayName, phone: phone);
    } catch (_) {
      return null;
    }
  }

  /// Cria ou atualiza um contato no aparelho (e, por sync, na conta Google).
  /// Retorna o id do contato ou null em caso de falha/permissão negada.
  Future<String?> saveToDevice({
    String? existingId,
    required String name,
    required String phone,
  }) async {
    if (!await ensurePermission()) return null;
    try {
      final phones = phone.trim().isEmpty ? <Phone>[] : [Phone(phone.trim())];
      if (existingId != null) {
        final c = await FlutterContacts.getContact(existingId, withProperties: true);
        if (c != null) {
          c.name.first = name.trim();
          c.name.last = '';
          c.phones = phones;
          await c.update();
          return c.id;
        }
      }
      final created = Contact()
        ..name.first = name.trim()
        ..phones = phones;
      await created.insert();
      return created.id;
    } catch (_) {
      return null;
    }
  }
}
