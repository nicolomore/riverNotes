import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:note/l10n/app_localizations.dart';
import 'app_style.dart';
import 'nota.dart';

class ModificaNota extends StatefulWidget {
  final Nota nota;

  const ModificaNota({super.key, required this.nota});

  @override
  State<ModificaNota> createState() => ModificaNotaState();
}

class ModificaNotaState extends State<ModificaNota> {
  final quill.QuillController notaController = quill.QuillController.basic();
  final TextEditingController titoloController = TextEditingController();
  AudioPlayer player = AudioPlayer();
  late Nota nota;
  late final FocusNode scrivendo = FocusNode();
  late ScrollController scroller = ScrollController();
  bool showBar = false;

  void gestureIndietro(bool pop, dynamic risultato) {
    if (!pop) {
      nota.titolo = titoloController.text;
      nota.contenuto = notaController.document.toDelta();
      nota.data = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
      Navigator.pop(context);
    }
  }

  Future<String> aggiungiImmagine() async {
    final picker = ImagePicker();
    final XFile? immagineScelta = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (immagineScelta != null) {
      return immagineScelta.path;
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    nota = widget.nota;
    titoloController.text = widget.nota.titolo;
    if (widget.nota.contenuto == Delta()) {
      notaController.document = quill.Document();
    } else {
      notaController.document = quill.Document.fromDelta(widget.nota.contenuto);
    }
    scrivendo.addListener(() {
      setState(() {});
    });
    notaController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scroller.hasClients) {
          scroller.animateTo(
            scroller.position.maxScrollExtent,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
    });
    if (nota.percorsoAudio != "") {
      player = AudioPlayer();
      player.setFilePath(nota.percorsoAudio);
    }
  }

  @override
  void dispose() {
    notaController.dispose();
    titoloController.dispose();
    scrivendo.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0 && !showBar) {
      Future.delayed(Duration(milliseconds: 230), () {
        showBar = true;
        setState(() {});
      });
    } else if (MediaQuery.of(context).viewInsets.bottom < 200 && showBar) {
      showBar = false;
      setState(() {});
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: gestureIndietro,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scroller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        height: nota.percorsoImmagine == "" ? 70 : 140,
                        decoration: nota.percorsoImmagine == ""
                            ? null
                            : BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(nota.percorsoImmagine)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Hero(
                                tag: 'noteButton',
                                child: IconButton(
                                  onPressed: () {
                                    nota.titolo = titoloController.text;
                                    nota.contenuto = notaController.document
                                        .toDelta();
                                    nota.data = DateFormat(
                                      'dd/MM/yyyy HH:mm',
                                    ).format(DateTime.now());
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (nota.preferita) {
                                      nota.preferita = false;
                                    } else {
                                      nota.preferita = true;
                                    }
                                  });
                                },
                                icon: nota.preferita
                                    ? Icon(Icons.star)
                                    : Icon(Icons.star_border),
                              ),
                            ),
                          ],
                        ),
                      ),
                      nota.percorsoAudio != ""
                          ? AppStyle.musicPlayer(player)
                          : SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 14.0,
                          right: 14.0,
                          bottom: 5,
                        ),
                        child: TextField(
                          style: TextStyle(
                            color: AppStyle.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          controller: titoloController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.titleHint,
                            hintStyle: TextStyle(
                              color: AppStyle.textSecondary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          bottom: 8,
                        ),
                        child: AppStyle.editorQuill(
                          context,
                          notaController,
                          scrivendo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (showBar)
                AppStyle.barraQuill(notaController, aggiungiImmagine),
            ],
          ),
        ),
      ),
    );
  }
}
