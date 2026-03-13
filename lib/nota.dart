import 'package:flutter_quill/quill_delta.dart';
import 'dart:convert';

class Nota {
  late String titolo, data, id;
  late Delta contenuto;
  late List<String> tags;
  late bool preferita;
  late String percorsoImmagine;
  late bool pinned;
  late String percorsoAudio;
  late bool processing;

  Nota(
    this.titolo,
    this.contenuto,
    this.data,
    this.tags,
    this.id,
    this.preferita,
    this.percorsoImmagine,
    this.pinned,
    this.percorsoAudio,
    this.processing,
  );

  String toJsonString() {
    Map<String, dynamic> mappa = {
      'titolo': titolo,
      'contenuto': contenuto.toJson(),
      'data': data,
      'id': id,
      'tags': jsonEncode(tags),
      'preferita': preferita,
      'percorsoImmagine': percorsoImmagine,
      'pinned': pinned,
      'percorsoAudio': percorsoAudio,
      'processing': processing,
    };
    return jsonEncode(mappa);
  }

  factory Nota.fromJsonString(String jsonString) {
    Map<String, dynamic> mappa = jsonDecode(jsonString);
    return Nota(
      mappa['titolo'],
      Delta.fromJson(mappa['contenuto']),
      mappa['data'],
      List<String>.from(jsonDecode(mappa['tags'])),
      mappa['id'],
      mappa['preferita'],
      mappa['percorsoImmagine'],
      mappa['pinned'] ?? false,
      mappa['percorsoAudio'] ?? "",
      mappa['processing'] ?? false,
    );
  }

  factory Nota.notaVuota() {
    return Nota(
      "",
      Delta(),
      "",
      [],
      DateTime.now().millisecondsSinceEpoch.toString(),
      false,
      "",
      false,
      "",
      false,
    );
  }

  bool isVuota() {
    if (contenuto.length == 1 &&
        contenuto.first.data == "\n" &&
        contenuto.first.isInsert &&
        percorsoAudio == "") {
      return true;
    } else {
      return false;
    }
  }
}
