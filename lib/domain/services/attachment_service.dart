import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Gerencia as fotos/comprovantes anexados.
///
/// As fotos ficam em `appDocs/attachments/` e nos registros guardamos apenas o
/// NOME do arquivo (não o caminho absoluto). Isso torna o backup portátil: ao
/// restaurar em outro aparelho, o caminho da pasta muda mas o nome continua o
/// mesmo.
class AttachmentService {
  Directory? _dir;

  Future<Directory> dir() async {
    if (_dir != null) return _dir!;
    final docs = await getApplicationDocumentsDirectory();
    final d = Directory(p.join(docs.path, 'attachments'));
    if (!await d.exists()) await d.create(recursive: true);
    _dir = d;
    return d;
  }

  /// Copia [src] (foto escolhida na câmera/galeria) para a pasta de anexos e
  /// devolve o nome do arquivo gravado.
  Future<String> import(File src, {int? seed}) async {
    final d = await dir();
    final ext = p.extension(src.path);
    final stamp = seed ?? DateTime.now().microsecondsSinceEpoch;
    final name = 'att_$stamp$ext';
    await src.copy(p.join(d.path, name));
    return name;
  }

  /// Caminho absoluto a partir do nome guardado no registro.
  Future<String> absolutePath(String filename) async {
    final d = await dir();
    return p.join(d.path, filename);
  }

  Future<File> file(String filename) async => File(await absolutePath(filename));

  Future<void> delete(String filename) async {
    final f = await file(filename);
    if (await f.exists()) await f.delete();
  }
}
