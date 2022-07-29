import 'package:flutter/material.dart';
import 'package:zen_tabata/data.dart';
import 'package:zen_tabata/services/timer_engine.dart';
import 'package:zen_tabata/screens/screen_settings.dart';
import 'package:zen_tabata/components/pop_up.dart';
import 'package:zen_tabata/components/menu_button.dart';

class TimerScreen extends StatelessWidget {
  static ValueNotifier<bool> inSettings = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: () => exitPopUp(context: context),
          child: ValueListenableBuilder(
              valueListenable: inSettings,
              builder: (context, bool isInSettings, widget) {
                TimerEngine.isHidden.value = isInSettings;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [MenuButton(), SizedBox(width: 20)],
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        TimerEngine(
                          hideCallback: () {
                            MenuButton.isHidden.value =
                                !MenuButton.isHidden.value;
                          },
                        ),
                        isInSettings ? SettingsMenu() : Container(),
                      ],
                    ),
                    AnimatedOpacity(
                      opacity: isInSettings ? 0 : 1,
                      duration: kAnimDuration,
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          TimerBottomInfo(),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class TimerBottomInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          duration: kAnimDuration,
          opacity: dataBox.get(kTimerIsActivated) ? 0 : 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WORK', style: kTimerTextSize),
                  Text('REST', style: kTimerTextSize),
                  Text('ROUNDS', style: kTimerTextSize)
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${dataBox.get(kExerciseTime)} SEC',
                      style: kTimerTextSize),
                  Text('${dataBox.get(kRestTime)} SEC', style: kTimerTextSize),
                  Text('${dataBox.get(kLoopQty)} SETS', style: kTimerTextSize),
                ],
              ),
            ],
          ),
        ),
        AnimatedOpacity(
          duration: Duration(milliseconds: 400),
          opacity: dataBox.get(kTimerIsActivated) ? 1 : 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                      valueListenable: TimerEngine.currentStage,
                      builder: (context, String currentStage, buildWidget) {
                        return Text(currentStage,
                            style: TextStyle(
                                fontSize: 70,
                                color: currentStage == kStageList[1]
                                    ? Colors.red[400]
                                    : Colors.lightBlue));
                      }),
                  ValueListenableBuilder(
                      valueListenable: TimerEngine.currentLoop,
                      builder: (context, int currentLoop, buildWidget) {
                        return Text('$currentLoop / ${dataBox.get(kLoopQty)}',
                            style: TextStyle(fontSize: 55));
                      }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
