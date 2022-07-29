import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

const kData = 'data';
const kDarkMode = 'darkMode';
const kVibration = 'vibration';

const kExerciseTime = 'exerciseTime';
const kRestTime = 'restTime';
const kLoopQty = 'loopQty';
const kPreheatTime = 'preheatTime';
const kTimerIsActivated = 'timerIsStarted';
const kOtherOptions = 'otherOptions';

const kStageList = <String>['BE READY', 'EXERCISE', 'REST', 'FINISHED'];

const kGlobalSoundIsOn = 'globalSoundIsOn';
const kExerciseSound = 'exerciseSound';
const kRestSound = 'restSound';
const kLoopEndSound = 'loopEndSound';
const kLoopEndSoundIsOn = 'loopEndSoundIsOn';
const kFinishSound = 'finishSound';

List<String> audioData = [];
List<String> exerciseRestSounds = ['no sound'];
List<String> loopEndSounds = ['no sound'];
List<String> finishSounds = ['no sound'];

const Duration kAnimDuration = Duration(milliseconds: 200);
const TextStyle kTimerTextSize = TextStyle(fontSize: 45);

final Box dataBox = Hive.box(kData);

final List<BoxShadow> neuShadow = [
  BoxShadow(
      color: Colors.grey[500]!,
      offset: const Offset(4, 4),
      blurRadius: 15,
      spreadRadius: 1),
  BoxShadow(
      color: Colors.white,
      offset: const Offset(-4, -4),
      blurRadius: 15,
      spreadRadius: 1)
];

dynamic initValues() {
  //initialize default values at the first start
  if (dataBox.isEmpty) {
    print('adding default variables');
    dataBox
      ..put(kDarkMode, false)
      ..put(kVibration, true)
      ..put(kPreheatTime, 3)
      ..put(kExerciseTime, 20)
      ..put(kRestTime, 10)
      ..put(kLoopQty, 8)
      ..put(kGlobalSoundIsOn, true)
      ..put(kExerciseSound, exerciseRestSounds[0])
      ..put(kRestSound, exerciseRestSounds[0])
      ..put(kLoopEndSound, loopEndSounds[0])
      ..put(kLoopEndSoundIsOn, true)
      ..put(kFinishSound, finishSounds[0])
      ..put(kTimerIsActivated, false);
  }
  //dataBox.put(kTimerIsActivated, false);
}

Future initAssets() async {
  final dataContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> dataMap = json.decode(dataContent);
  List<String> audioData =
      dataMap.keys.where((String key) => key.contains('snd_')).toList();
  audioData.forEach((element) {
    audioData[audioData.indexOf(element)] = element.toString().substring(7);
  });

  exerciseRestSounds.addAll(audioData
      .where((String element) => element.contains('snd_exercise_'))
      .toList());
  loopEndSounds.addAll(audioData
      .where((String element) => element.contains('snd_loop_end_'))
      .toList());
  finishSounds.addAll(audioData
      .where((String element) => element.contains('snd_finish_'))
      .toList());
  print(exerciseRestSounds[0]);
}

// TODO: DISPOSE OF GLOBAL SOUND AND END ROUND SOUND BOOLEANS
