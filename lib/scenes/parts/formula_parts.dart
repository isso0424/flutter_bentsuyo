import 'package:flutter/material.dart';
import 'package:bentsuyo_app/tools/data.dart';
import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/types.dart';

class FormulasListList extends StatefulWidget{
  @override
  _FormulasListListState createState() => _FormulasListListState();
}

class _FormulasListListState extends State<FormulasListList>{
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
                      builder: (BuildContext context) => FormulaDetailView()));
            },
          );
        });
  }
  @override
  void initState() {
    super.initState();
    HoldData.load(false);
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
                  print("hey");
                  if (formulaController.text == "" || subjectController.text == "" || nameController.text == "") return;
                  print("hi");
                  HoldData.addNewFormula(formulaController.text, nameController.text, subjectController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          ),])
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
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new FormulaEditBase(formula: formula,)));
            },
          )
        ],
      ),
      drawer: Tools.drawer(context),
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
            child: Text("削除"),
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

// ignore: must_be_immutable
class FormulaEditBase extends StatefulWidget {
  FormulaEditBase({this.formula});
  Formula formula;
  @override
  FormulaEditBaseState createState() => FormulaEditBaseState(formula: formula);

}

class FormulaEditBaseState extends State<FormulaEditBase> {
  FormulaEditBaseState({this.formula});
  toLeft(widget) => Tools.toLeft(widget);
  Formula formula;
  final TextEditingController formulaController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController subjectController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: Tools.drawer(context),
        body: ListView(children :[
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
          ),])
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

