import 'package:flutter/material.dart';
import '../tools/tool.dart';
import 'words/root.dart';
import 'package:flutter/services.dart';
import 'package:bentsuyo_app/scenes/Formula.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Title(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        "/w": (BuildContext context) => new WordsListRoot(),
        "/f": (BuildContext context) => new FormulaListRoot()
      },
    );
  }
}

class Title extends StatelessWidget {
  Widget buttonText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "べんつよアプリ(仮)",
              style: TextStyle(fontSize: 45),
            ),
            Container(
              child: RaisedButton(
                child: buttonText("単語帳"),
                shape: UnderlineInputBorder(),
                onPressed: () {
                  Navigator.of(context).pushNamed("/w");
                },
              ),
              width: 300.0,
              height: 100,
            ),
            SpaceBox.height(20),
            Container(
              child: RaisedButton(
                child: buttonText("公式まとめ"),
                shape: UnderlineInputBorder(),
                onPressed: () {
                  Navigator.of(context).pushNamed("/f");
                },
              ),
              width: 300.0,
              height: 100,
            ),
            SpaceBox.height(20),
            Container(
              child: RaisedButton(
                child: buttonText("共有"),
                shape: UnderlineInputBorder(),
                onPressed: () {},
              ),
              width: 300.0,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
