import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Backup e restauração de TODOS os dados (banco + fotos) em um único ZIP.
///
/// Essencial porque o público troca/perde de celular com frequência: o arquivo
/// pode ser salvo, mandado pra si mesmo no WhatsApp e reimportado depois.
///
/// Estrutura do ZIP:
///   manifest.json          → metadados do backup
///   anotai.sqlite          → banco completo
///   attachments/`arquivo`  → cada foto/comprovante
class BackupService {
  static const _dbFileName = 'anotai.sqlite';
  static const _manifestName = 'manifest.json';

  /// Cria o ZIP de backup e devolve o arquivo (em diretório temporário),
  /// pronto para compartilhar/salvar. [stamp] é usado no nome do arquivo.
  Future<File> createBackup({required String stamp}) async {
    final docs = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(docs.path, _dbFileName));
    final attachmentsDir = Directory(p.join(docs.path, 'attachments'));

    final archive = Archive();

    // Banco.
    if (await dbFile.exists()) {
      final bytes = await dbFile.readAsBytes();
      archive.addFile(ArchiveFile(_dbFileName, bytes.length, bytes));
    }

    // Anexos.
    var photoCount = 0;
    if (await attachmentsDir.exists()) {
      for (final entity in attachmentsDir.listSync()) {
        if (entity is File) {
          final bytes = await entity.readAsBytes();
          final name = 'attachments/${p.basename(entity.path)}';
          archive.addFile(ArchiveFile(name, bytes.length, bytes));
          photoCount++;
        }
      }
    }

    // Manifesto.
    final manifest = jsonEncode({
      'app': 'AnotAí',
      'backupVersion': 1,
      'createdAt': stamp,
      'photos': photoCount,
    });
    final manifestBytes = utf8.encode(manifest);
    archive.addFile(
        ArchiveFile(_manifestName, manifestBytes.length, manifestBytes));

    final zipData = ZipEncoder().encode(archive)!;
    final tmp = await getTemporaryDirectory();
    final outFile = File(p.join(tmp.path, 'anotai_backup_$stamp.zip'));
    await outFile.writeAsBytes(zipData, flush: true);
    return outFile;
  }

  /// Restaura a partir de um ZIP. Sobrescreve o banco e os anexos.
  ///
  /// IMPORTANTE: o banco deve estar FECHADO antes de chamar (ver provider de
  /// restauração). Após restaurar, o app deve ser reiniciado para reabrir o
  /// banco novo.
  Future<void> restoreBackup(File zipFile) async {
    final docs = await getApplicationDocumentsDirectory();
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Valida que parece um backup do AnotAí.
    final hasDb = archive.files.any((f) => f.name == _dbFileName);
    if (!hasDb) {
      throw const FormatException(
          'Arquivo inválido: não parece um backup do AnotAí.');
    }

    final attachmentsDir = Directory(p.join(docs.path, 'attachments'));
    if (!await attachmentsDir.exists()) {
      await attachmentsDir.create(recursive: true);
    }

    for (final file in archive.files) {
      if (!file.isFile) continue;
      if (file.name == _manifestName) continue;

      if (file.name == _dbFileName) {
        final dbFile = File(p.join(docs.path, _dbFileName));
        await dbFile.writeAsBytes(file.content as List<int>, flush: true);
      } else if (file.name.startsWith('attachments/')) {
        final name = p.basename(file.name);
        final out = File(p.join(attachmentsDir.path, name));
        await out.writeAsBytes(file.content as List<int>, flush: true);
      }
    }
  }
}
