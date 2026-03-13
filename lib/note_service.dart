import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_quill/quill_delta.dart';
import 'package:note/l10n/app_localizations.dart';
import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';
import 'app_style.dart';
import 'package:share_plus/share_plus.dart';
import 'nota.dart';
import 'ai_notes.dart';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class NoteService {
  late SharedPreferences preferenze;
  late List<Nota> note = [];
  late List<String> elencoTag = [];
  late List<String> tagSelezionati = [];
  late List<Nota> noteFiltrate = [];
  Map<String, PlayerController> playerControllers = {};

  caricaNote() async {
    preferenze = await SharedPreferences.getInstance();
    final stringaNote = preferenze.getString('note');
    if (stringaNote != null) {
      final noteSalvate = List<String>.from(jsonDecode(stringaNote));
      note.addAll(noteSalvate.map((notaJson) => Nota.fromJsonString(notaJson)));
      elencoTag = listaTag();
    }
  }

  salvaNote() async {
    List<String> noteSalvabili = [];
    for (int i = 0; i < note.length; i++) {
      noteSalvabili.add(note[i].toJsonString());
    }
    final stringaNote = json.encode(noteSalvabili);
    await preferenze.setString("note", stringaNote);
  }

  void sostituisciNota(Nota nota, BuildContext context) {
    if (nota.titolo != "") {
      note.remove(nota);
      note.insert(0, nota);
    } else if (nota.titolo == "" && !nota.isVuota()) {
      nota.titolo = AppLocalizations.of(context)!.untitled;
      note.remove(nota);
      note.insert(0, nota);
    } else {
      note.remove(nota);
    }
  }

  List<String> listaTag() {
    List<String> tuttiTag = [];
    for (int i = 0; i < note.length; i++) {
      for (int j = 0; j < note[i].tags.length; j++) {
        if (!tuttiTag.contains(note[i].tags[j])) {
          tuttiTag.add(note[i].tags[j]);
        }
      }
    }
    return tuttiTag;
  }

  void eliminaTag(Nota nota, String tag) async {
    nota.tags.removeWhere((elemento) => elemento == tag);
    salvaNote();
    elencoTag = listaTag();
  }

  void selezionaSwitcher(bool selezionato, String tag) {
    if (selezionato) {
      tagSelezionati.add(tag);
    } else {
      tagSelezionati.remove(tag);
    }
  }

  void eliminaNota(String id) async {
    note.removeWhere((item) => item.id == id);
    elencoTag = listaTag();
    salvaNote();
  }

  void ordina(String ricerca) {
    if (ricerca.isNotEmpty) {
      noteFiltrate = note
          .where(
            (entry) => entry.titolo.toLowerCase().contains(
              ricerca.toLowerCase().trim(),
            ),
          )
          .toList();
    } else {
      noteFiltrate = List.from(note);
    }
    if (tagSelezionati.isNotEmpty) {
      noteFiltrate = noteFiltrate
          .where((n) => n.tags.any((t) => tagSelezionati.contains(t)))
          .toList();
    }

    noteFiltrate.sort((a, b) {
      if (a.pinned && !b.pinned) return -1;
      if (!a.pinned && b.pinned) return 1;
      return 0;
    });
  }

  void rimuoviCopertina(Nota nota) {
    nota.percorsoImmagine = "";
  }

  void notaPreferiti(BuildContext context, Nota nota) {
    Navigator.pop(context);
    nota.preferita = !nota.preferita;
    salvaNote();
  }

  void pinna(BuildContext context, Nota nota) {
    nota.pinned = !nota.pinned;
  }

  void aggiungiNota(Nota nota, BuildContext context) {
    if (nota.titolo != "") {
      note.insert(0, nota);
    } else if (nota.titolo == "" && !nota.isVuota()) {
      nota.titolo = AppLocalizations.of(context)!.untitled;
      note.insert(0, nota);
    }
  }

  Future<void> condividiNota(BuildContext context, Nota nota) async {
    AppStyle.dialogCaricamento(context);
    final formato = PDFPageFormat(
      marginTop: 20,
      marginBottom: 20,
      marginLeft: 15,
      marginRight: 15,
      height: 842,
      width: 595,
    );
    final PDFConverter convertitore = PDFConverter(
      pageFormat: formato,
      document: nota.contenuto,
      fallbacks: [],
      isLightCodeBlockTheme: true,
      enableCodeBlockHighlighting: true,
      paintStrikethoughStyleOnCheckedElements: true,
      codeBlockBackgroundColor: PdfColor(0.19, 0.19, 0.19, 0.5),
      codeBlockTextStyle: pw.TextStyle(
        font: pw.Font.courier(),
        color: PdfColor.fromHex('9B9B9B'),
      ),
    );
    final pdf = await convertitore.createDocument();
    final bytes = await pdf?.save();
    if (bytes != null) {
      final cartellaTemporanea = await getTemporaryDirectory();
      final percorso = '${cartellaTemporanea.path}/${nota.id}.pdf';
      final file = File(percorso);
      await file.writeAsBytes(bytes);
      Navigator.pop(context);
      await Share.shareXFiles([
        XFile(percorso),
      ], text: AppLocalizations.of(context)!.shareNote);
    }
  }

  Future<void> generaNota(Nota nuovaNota) async {
    try {
      AiNotes elaboratore = AiNotes(File(nuovaNota.percorsoAudio));
      final trascrizione = await elaboratore.transcribe();
      String jsonOutput = await elaboratore.generateNotes(trascrizione);
      final Map<String, dynamic> jsonObject = jsonDecode(jsonOutput);
      final String nuovoTitolo = jsonObject['title'] ?? "Nota Vocale Elaborata";
      final List<dynamic> content = jsonObject['delta'];
      nuovaNota.titolo = nuovoTitolo;
      nuovaNota.contenuto = Delta.fromJson(content);
    } catch (e) {
      nuovaNota.titolo = "ERRORE di Elaborazione";
      nuovaNota.contenuto = Delta.fromJson([
        {"insert": "$e\n"},
      ]);
    } finally {
      nuovaNota.processing = false;
    }
  }

  Future<void> initPlayerControllers() async {
    for (int i = 0; i < note.length; i++) {
      if (note[i].percorsoAudio != "") {
        PlayerController player = PlayerController();
        await player.preparePlayer(path: note[i].percorsoAudio);
        playerControllers[note[i].id] = player;
      }
    }
  }

  Future<void> disposePlayerControllers() async {
    for (final controller in playerControllers.values) {
      controller.dispose();
    }
  }

  Future<bool> confermaEliminazione(
    BuildContext context,
    String id,
    Function setState,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.deleteNote),
            content: Text(AppLocalizations.of(context)!.deleteConfirmation),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(right: 10),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(color: AppStyle.background),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(left: 10),
                      child: ElevatedButton(
                        onPressed: () => {
                          eliminaNota(id),
                          initPlayerControllers(),
                          setState(),
                          Navigator.pop(context),
                        },
                        child: Text(
                          AppLocalizations.of(context)!.delete,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> dialogCreaTag(
    BuildContext context,
    Nota nota,
    Function setState,
  ) async {
    TextEditingController tagController = TextEditingController();
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Crea un nuovo tag'),
            actions: [
              TextField(
                decoration: AppStyle.textField(
                  AppLocalizations.of(context)!.tagName,
                ),
                controller: tagController,
                style: TextStyle(color: AppStyle.textPrimary),
              ),
              Padding(
                padding: EdgeInsetsGeometry.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Annulla',
                            style: TextStyle(color: AppStyle.background),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(left: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            if (tagController.text != "" &&
                                !nota.tags.contains(tagController.text)) {
                              nota.tags.add(tagController.text);
                              elencoTag = listaTag();
                              salvaNote();
                            }
                            setState();
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.check, color: AppStyle.background),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void selezionaCopertina(Nota nota, Function setState) async {
    final picker = ImagePicker();
    final XFile? immagineScelta = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (immagineScelta != null) {
      final cartellaDocumenti = await getApplicationDocumentsDirectory();
      final percorsoImmagini = Directory(
        p.join(cartellaDocumenti.path, 'copertine'),
      );
      if (!await percorsoImmagini.exists()) {
        await percorsoImmagini.create(recursive: true);
      }
      final nomeFile =
          'cover${DateTime.now().millisecondsSinceEpoch}${p.extension(immagineScelta.path)}';
      final percorsoCopertina = p.join(percorsoImmagini.path, nomeFile);
      final fileCopiato = await File(
        immagineScelta.path,
      ).copy(percorsoCopertina);
      nota.percorsoImmagine = fileCopiato.path;
      setState();
      salvaNote();
    }
  }
}
