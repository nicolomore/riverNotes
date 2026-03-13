import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:note/l10n/app_localizations.dart';
import 'app_style.dart';
import 'nota.dart';
import 'modifica_nota.dart';
import 'note_service.dart';
import 'record.dart';
import 'subscribe.dart';
import 'payment_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String ricerca = "";
  late final FocusNode focusRicerca = FocusNode();
  late final TextEditingController controllerRicerca = TextEditingController();
  bool editMode = false;
  late NoteService servizioNote = NoteService();
  bool createMenu = false;
  PaymentService pagamenti = PaymentService();

  @override
  void initState() {
    super.initState();
    inizializza();
  }

  Future<void> inizializza() async {
    await inizializzaNote();
    await pagamenti.inizializza();
    await pagamenti.isAbbonato(DateTime.now().toUtc());
    setState(() {});
  }

  Future<void> inizializzaNote() async {
    await servizioNote.caricaNote();
    await servizioNote.initPlayerControllers();
    setState(() {});
  }

  @override
  void dispose() {
    focusRicerca.dispose();
    controllerRicerca.dispose();
    servizioNote.disposePlayerControllers();
    super.dispose();
  }

  void aggornaRicerca(String valore) {
    setState(() {
      ricerca = valore;
    });
  }

  void tornaHome() {
    servizioNote.salvaNote();
    setState(() {
      focusRicerca.unfocus();
      controllerRicerca.value = TextEditingValue.empty;
      ricerca = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    servizioNote.ordina(ricerca);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 100),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: IconButton(
                key: ValueKey(editMode),
                onPressed: () => {
                  setState(() {
                    editMode = !editMode;
                  }),
                },
                icon: Icon(editMode ? Icons.check : Icons.edit),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: AppStyle.background,
        child: Column(
          children: [
            AppStyle.barraRicerca(
              context,
              focusRicerca,
              controllerRicerca,
              (valore) => aggornaRicerca(valore),
            ),
            servizioNote.elencoTag.isEmpty
                ? SizedBox(height: 15)
                : AppStyle.sezioneFiltri(
                    servizioNote.elencoTag,
                    servizioNote.tagSelezionati,
                    (selezionato, tag) => setState(() {
                      servizioNote.selezionaSwitcher(selezionato, tag);
                    }),
                  ),
            servizioNote.note.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.noNotes),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: servizioNote.noteFiltrate.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: 16.0,
                            left: 16.0,
                            bottom: 8,
                          ),
                          child: Container(
                            decoration: AppStyle.card(
                              servizioNote.noteFiltrate.length,
                              index,
                              servizioNote.noteFiltrate[index],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              leading:
                                  servizioNote.noteFiltrate[index].preferita
                                  ? Icon(Icons.star, color: Colors.yellow)
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  servizioNote.noteFiltrate[index].pinned
                                      ? Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: IconButton(
                                            onPressed: () => setState(() {
                                              servizioNote.pinna(
                                                context,
                                                servizioNote
                                                    .noteFiltrate[index],
                                              );
                                            }),

                                            icon: Icon(Icons.push_pin),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  AnimatedSwitcher(
                                    duration: Duration(milliseconds: 100),
                                    transitionBuilder:
                                        (
                                          Widget child,
                                          Animation<double> animation,
                                        ) {
                                          // Entrata con un effetto scala+rotazione
                                          final inAnimation = CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.elasticOut,
                                          );

                                          return ScaleTransition(
                                            scale: inAnimation,
                                            child: RotationTransition(
                                              turns: inAnimation,
                                              child: FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              ),
                                            ),
                                          );
                                        },
                                    child: editMode
                                        ? IconButton(
                                            key: ValueKey('delete'),
                                            onPressed: () async {
                                              await servizioNote
                                                  .confermaEliminazione(
                                                    context,
                                                    servizioNote
                                                        .noteFiltrate[index]
                                                        .id,
                                                    () => setState(() {}),
                                                  );
                                            },

                                            icon: Icon(Icons.delete),
                                            color: Colors.white,
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                    Colors.red,
                                                  ),
                                            ),
                                          )
                                        : IconButton(
                                            key: ValueKey('menu'),
                                            onPressed: () => AppStyle.menu(
                                              context,
                                              servizioNote.noteFiltrate[index],
                                              () => servizioNote.condividiNota(
                                                context,
                                                servizioNote
                                                    .noteFiltrate[index],
                                              ),
                                              () async {
                                                await servizioNote
                                                    .confermaEliminazione(
                                                      context,
                                                      servizioNote
                                                          .noteFiltrate[index]
                                                          .id,
                                                      () => setState(() {}),
                                                    );
                                              },
                                              () => servizioNote.dialogCreaTag(
                                                context,
                                                servizioNote
                                                    .noteFiltrate[index],
                                                () => setState(() {}),
                                              ),
                                              () {
                                                setState(() {
                                                  servizioNote.notaPreferiti(
                                                    context,
                                                    servizioNote
                                                        .noteFiltrate[index],
                                                  );
                                                });
                                              },
                                              () => servizioNote
                                                  .selezionaCopertina(
                                                    servizioNote
                                                        .noteFiltrate[index],
                                                    () => setState(() {}),
                                                  ),
                                              () => setState(() {
                                                servizioNote.rimuoviCopertina(
                                                  servizioNote
                                                      .noteFiltrate[index],
                                                );
                                              }),

                                              () => setState(() {
                                                servizioNote.pinna(
                                                  context,
                                                  servizioNote
                                                      .noteFiltrate[index],
                                                );
                                              }),
                                            ),
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: AppStyle.textSecondary,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              title: Padding(
                                padding: EdgeInsetsGeometry.only(
                                  left: 8,
                                  bottom: 2,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: Duration(milliseconds: 200),
                                      transitionBuilder:
                                          (
                                            Widget child,
                                            Animation<double> animation,
                                          ) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(
                                                    0.1,
                                                    0,
                                                  ), // parte leggermente spostato a destra
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              ),
                                            );
                                          },
                                      child:
                                          servizioNote
                                              .noteFiltrate[index]
                                              .processing
                                          ? Text(
                                              "Elaborazione...",
                                              style: TextStyle(
                                                color: AppStyle.textPrimary,
                                                fontSize: 18,
                                              ),
                                              key: ValueKey(
                                                servizioNote
                                                    .noteFiltrate[index]
                                                    .processing,
                                              ),
                                            )
                                          : Text(
                                              servizioNote
                                                  .noteFiltrate[index]
                                                  .titolo,
                                              style: TextStyle(
                                                color: AppStyle.textPrimary,
                                                fontSize: 18,
                                              ),
                                              key: ValueKey(
                                                servizioNote
                                                    .noteFiltrate[index]
                                                    .processing,
                                              ),
                                            ),
                                    ),

                                    if (servizioNote
                                            .noteFiltrate[index]
                                            .percorsoAudio !=
                                        "")
                                      AudioFileWaveforms(
                                        key: ValueKey(
                                          servizioNote.noteFiltrate[index].id,
                                        ),
                                        enableSeekGesture: false,
                                        size: Size(
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                          40,
                                        ),
                                        playerController:
                                            servizioNote
                                                .playerControllers[servizioNote
                                                .noteFiltrate[index]
                                                .id]!,
                                        waveformType: WaveformType.fitWidth,
                                        playerWaveStyle: PlayerWaveStyle(
                                          showSeekLine: false,
                                          scaleFactor: 50.0,
                                          waveCap: StrokeCap.round,
                                        ),
                                      ),
                                    Text(
                                      servizioNote.noteFiltrate[index].data,
                                      style: TextStyle(
                                        color: AppStyle.textSecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                    if (servizioNote
                                        .noteFiltrate[index]
                                        .tags
                                        .isNotEmpty)
                                      AppStyle.sezioneTags(
                                        servizioNote.noteFiltrate[index].tags,
                                        editMode,
                                        (tag) => setState(() {
                                          servizioNote.eliminaTag(
                                            servizioNote.noteFiltrate[index],
                                            tag,
                                          );
                                        }),
                                      ),
                                  ],
                                ),
                              ),
                              onTap:
                                  editMode ||
                                      servizioNote
                                          .noteFiltrate[index]
                                          .processing
                                  ? () {}
                                  : () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ModificaNota(
                                            nota: servizioNote
                                                .noteFiltrate[index],
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        servizioNote.sostituisciNota(
                                          servizioNote.noteFiltrate[index],
                                          context,
                                        );
                                      });

                                      tornaHome();
                                    },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final scaleAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              );
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  alignment: Alignment.bottomCenter,
                  child: child,
                ),
              );
            },
            child: createMenu
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    key: const ValueKey<bool>(true),
                    children: [
                      FloatingActionButton(
                        heroTag: 'voiceButton',
                        mini: true,
                        onPressed: pagamenti.abbonato
                            ? () async {
                                Nota nuovaNota = Nota.notaVuota();
                                setState(() {
                                  createMenu = !createMenu;
                                });
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Record(nota: nuovaNota),
                                  ),
                                );
                                if (nuovaNota.percorsoAudio.isNotEmpty) {
                                  nuovaNota.processing = true;
                                  PlayerController player = PlayerController();
                                  await player.preparePlayer(
                                    path: nuovaNota.percorsoAudio,
                                  );
                                  servizioNote.playerControllers[nuovaNota.id] =
                                      player;
                                  servizioNote.aggiungiNota(nuovaNota, context);
                                  tornaHome();
                                  if (pagamenti.aggiungiMinuti(
                                    (await player.getDuration(
                                              DurationType.max,
                                            ) /
                                            60000)
                                        .round(),
                                  )) {
                                    await servizioNote.generaNota(nuovaNota);
                                  } else {
                                    AppStyle.creditiFiniti(context);
                                  }
                                  setState(() {});
                                }
                              }
                            : () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Subscribe(),
                                  ),
                                );
                                await pagamenti.isAbbonato(
                                  DateTime.now().toUtc(),
                                );
                              },
                        child: Icon(Icons.mic),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: 'noteButton',
                        mini: true,
                        onPressed: () async {
                          Nota nuovaNota = Nota.notaVuota();

                          setState(() {
                            createMenu = !createMenu;
                          });
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ModificaNota(nota: nuovaNota),
                            ),
                          );
                          servizioNote.aggiungiNota(nuovaNota, context);
                          tornaHome();
                        },
                        child: const Icon(Icons.note),
                      ),
                      SizedBox(height: 10),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          FloatingActionButton(
            key: const ValueKey<bool>(false),
            onPressed: () => setState(() {
              createMenu = !createMenu;
            }),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 100),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: RotationTransition(turns: animation, child: child),
                );
              },
              child: Icon(
                createMenu ? Icons.close : Icons.add,
                key: ValueKey<bool>(createMenu),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
