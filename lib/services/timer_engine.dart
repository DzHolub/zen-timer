import 'package:flutter/material.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:zen_tabata/data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class TimerEngine extends StatefulWidget {
  final VoidCallback? hideCallback;
  static ValueNotifier<bool> isHidden = ValueNotifier(false);
  static ValueNotifier<bool> isStopPressed = ValueNotifier(false);
  static ValueNotifier<String> currentStage = ValueNotifier(kStageList.first);
  static ValueNotifier<int> currentLoop = ValueNotifier(0);

  TimerEngine({this.hideCallback});

  @override
  TimerEngineState createState() => TimerEngineState();
}

class TimerEngineState extends State<TimerEngine> {
  static AudioCache player = AudioCache(fixedPlayer: AudioPlayer());

  bool _isElevated = true;

  String _currentStage = '';
  int _maxTime = 0;
  int _currentLoop = 0;
  int _countdown = 0;
  int _preheatTime = 0;
  int _exerciseTime = 0;
  int _restTime = 0;
  int _loopQty = 0;

  String _exerciseSound = '';
  String _restSound = '';
  String _loopEndSound = '';
  String _finishSound = '';
  String _currentSound = '';

  PausableTimer timer = PausableTimer(Duration(seconds: 1), () {});

  @override
  void initState() {
    super.initState();
    resetTimer();

    timer = PausableTimer(Duration(seconds: 1), () {
      setState(
        () {
          _countdown--;
          timer
            ..reset()
            ..start();
          if (_countdown <= 0) checkStage();
          checkSound();
          if (dataBox.get(kVibration)) checkVibration();
        },
      );
    });
  }

  void checkStage() {
    if (_currentStage == kStageList.first) {
      _currentLoop++;
      _currentStage = kStageList[1];
      _countdown = _exerciseTime;
    } else if (_currentStage == kStageList[1]) {
      if (_currentLoop == _loopQty) {
        _currentStage = kStageList.last;
        timer.reset();
        timer.pause();
      } else {
        _currentStage = kStageList[2];
        _countdown = _restTime;
      }
    } else if (_currentStage == kStageList[2]) {
      _currentLoop++;
      _currentStage = kStageList[1];
      _countdown = _exerciseTime;
    } else if (_currentStage == kStageList.last) {
      resetTimer();
    }
    if (TimerEngine.currentLoop.value != _currentLoop)
      TimerEngine.currentLoop.value = _currentLoop;
    TimerEngine.currentStage.value = _currentStage;
  }

  void resetTimer() {
    dataBox.put(kTimerIsActivated, false);
    _countdown = dataBox.get(kPreheatTime);
    _preheatTime = dataBox.get(kPreheatTime);
    _exerciseTime = dataBox.get(kExerciseTime);
    _restTime = dataBox.get(kRestTime);
    _loopQty = dataBox.get(kLoopQty);
    _exerciseSound = dataBox.get(kExerciseSound);
    _restSound = dataBox.get(kRestSound);
    _loopEndSound = dataBox.get(kLoopEndSound);
    _finishSound = dataBox.get(kFinishSound);
    _currentSound = _exerciseSound;
    _countdown = _preheatTime;
    timer.reset();
    timer.pause();
    _currentStage = kStageList.first;
    _currentLoop = 0;
    _maxTime =
        _preheatTime + (_exerciseTime + _restTime) * _loopQty - _restTime;
    _isElevated = true;
    TimerEngine.isStopPressed.value = false;
    Wakelock.disable();
    print('reset');
  }

  dynamic checkVibration() {
    if (_countdown <= 3 && _countdown > 0) {
      if (_countdown == 1) {
        vibrateDevice(700);
      } else {
        vibrateDevice(300);
      }
    }
    if (_currentStage == kStageList.last) {
      vibrateDevice(1500);
    }
  }

  dynamic checkSound() {
    String _playingNow = _currentSound;
    if (_currentStage == kStageList[1])
      _currentSound = _exerciseSound;
    else
      _currentSound = _restSound;
    if (_loopEndSound != 'no sound') {
      if (_countdown <= 3 && _countdown > 0) {
        _currentSound = _loopEndSound;
      }
    }
    if (_currentStage == kStageList.last) {
      _currentSound = _finishSound;
    }

    if (_playingNow != _currentSound) {
      if (_currentSound == 'no sound')
        player.fixedPlayer!.pause();
      else if (_currentStage == kStageList.last)
        player.play(_currentSound);
      else
        player.loop(_currentSound);
    }
  }

  Widget changeTimerIcon() {
    IconData _activeIcon = Icons.play_arrow_rounded;

    if (_currentLoop != 0) _activeIcon = Icons.pause_rounded;
    if (_currentLoop == _loopQty && _countdown <= 0) _activeIcon = Icons.replay;
    return Icon(_activeIcon, size: 300);
  }

  void vibrateDevice(int duration) async {
    if (await Vibration.hasVibrator() ?? false)
      Vibration.vibrate(duration: duration);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: TimerEngine.isStopPressed,
        builder: (context, bool isStopPressed, buildWidget) {
          if (isStopPressed) resetTimer();

          return ValueListenableBuilder(
              valueListenable: TimerEngine.isHidden,
              builder: (context, bool isHidden, buildWidget) {
                return Column(
                  children: [
                    RawMaterialButton(
                      shape: CircleBorder(), // raw material button
                      onPressed: () {
                        if (!isHidden) {
                          widget.hideCallback!();

                          if (!dataBox.get(kTimerIsActivated) && _isElevated)
                            dataBox.put(kTimerIsActivated, true);

                          _isElevated = !_isElevated;

                          if (_currentLoop == _loopQty && _countdown <= 0)
                            resetTimer();

                          if (dataBox.get(kTimerIsActivated)) {
                            if (timer.isPaused) {
                              timer.start();
                              Wakelock.enable();
                            } else {
                              timer.pause();
                              Wakelock.disable();
                            }

                            if (player.fixedPlayer!.state ==
                                PlayerState.PLAYING)
                              player.fixedPlayer!.pause();
                            else {
                              player.fixedPlayer!.resume();
                              //TODO: fix end sound after pressed restart button
                              print('resume sound');
                            }
                          }

                          setState(() {});
                        }
                      },
                      child: AnimatedContainer(
                        duration: kAnimDuration,
                        height: 320,
                        width: 320,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            boxShadow:
                                _isElevated && !isHidden ? neuShadow : null),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 100),
                              opacity: isHidden ? 0.3 : 1,
                              child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    AnimatedOpacity(
                                        duration: kAnimDuration,
                                        opacity: timer.isPaused ? 1 : 0,
                                        child: changeTimerIcon()),
                                    AnimatedOpacity(
                                      duration: kAnimDuration,
                                      opacity: dataBox.get(kTimerIsActivated)
                                          ? timer.isPaused
                                              ? 0.3
                                              : 1
                                          : 0,
                                      child: Text(
                                        '$_countdown',
                                        style: TextStyle(fontSize: 250),
                                      ),
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                );
              });
        });
  }
}

// TODO: SOUNDS LONGER THAN ONE SECOND - SOUND ENGINE PLAYS CONTINUOUSLY
