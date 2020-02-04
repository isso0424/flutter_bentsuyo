import 'package:flutter/material.dart';
import 'parts/formula_parts.dart';

class FormulaListRoot extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text("べんつよあぷり",
                  style: TextStyle(fontSize: 30, color: Colors.white)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text("たんごちょう"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed("/w");
              },
            ),
            ListTile(
              title: Text("こうしき"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed("/f");
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "公式リスト",
                  style: TextStyle(fontSize: 30),
                ),
                Divider(),
                Expanded(
                  child: FormulasListList(),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Text(
          "+",
          style: TextStyle(fontSize: 30),
        ),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new FormulasListAdd()));
        },
      ),
    );
  }
}
