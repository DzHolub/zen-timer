import 'package:flutter/material.dart';
import 'package:zen_tabata/data.dart';
import 'package:audioplayers/audioplayers.dart';
import '../screens/screen_timer.dart';
import 'package:zen_tabata/components/button_number_picker.dart';
import 'package:vibration/vibration.dart';

class SettingsCard extends StatefulWidget {
  final String? text;
  final double? fontSize;
  final String? name;
  final String? value;
  final void Function()? onPressed;
  final String? activeCard;
  final List<Widget>? menuItems;
  final double activatedHeight;

  SettingsCard({
    @required this.value,
    @required this.text,
    @required this.name,
    @required this.onPressed,
    @required this.menuItems,
    this.activeCard,
    this.activatedHeight = 170,
    this.fontSize = 30.0,
  });

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  bool _isActivated = false;
  bool _showOptions = false;

  @override
  Widget build(BuildContext context) {
    widget.activeCard == widget.name
        ? _isActivated = true
        : _isActivated = false;

    return ValueListenableBuilder(
        valueListenable: TimerScreen.inSettings,
        builder: (context, bool isInSettings, widgetBuild) {
          //Disable clicks on card if not in settings
          return IgnorePointer(
            ignoring: !isInSettings,
            child: GestureDetector(
              onTap: widget.onPressed!,
              child: AnimatedContainer(
                onEnd: () {
                  setState(() {
                    if (_isActivated) {
                      _showOptions = true;
                    } else
                      _showOptions = false;
                  });
                },
                duration: kAnimDuration,
                width: 360,
                height: _isActivated ? widget.activatedHeight : 68,
                padding: EdgeInsets.all(14),
                margin: EdgeInsets.all(7),
                alignment: AlignmentDirectional.topStart,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: isInSettings ? neuShadow : null,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.text!,
                            style: TextStyle(fontSize: widget.fontSize)),
                        Text(widget.value!,
                            style: TextStyle(fontSize: widget.fontSize)),
                      ],
                    ),
                    if (_showOptions && _isActivated)
                      Column(
                        children: widget.menuItems!,
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class MenuItem extends StatelessWidget {
  final String? text;
  final int minValue;
  final int? maxValue;
  final dynamic value;
  final bool isSound;
  final List soundLibrary;

  MenuItem(
      {@required this.text,
      @required this.value,
      @required this.maxValue,
      this.minValue = 1,
      this.isSound = false,
      this.soundLibrary = const []});

  void setValue(dynamic val, bool isSound) {
    int _soundVal = val;
    if (isSound) val = soundLibrary[val];
    dataBox.put(value, val);
    if (isSound && _soundVal > 0) _player.play(val);
  }

  static AudioCache _player =
      AudioCache(fixedPlayer: AudioPlayer()); //??????????????????????

  @override
  Widget build(BuildContext context) {
    dynamic _value = dataBox.get(value);
    if (isSound) _value = soundLibrary.indexOf(_value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(text!, style: TextStyle(fontSize: 30.0)),
          ],
        ),
        Row(
          children: [
            ButtonNumberPicker(
              minValue: _value == minValue,
              maxValue: _value == maxValue,
              onTapLeft: () {
                if (_value > minValue) _value--;
                setValue(_value, isSound);
              }, //onPressedLeft,
              onTapRight: () {
                if (_value < maxValue) _value++;
                setValue(_value, isSound);
              },
              value: '${_value <= 0 ? 'OFF' : _value}',
            ),
            SizedBox(width: 10, height: 50)
          ],
        ),
      ],
    );
  }
}

class MenuItemSwitcher extends StatelessWidget {
  final String? text;
  final dynamic value;
  final bool isVibration;

  MenuItemSwitcher({
    @required this.text,
    @required this.value,
    this.isVibration = false,
  });

  void setValue(bool val) {
    dataBox.put(value, val);
    if (isVibration && val) vibrateDevice();
  }

  void vibrateDevice() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500);
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic _value = dataBox.get(value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(text!, style: TextStyle(fontSize: 30.0)),
          ],
        ),
        Row(
          children: [
            ButtonNumberPicker(
              minValue: !_value,
              maxValue: _value,
              onTapLeft: () {
                if (_value) _value = false;
                setValue(_value);
              }, //onPressedLeft,
              onTapRight: () {
                if (!_value) _value = true;
                setValue(_value);
              },
              value: '${_value ? 'ON' : 'OFF'}',
            ),
            SizedBox(width: 10, height: 50)
          ],
        ),
      ],
    );
  }
}
