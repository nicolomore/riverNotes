import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';

class AiNotes {
  late File audio;
  AiNotes(this.audio);

  Future<List<File>> dividiAudio() async {
    final cartella = audio.parent;
    final audioNoEstensione = p.basenameWithoutExtension(audio.path);
    final estensione = p.extension(audio.path);
    final patternOutput = p.join(
      cartella.path,
      "${audioNoEstensione}_parte_%03d$estensione",
    );
    final comando =
        '-i "${audio.path}" -f segment -segment_time 600 -c copy "$patternOutput"';
    final sessione = await FFmpegKit.execute(comando);
    final codice = await sessione.getReturnCode();
    if (codice?.isValueSuccess() ?? false) {
      final audioGenerati = cartella
          .listSync()
          .whereType<File>()
          .where((f) => f.path.contains("${audioNoEstensione}_parte_"))
          .toList();
      audioGenerati.sort((a, b) => a.path.compareTo(b.path));
      return audioGenerati;
    } else {
      final logs = await sessione.getAllLogs();
      throw Exception(
        'Errore segmentazione audio: ${logs.map((l) => l.getMessage()).join("\n")}',
      );
    }
  }

  Future<String> transcribe() async {
    await dotenv.load(fileName: "apiKeys.env");
    String? apiKey = dotenv.env["OPENAI"];
    if (audio.lengthSync() >= 22 * 1024 * 1024) {
      final parti = await dividiAudio();
      String testoIntero = "";
      for (final parte in parti) {
        var request = http.MultipartRequest(
          "POST",
          Uri.parse("https://api.openai.com/v1/audio/transcriptions"),
        );

        request.headers["Authorization"] = "Bearer $apiKey";
        request.fields['model'] = "whisper-1";
        request.files.add(
          await http.MultipartFile.fromPath("file", parte.path),
        );
        var response = await request.send();
        var body = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(body);
          testoIntero += "${jsonResponse["text"]}\n";
        } else {
          throw Exception("Errore trascrizione: $body");
        }
      }
      return testoIntero;
    } else {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://api.openai.com/v1/audio/transcriptions"),
      );

      request.headers["Authorization"] = "Bearer $apiKey";
      request.fields['model'] = "whisper-1";
      request.files.add(await http.MultipartFile.fromPath("file", audio.path));
      var response = await request.send();
      var body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(body);
        return jsonResponse["text"];
      } else {
        throw Exception("Errore trascrizione: $body");
      }
    }
  }

  Future<String> generateNotes(String transcription) async {
    await dotenv.load(fileName: "apiKeys.env");
    String? apiKey = dotenv.env["OPENAI"];
    var response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "system",
            "content":
                "Sei un assistente specializzato nella creazione di appunti strutturate. Analizza il testo fornito. **Primo compito:** Estrai una frase chiave o un argomento principale per generare un titolo conciso, BREVE, e pertinente per la nota (circa 4 parole). **Secondo compito:** Genera un array JSON che rappresenti il formato 'Delta' compatibile con la libreria Flutter Quill, contenente gli appunti formattati in modo leggibile (ad esempio, titoli, elenchi, grassetti, ecc.). La risposta deve essere un **SINGOLO** oggetto JSON. Questo oggetto deve avere due chiavi: 'title' (contenente il titolo generato) e 'delta' (contenente l'array Delta). È **assolutamente fondamentale** che l'ultimo elemento dell'array Delta sia un oggetto che inserisce un carattere di a capo, come `{\"insert\":\"\\n\"}`, per garantire la compatibilità con Flutter Quill. Restituisci **SOLO** un oggetto JSON valido, senza testo, senza markdown, senza ```.",
          },
          {"role": "user", "content": transcription},
        ],
        "temperature": 0.3,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse["choices"][0]["message"]["content"];
    } else {
      throw Exception("Errore generazione appunti: ${response.body}");
    }
  }
}
