import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/types.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/data.dart';

import 'editor.dart';

class FormulaDetailFrame extends StatelessWidget{
  final Formula formula;
  FormulaDetailFrame({this.formula});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new FormulaEditorFrame(formula: formula)
                  )
              );
            },
          )
        ],
      ),
      body: FormulaDetailContent(formula: formula),

    );
  }
}

class FormulaDetailContent extends StatefulWidget{
  final Formula formula;
  FormulaDetailContent({this.formula});
  @override
  _FormulaDetailContentState createState() => _FormulaDetailContentState(formula: formula);

}

class _FormulaDetailContentState extends State<FormulaDetailContent> {
  final Formula formula;
  _FormulaDetailContentState({this.formula});
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        toLeft(
            Text(
              formula.name,
              style: TextStyle(
                  fontSize: 40
              ),
            )
        ),
        Divider(),
        SizedBox(
          child: Card(
              child:Flex(
                children: <Widget>[Flexible(
                    child: Text(formula.formula,
                      style: TextStyle(fontSize: 25),)
                ),],
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,)
          ),
          width: Tools.getWidth(context) * 0.9,
          height: Tools.getHeight(context) * 0.5,
        ),
        Divider(),
        Text("教科: ${formula.subject}"),
        RaisedButton(
          child: Text("削除"),
          color: Colors.red,
          shape: StadiumBorder(),
          onPressed: () {
            HoldData.deleteFormula();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
