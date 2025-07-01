
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class MemoryService {
  MemoryService._();
  static final instance = MemoryService._();
  Map<String, dynamic> _memory = {};

  Future<void> _init() async {
    if (_memory.isNotEmpty) return;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/memory.json');
    if (await file.exists()) {
      _memory = jsonDecode(await file.readAsString());
    } else {
      _memory = {};
      await file.writeAsString(jsonEncode(_memory));
    }
  }

  Future<void> addFact(String prompt, String response) async {
    await _init();
    _memory[prompt] = response;
    await _save();
  }

  Future<void> _save() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/memory.json');
    await file.writeAsString(jsonEncode(_memory));
  }
}
