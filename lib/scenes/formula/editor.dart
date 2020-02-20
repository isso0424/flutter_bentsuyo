import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/types.dart';
import 'package:bentsuyo_app/tools/data.dart';

class FormulaEditorFrame extends StatelessWidget{
  final Formula formula;
  FormulaEditorFrame({this.formula});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("公式の編集"),),
      drawer: Tools.drawer(context),
      body: ListView(
        children: <Widget>[
          FormulaEditor(formula: formula,)
        ],
      ),
    );
  }
}

class FormulaEditor extends StatefulWidget {
  final Formula formula;
  FormulaEditor({this.formula});
  @override
  FormulaEditorState createState() => FormulaEditorState(formula: formula);

}

class FormulaEditorState extends State<FormulaEditor> {
  final Formula formula;
  FormulaEditorState({this.formula});
  toLeft(widget) => Tools.toLeft(widget);
  final TextEditingController formulaController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController subjectController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        toLeft(Text("公式の編集")),
        toLeft(Divider()),
        toLeft(
            SizedBox(
              child:
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "公式の名前",
                  hintText: "変更後の公式の名前を入力してください",
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
          child: Text("編集"),
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          onPressed: () {
            print("hey");
            if (formulaController.text == "" || subjectController.text == "" || nameController.text == "") return;
            print("hi");
            HoldData.deleteFormula();
            HoldData.addNewFormula(formulaController.text, nameController.text, subjectController.text);
            Navigator.pushReplacementNamed(context, "/f");
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    formulaController.text = formula.formula;
    subjectController.text = formula.subject;
    nameController.text = formula.name;
  }
}

