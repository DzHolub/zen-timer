import 'package:flutter/material.dart';
import 'package:zen_tabata/data.dart';

class ButtonNumberPicker extends StatelessWidget {
  final void Function()? onTapLeft;
  final void Function()? onTapRight;
  final String? value;
  final bool minValue;
  final bool maxValue;

  ButtonNumberPicker({
    @required this.onTapLeft,
    @required this.onTapRight,
    @required this.value,
    this.minValue = false,
    this.maxValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: neuShadow),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
                onTap: onTapLeft,
                onLongPress: () {
                  print('long left');
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: minValue ? Colors.grey : Colors.black,
                )),
          ),
          Container(
              alignment: AlignmentDirectional.center,
              width: 50,
              child: Text('$value', style: TextStyle(fontSize: 30.0))),
          Expanded(
            child: GestureDetector(
                onTap: onTapRight,
                onLongPress: () {
                  //TODO: MAKE A LONG PRESS FAST ADD-DECREASE NUMBERS
                  print('long right');
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: maxValue ? Colors.grey : Colors.black,
                )),
          ),
        ],
      ),
    );
  }
}
