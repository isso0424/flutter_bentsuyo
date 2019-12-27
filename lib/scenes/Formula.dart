import 'package:bentsuyo_app/tools/types.dart';
import 'package:flutter/material.dart';
import 'package:bentsuyo_app/tools/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bentsuyo_app/tools/tool.dart';

class FormulaListRoot extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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

class FormulasListList extends StatefulWidget{
  @override
  _FormulasListListState createState() => _FormulasListListState();
}

class _FormulasListListState extends State<FormulasListList>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
    SharedPreferences pref = await SharedPreferences.getInstance();
    var j = pref.getString("formulas");
    if (j == null)HoldData.formulasList = [];
    else {
      var jsonArray = json.decode(j);
      print(jsonArray);
      /*
    var a = [[
      {"title":"単語帳",
        "tag": "たぐ",
        "words":[
          {"word":"たんご", "mean": "意味", "missCount":0,"correct":0,"memorized":0},
        ]
      },
    ];*/
      HoldData.formulasList =
          jsonArray.map((i) => new Formula.fromJson(i)).toList();
      print("ou");
    }
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
                      builder: (BuildContext context) => FormulaDetailView()));
            },
          );
        });
  }

}

class FormulasListAdd extends StatefulWidget {
  @override
  _FormulasListAddState createState() => _FormulasListAddState();
}

class _FormulasListAddState extends State<FormulasListAdd>{
  toLeft(widget) => Tools.toLeft(widget);
  final TextEditingController formulaController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController subjectController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
            child: Text("Button"),
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            onPressed: () {
              print("hey");
              if (formulaController.text == "" || subjectController.text == "" || nameController.text == "") return;
              print("hi");
              HoldData.addNewFormula(formulaController.text, nameController.text, subjectController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class FormulaDetailView extends StatefulWidget{
  @override
  _FormulaDetailViewState createState() => _FormulaDetailViewState();

}

class _FormulaDetailViewState extends State<FormulaDetailView> {
  Formula formula;
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
            child: Text("Button"),
            color: Colors.red,
            shape: StadiumBorder(),
            onPressed: () {
              HoldData.deleteFormula();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    formula = HoldData.formula;
  }
}
