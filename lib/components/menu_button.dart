import 'package:flutter/material.dart';
import 'package:zen_tabata/data.dart';
import 'package:zen_tabata/screens/screen_timer.dart';
import 'package:zen_tabata/services/timer_engine.dart';

class MenuButton extends StatefulWidget {
  static ValueNotifier<bool> isHidden = ValueNotifier(false);

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _inMenu = false;
  bool _buttonIsDown = false;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: MenuButton.isHidden,
        builder: (context, bool isHidden, widget) {
          return AnimatedContainer(
            height: 80,
            width: 80,
            duration: kAnimDuration,
            onEnd: () {
              if (!isHidden) {
                if (!_buttonIsDown) TimerScreen.inSettings.value = _inMenu;
                setState(() {
                  _buttonIsDown = false;
                });
              }
            },
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
              boxShadow: _buttonIsDown || isHidden ? null : neuShadow,
            ),
            child: IconButton(
                onPressed: () {
                  if (!isHidden) {
                    setState(() {
                      _buttonIsDown = true;
                      TimerEngine.isStopPressed.value = true;
                      if (!dataBox.get(kTimerIsActivated)) {
                        _inMenu = !_inMenu;
                        _inMenu ? _controller.forward() : _controller.reverse();
                        if (_inMenu) TimerEngine.isHidden.value = true;
                      } else {
                        dataBox.put(kTimerIsActivated, false);
                      }
                    });
                  }
                },
                icon: AnimatedOpacity(
                  duration: kAnimDuration,
                  opacity: isHidden ? 0 : 1,
                  child: !dataBox.get(kTimerIsActivated)
                      ? AnimatedIcon(
                          size: 40.0,
                          icon: AnimatedIcons.menu_close,
                          progress: _controller)
                      : Icon(Icons.square_rounded, size: 35.0),
                )),
          );
        });
  }
}
