import 'package:flutter/material.dart';
import 'list_content.dart';
import 'package:bentsuyo_app/tools/tool.dart';

import 'add.dart';

class FormulaListRoot extends StatelessWidget{
  final Widget _appbar = AppBar(title: Text("公式リスト"),);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar,
      drawer: Tools.drawer(context),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(),
                Expanded(
                  child: FormulasList(),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Text(
          "+",
          style: TextStyle(fontSize: 30),
        ),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new FormulaAdd()
              )
          );
        },
      ),
    );
  }
}

