import 'package:flutter/material.dart';
import 'package:zen_tabata/components/settings_card.dart';
import 'package:zen_tabata/data.dart';
import 'package:zen_tabata/screens/screen_timer.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsMenu extends StatefulWidget {
  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  String _activatedCard = "";
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: TimerScreen.inSettings,
        builder: (context, bool value, widget) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: value ? 1 : 0,
            child: ValueListenableBuilder(
                valueListenable: dataBox.listenable(),
                builder: (context, Box box, widget) {
                  return Column(
                    children: [
                      SizedBox(height: 10.0),
                      SettingsCard(
                        text: 'EXERCISE',
                        value: '${dataBox.get(kExerciseTime)} SEC',
                        name: kExerciseTime,
                        activeCard: _activatedCard,
                        menuItems: [
                          MenuItem(
                            text: "TIME:",
                            value: kExerciseTime,
                            maxValue: 200,
                          ),
                          MenuItem(
                            text: "SOUND:",
                            value: kExerciseSound,
                            isSound: true,
                            soundLibrary: exerciseRestSounds,
                            minValue: 0,
                            maxValue: exerciseRestSounds.length - 1,
                          )
                        ],
                        onPressed: () {
                          setState(() {
                            _activatedCard = kExerciseTime;
                          });
                        },
                      ),
                      SettingsCard(
                        text: 'REST',
                        name: kRestTime,
                        value: '${dataBox.get(kRestTime)} SEC',
                        activeCard: _activatedCard,
                        menuItems: [
                          MenuItem(
                            text: "TIME:",
                            value: kRestTime,
                            maxValue: 200,
                          ),
                          MenuItem(
                            text: "SOUND:",
                            value: kRestSound,
                            isSound: true,
                            soundLibrary: exerciseRestSounds,
                            minValue: 0,
                            maxValue: exerciseRestSounds.length - 1,
                          )
                        ],
                        onPressed: () {
                          setState(() {
                            _activatedCard = kRestTime;
                          });
                        },
                      ),
                      SettingsCard(
                        text: 'ROUNDS',
                        name: kLoopQty,
                        value: '${dataBox.get(kLoopQty)} SETS',
                        activeCard: _activatedCard,
                        activatedHeight: 220.0,
                        menuItems: [
                          MenuItem(
                            text: "QTY OF SETS:",
                            value: kLoopQty,
                            maxValue: 50,
                          ),
                          MenuItem(
                            text: "ROUND SOUND:",
                            value: kLoopEndSound,
                            isSound: true,
                            soundLibrary: loopEndSounds,
                            minValue: 0,
                            maxValue: loopEndSounds.length - 1,
                          ),
                          MenuItem(
                            text: "FINISH SOUND:",
                            value: kFinishSound,
                            isSound: true,
                            soundLibrary: finishSounds,
                            minValue: 0,
                            maxValue: finishSounds.length - 1,
                          )
                        ],
                        onPressed: () {
                          setState(() {
                            _activatedCard = kLoopQty;
                          });
                        },
                      ),
                      SettingsCard(
                        text: 'OTHER',
                        name: kOtherOptions,
                        value: '',
                        activeCard: _activatedCard,
                        activatedHeight: 180.0,
                        menuItems: [
                          MenuItemSwitcher(
                            text: "VIBRATION:",
                            value: kVibration,
                            isVibration: true,
                          ),
                        ],
                        onPressed: () {
                          setState(() {
                            _activatedCard = kOtherOptions;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }),
          );
        });
    // );
  }
}
