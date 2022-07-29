import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zen_tabata/data.dart';
import 'package:zen_tabata/components/theme.dart';
import 'package:zen_tabata/screens/screen_timer.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  await Hive.openBox(kData);
  //Hive.box(kData).clear();
  await initAssets();
  initValues();
  //delete this later
  for (dynamic x in Hive.box(kData).keys) {
    print(x.toString() + ": ${Hive.box(kData).get(x)}");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dataBox.listenable(),
      builder: (context, Box box, widget) {
        var _darkTheme = box.get(kDarkMode);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightThemeData,
            darkTheme: darkThemeData,
            themeMode: _darkTheme ? ThemeMode.dark : ThemeMode.light,
            home: TimerScreen());
      },
    );
  }
}

//TODO: box.put(kGlobalSoundIsOn, value) global sound bool, finish sound
