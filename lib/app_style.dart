import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'nota.dart';
import 'package:note/l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class AppStyle {
  bool scuro = true;
  static const background = Color(0xFF191919);
  static const textPrimary = Color(0xFFD4D4D4);
  static const textSecondary = Color(0xFF9B9B9B);
  static const accent = Color(0xFFF6E9D7);
  static const textFieldColor = Color(0x1AF6E9D7);

  static final dialogTheme = DialogThemeData(
    backgroundColor: background,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    titleTextStyle: TextStyle(
      color: textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: TextStyle(color: textSecondary, fontSize: 15),
  );

  static final searchBar = SearchBarThemeData(
    backgroundColor: WidgetStatePropertyAll(textFieldColor),
    elevation: WidgetStatePropertyAll(0),
    hintStyle: WidgetStatePropertyAll(const TextStyle(color: textSecondary)),
    textStyle: WidgetStatePropertyAll(
      const TextStyle(color: textPrimary, fontSize: 10),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
    ),
  );

  static final appBar = AppBarTheme(
    backgroundColor: background,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: accent),
  );

  static final floatingButton = FloatingActionButtonThemeData(
    backgroundColor: textSecondary,
    foregroundColor: background,
    elevation: 2,
  );

  static final text = TextTheme(bodyMedium: TextStyle(color: textSecondary));

  static final elevatedButton = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(accent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  );

  static ButtonStyle optionsElevatedButton() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 16),
      shadowColor: Color.fromARGB(0, 0, 0, 0),
      backgroundColor: textFieldColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  static InputDecoration textField(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textSecondary, fontSize: 14),
      filled: true,
      fillColor: textFieldColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static BoxDecoration card(int totalCards, int cardNumber, Nota nota) {
    return BoxDecoration(
      image: nota.percorsoImmagine == ""
          ? null
          : DecorationImage(
              image: FileImage(File(nota.percorsoImmagine)),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.6),
                BlendMode.darken,
              ),
            ),
      color: textFieldColor,
      borderRadius: totalCards == 1
          ? BorderRadius.circular(15)
          : cardNumber == 0
          ? BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            )
          : cardNumber == totalCards - 1
          ? BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )
          : BorderRadius.circular(10),
      border: Border.all(color: background.withValues(alpha: 0.4)),
    );
  }

  static final iconButton = IconButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(textFieldColor),
      foregroundColor: WidgetStatePropertyAll(textPrimary),
      padding: WidgetStatePropertyAll(EdgeInsets.all(6)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      overlayColor: WidgetStatePropertyAll(accent.withValues(alpha: 0.2)),
    ),
  );

  static final chip = ChipThemeData(
    backgroundColor: accent.withValues(alpha: 0.2),
    selectedColor: accent,
    labelStyle: TextStyle(color: textPrimary),
    secondaryLabelStyle: TextStyle(color: textSecondary),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );

  static void menu(
    BuildContext context,
    Nota nota,
    Function() onShare,
    Function() onDelete,
    Function() onAddTag,
    Function() onFavourites,
    Function() onCover,
    Function() onRemoveCover,
    Function() onPin,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      backgroundColor: background,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(
                        top: 20,
                        left: 20,
                        right: 10,
                      ),
                      child: FloatingActionButton(
                        onPressed: () => {Navigator.pop(context), onShare()},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Icon(Icons.share),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(
                        top: 20,
                        right: 20,
                        left: 10,
                      ),
                      child: FloatingActionButton(
                        onPressed: () => {Navigator.pop(context), onDelete()},

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Icon(Icons.delete),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: optionsElevatedButton(),
                      onPressed: () {
                        Navigator.pop(context);
                        onAddTag();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Icon(Icons.label, color: textSecondary),
                          ),
                          Text(
                            AppLocalizations.of(context)!.addTag,
                            style: TextStyle(color: textSecondary),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: optionsElevatedButton(),
                      onPressed: () {
                        onFavourites();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Icon(
                              nota.preferita ? Icons.star_border : Icons.star,
                              color: textSecondary,
                            ),
                          ),
                          Text(
                            nota.preferita
                                ? AppLocalizations.of(
                                    context,
                                  )!.removeFromFavourites
                                : AppLocalizations.of(context)!.addToFavourites,
                            style: TextStyle(color: textSecondary),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    nota.percorsoImmagine == ""
                        ? ElevatedButton(
                            style: optionsElevatedButton(),
                            onPressed: () {
                              Navigator.pop(context);
                              onCover();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Icon(
                                    Icons.image,
                                    color: textSecondary,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.addCover,
                                  style: TextStyle(color: textSecondary),
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            style: optionsElevatedButton(),
                            onPressed: () {
                              Navigator.pop(context);
                              onRemoveCover();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: textSecondary,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.removeCover,
                                  style: TextStyle(color: textSecondary),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: optionsElevatedButton(),
                      onPressed: () {
                        Navigator.pop(context);
                        onPin();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Icon(Icons.push_pin, color: textSecondary),
                          ),
                          Text(
                            nota.pinned
                                ? AppLocalizations.of(context)!.unpinNote
                                : AppLocalizations.of(context)!.pinNote,
                            style: TextStyle(color: textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Padding barraRicerca(
    BuildContext context,
    FocusNode focus,
    TextEditingController controller,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SearchBar(
        controller: controller,
        focusNode: focus,
        onChanged: onChanged,
        hintText: AppLocalizations.of(context)!.searchHint,
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 20, color: textSecondary),
        ),
        hintStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 18, color: Colors.grey),
        ),
        constraints: BoxConstraints(
          minHeight: 50, // <-- riduce altezza barra
          maxHeight: 50,
        ),
      ),
    );
  }

  static Padding capsulaFiltro(
    List<String> selectedTags,
    String tag,
    Function(bool) onSelected,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.only(right: 5),
      child: FilterChip(
        selected: selectedTags.contains(tag),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        backgroundColor: background,
        selectedColor: accent.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        label: Text(
          tag,
          style: TextStyle(
            color: selectedTags.contains(tag) ? background : textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        onSelected: onSelected,
      ),
    );
  }

  static InkWell pillolaTag(String tag, bool editMode, Function(String) onTap) {
    return InkWell(
      onTap: () => onTap(tag),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        key: ValueKey(tag),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: editMode ? Colors.red : accent.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(tag, style: TextStyle(color: accent, fontSize: 12)),
      ),
    );
  }

  static Padding sezioneTags(
    List<String> tags,
    bool editMode,
    Function(String) onTap,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: tags.map((tag) {
          return pillolaTag(tag, editMode, (t) => onTap(t));
        }).toList(),
      ),
    );
  }

  static Padding sezioneFiltri(
    List<String> tags,
    List<String> tagSelezionati,
    Function(bool, String) onSelected,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          itemCount: tags.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return capsulaFiltro(
              tagSelezionati,
              tags[index],
              (selezionato) => onSelected(selezionato, tags[index]),
            );
          },
        ),
      ),
    );
  }

  static StreamBuilder musicPlayer(AudioPlayer player) {
    return StreamBuilder(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        return Container(
          margin: EdgeInsets.all(14),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: textFieldColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: textSecondary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  if (playing) {
                    player.pause();
                  } else {
                    player.play();
                  }
                },
                backgroundColor: textFieldColor, // Notion-style soft
                foregroundColor: textPrimary,
                elevation: 2,
                shape: const CircleBorder(),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 150),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                  child: playing
                      ? const Icon(
                          Icons.pause,
                          key: ValueKey('pause'),
                          size: 28,
                          color: textPrimary,
                        )
                      : const Icon(
                          Icons.play_arrow,
                          key: ValueKey('play'),
                          size: 28,
                          color: textPrimary,
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: StreamBuilder<Duration>(
                    stream: player.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final totalDuration = player.duration ?? Duration.zero;

                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
                          activeTrackColor: accent.withValues(alpha: 0.8),
                          inactiveTrackColor: textSecondary.withValues(
                            alpha: 0.3,
                          ),
                          thumbColor: accent,
                          overlayColor: accent.withValues(alpha: 0.2),
                          trackShape: RoundedRectSliderTrackShape(),
                        ),
                        child: Slider(
                          value: position.inMilliseconds.toDouble().clamp(
                            0,
                            totalDuration.inMilliseconds.toDouble(),
                          ),
                          max: totalDuration.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            player.seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Theme barraQuill(
    quill.QuillController notaController,
    Function selezioneImmagine,
  ) {
    return Theme(
      data: ThemeData(iconTheme: IconThemeData(color: textPrimary)),
      child: quill.QuillSimpleToolbar(
        controller: notaController,
        config: quill.QuillSimpleToolbarConfig(
          embedButtons: FlutterQuillEmbeds.toolbarButtons(
            videoButtonOptions: null,
            imageButtonOptions: QuillToolbarImageButtonOptions(
              imageButtonConfig: QuillToolbarImageConfig(
                onImageInsertedCallback: (image) async {
                  final indice = notaController.selection.baseOffset;
                  notaController.document.insert(indice, "\n");
                  notaController.updateSelection(
                    TextSelection.collapsed(offset: indice + 1),
                    quill.ChangeSource.local,
                  );
                },
                onRequestPickImage: (context) async {
                  String percorso = await selezioneImmagine();
                  if (percorso != "") {
                    return percorso;
                  }
                  return null;
                },
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: textFieldColor,

            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),

          iconTheme: quill.QuillIconTheme(
            iconButtonSelectedData: quill.IconButtonData(color: background),
            iconButtonUnselectedData: quill.IconButtonData(
              color: accent.withAlpha(100),
            ),
          ),

          showUndo: true,
          showRedo: true,
          multiRowsDisplay: false,
          showDividers: false,
          showFontFamily: false,
          showFontSize: false,
          showBoldButton: true,
          showItalicButton: true,
          showSmallButton: false,
          showUnderLineButton: true,
          showLineHeightButton: false,
          showStrikeThrough: true,
          showInlineCode: false,
          showColorButton: false,
          showBackgroundColorButton: false,
          showClearFormat: false,
          showAlignmentButtons: false,
          showLeftAlignment: true,
          showCenterAlignment: true,
          showRightAlignment: true,
          showJustifyAlignment: true,
          showHeaderStyle: false,
          showListNumbers: true,
          showListBullets: true,
          showListCheck: true,
          showCodeBlock: true,
          showQuote: true,
          showIndent: true,
          showLink: false,
          showDirection: false,
          showSearchButton: false,
          showSubscript: false,
          showSuperscript: false,
          showClipboardCut: false,
          showClipboardCopy: false,
          showClipboardPaste: false,
          buttonOptions: quill.QuillSimpleToolbarButtonOptions(
            base: quill.QuillToolbarBaseButtonOptions(
              iconSize: 10,
              iconTheme: quill.QuillIconTheme(
                iconButtonSelectedData: quill.IconButtonData(
                  color: textPrimary,
                ),
                iconButtonUnselectedData: quill.IconButtonData(
                  color: textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static quill.QuillEditor editorQuill(
    BuildContext context,
    quill.QuillController notaController,
    FocusNode scrivendo,
  ) {
    return quill.QuillEditor(
      controller: notaController,
      focusNode: scrivendo,
      scrollController: ScrollController(),
      config: quill.QuillEditorConfig(
        embedBuilders: FlutterQuillEmbeds.editorBuilders(
          imageEmbedConfig: QuillEditorImageEmbedConfig(
            onImageClicked: (imageSource) {},
          ),
        ),
        customStyles: quill.DefaultStyles(
          placeHolder: quill.DefaultTextBlockStyle(
            TextStyle(
              color: textSecondary.withValues(alpha: 0.4),
              fontSize: 16,
            ),
            quill.HorizontalSpacing(0, 0),
            quill.VerticalSpacing(4, 4),
            quill.VerticalSpacing(4, 4),
            null,
          ),
          paragraph: quill.DefaultTextBlockStyle(
            TextStyle(color: textPrimary, fontSize: 18),
            quill.HorizontalSpacing(0, 0),
            quill.VerticalSpacing(4, 4),
            quill.VerticalSpacing(4, 4),
            null,
          ),
          link: TextStyle(
            color: Colors.blue,
            decorationColor: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          code: quill.DefaultTextBlockStyle(
            TextStyle(
              color: textPrimary,
              decorationColor: textPrimary,
              fontFamily: 'monospace',
              fontSize: 14,
            ),
            quill.HorizontalSpacing(0, 0),
            quill.VerticalSpacing(8, 8),
            quill.VerticalSpacing(8, 8),
            BoxDecoration(
              color: textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          underline: TextStyle(
            color: textPrimary,
            fontSize: 18,
            decoration: TextDecoration.underline,
            decorationColor: textPrimary,
          ),
          strikeThrough: TextStyle(
            color: textPrimary,
            fontSize: 18,
            decoration: TextDecoration.lineThrough,
            decorationColor: textPrimary,
          ),
          indent: quill.DefaultTextBlockStyle(
            TextStyle(
              color: textPrimary,
              fontSize: 18,
              decorationColor: textPrimary,
            ),
            quill.HorizontalSpacing(0, 0),
            quill.VerticalSpacing(4, 4),
            quill.VerticalSpacing(4, 4),
            null,
          ),
          bold: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          italic: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
        ),
        autoFocus: false,
        scrollable: false,
        expands: false,
        placeholder: AppLocalizations.of(context)!.contentPlaceholder,
      ),
    );
  }

  static Widget creditiFiniti(BuildContext context) {
    return AlertDialog(
      backgroundColor: background,
      title: Text(
        AppLocalizations.of(context)!.noCredits,
        style: TextStyle(color: textPrimary),
      ),
      content: Text(
        AppLocalizations.of(context)!.minutiEsauriti,
        style: TextStyle(color: textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }

  static void dialogCaricamento(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppStyle.background,
          title: Text(
            AppLocalizations.of(context)!.pdfCreation,
            style: TextStyle(color: AppStyle.textPrimary),
          ),
          content: SizedBox(
            height: 80,
            child: Center(
              child: CircularProgressIndicator(color: AppStyle.accent),
            ),
          ),
        );
      },
    );
  }
}
