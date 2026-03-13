import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:note/app_style.dart';
import 'package:path_provider/path_provider.dart';
import 'nota.dart';
import 'package:intl/intl.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Record extends StatefulWidget {
  final Nota nota;

  const Record({super.key, required this.nota});

  @override
  State<Record> createState() => RecordState();
}

class RecordState extends State<Record> {
  bool recording = false;
  bool listening = false;
  late Nota nota;
  String? audioPath;
  late final RecorderController recordController;

  @override
  void initState() {
    super.initState();
    nota = widget.nota;
    initRecorder();
  }

  void initRecorder() async {
    recordController = RecorderController();
    recordController.androidEncoder = AndroidEncoder.aac;
    recordController.androidOutputFormat = AndroidOutputFormat.mpeg4;
    recordController.sampleRate = 44100;
    recordController.bitRate = 128000;
    recordController.updateFrequency = Duration(milliseconds: 50);
  }

  @override
  void dispose() {
    super.dispose();
    recordController.dispose();
    WakelockPlus.disable();
  }

  Future<void> startRecording() async {
    try {
      WakelockPlus.enable();
      final audioDir = await getApplicationDocumentsDirectory();
      nota.percorsoAudio =
          "${audioDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp3";
      await recordController.record(path: nota.percorsoAudio);
      setState(() {
        recording = true;
        listening = true;
      });
    } catch (e) {
      debugPrint("Errore durante l'avvio della registrazione: $e");
    }
  }

  Future<void> deleteRecording() async {
    WakelockPlus.disable();
    await recordController.stop();
    setState(() {
      recording = false;
      listening = false;
    });
    nota.percorsoAudio = "";
  }

  Future<void> stopRecording() async {
    WakelockPlus.disable();
    await recordController.stop();
    nota.data = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    setState(() {
      recording = false;
      listening = false;
    });
  }

  Future<void> pauseRecording() async {
    if (recordController.isRecording) {
      recordController.pause();
      setState(() {
        listening = false;
      });
    } else {
      recordController.record();
      setState(() {
        listening = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: recording
              ? Column(
                  key: const ValueKey<bool>(true),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(
                          top: 20,
                          left: 10,
                          right: 10,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppStyle.textFieldColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(20),

                          child: Center(
                            child: AudioWaveforms(
                              size: Size(
                                MediaQuery.of(context).size.width - 40,
                                100,
                              ),
                              recorderController: recordController,
                              waveStyle: WaveStyle(
                                waveColor: AppStyle.accent.withValues(
                                  alpha: 0.3,
                                ),
                                extendWaveform: true,
                                showMiddleLine: false,
                                spacing: 5,
                                scaleFactor: 300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsGeometry.only(
                        bottom: 40,
                        top: 30,
                        left: 15,
                        right: 15,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => deleteRecording(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyle.textFieldColor
                                  .withValues(alpha: 0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                            ),
                            child: Icon(Icons.delete, color: Colors.redAccent),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () => {pauseRecording()},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyle.textFieldColor
                                  .withValues(alpha: 0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                            ),
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 150),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                              child: listening
                                  ? Icon(
                                      key: ValueKey(listening),
                                      Icons.pause,
                                      color: Colors.white70,
                                    )
                                  : Icon(
                                      key: ValueKey(listening),
                                      Icons.play_arrow,
                                      color: Colors.white70,
                                    ),
                            ),
                          ),

                          const SizedBox(width: 15), // Spazio tra i pulsanti
                          // Pulsante CONFERMA (Verde)
                          ElevatedButton(
                            onPressed: () => {stopRecording()},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyle.textFieldColor
                                  .withValues(alpha: 0.2),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.lightGreenAccent,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.lightGreenAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Hero(
                  tag: 'voiceButton',
                  child: GestureDetector(
                    key: ValueKey('voiceButton'),
                    onTap: startRecording,
                    child: Container(
                      padding: const EdgeInsets.all(60),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppStyle.textFieldColor),
                        gradient: LinearGradient(
                          colors: [Colors.tealAccent, AppStyle.textFieldColor],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppStyle.accent.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic,
                        size: 56,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
