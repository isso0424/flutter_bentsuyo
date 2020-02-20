import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/data.dart';

class FormulaAdd extends StatefulWidget {
  @override
  _FormulaAddState createState() => _FormulaAddState();
}

class _FormulaAddState extends State<FormulaAdd>{
  toLeft(widget) => Tools.toLeft(widget);
  final TextEditingController formulaController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController subjectController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: Tools.drawer(context),
        body: ListView(children:[
          Column(
            children: <Widget>[
              toLeft(Text("公式の追加")),
              toLeft(Divider()),
              toLeft(
                  SizedBox(
                    child:
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "公式の名前",
                        hintText: "追加する公式の名前を入力してください",
                      ),
                    ),
                    height: 100,
                    width: Tools.getWidth(context) * 0.9,
                  )
              ),
              Divider(),
              toLeft(
                  SizedBox(
                    child:
                    TextField(
                      controller: formulaController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "公式",
                        hintText: "追加する公式を入力してください",
                      ),
                    ),
                    height: 100,
                    width: Tools.getWidth(context) * 0.9,
                  )
              ),
              Divider(),
              toLeft(
                  SizedBox(
                    child:
                    TextField(
                      controller: subjectController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "教科",
                        hintText: "追加する公式の教科を入力してください",
                      ),
                    ),
                    height: 100,
                    width: Tools.getWidth(context) * 0.9,
                  )
              ),
              RaisedButton(
                child: Text("追加"),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  if (formulaController.text == "" || subjectController.text == "" || nameController.text == "") return;
                  HoldData.addNewFormula(formulaController.text, nameController.text, subjectController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          ),])
    );
  }
}

