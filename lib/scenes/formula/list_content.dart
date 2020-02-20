import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/data.dart';

import 'detail.dart';

class FormulasList extends StatefulWidget{
  @override
  _FormulasListState createState() => _FormulasListState();
}

class _FormulasListState extends State<FormulasList>{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData("FormulasList"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          return Text("Error!");
        } else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future getData(String key) async {
    HoldData.loadData("formulas");
    return ListView.builder(
        itemCount: HoldData.formulasList.length,
        itemBuilder: (context, int index) {
          return GestureDetector(
            child: Card(
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Text(
                      HoldData.formulasList[index].name,
                      style: TextStyle(fontSize: 30),
                    )
                  ]),
                  Row(children: <Widget>[
                    Text(
                      "式",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      HoldData.formulasList[index].formula,
                      style: TextStyle(fontSize: 10),
                    )
                  ])
                ],
              ),
            ),
            onTap: () {
              HoldData.loadFormula(index);
              Navigator.push(
                  context,
                  new MaterialPageRoute<Null>(
                      builder: (BuildContext context) => FormulaDetailFrame(formula: HoldData.formula)
                  )
              );
            },
          );
        });
  }
  @override
  void initState() {
    super.initState();
    HoldData.loadData("wordsListList");
  }
}

