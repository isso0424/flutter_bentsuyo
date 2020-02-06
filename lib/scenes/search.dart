import 'package:flutter/material.dart';
import 'package:bentsuyo_app/tools/tool.dart';

class SearchStateRoot extends StatelessWidget{
  static String inputKeyWord = "";
  toLeft(widget) => Tools.toLeft(widget);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      drawer: Tools.drawer(context),
      body: Column(
        children: <Widget>[
          toLeft(Text("検索")),
          Divider(),
          _SearchWidget()
        ],
      ),
    );
  }
}

class _SearchWidget extends StatefulWidget{
  @override
  _SearchWidgetState createState() => new _SearchWidgetState();
}

class _SearchWidgetState extends State<_SearchWidget>{
  toLeft(widget) => Tools.toLeft(widget);
  bool _searchWithTitle = true;
  final TextEditingController searchKeyWord = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            RadioListTile<bool>(
              title: const Text("タグ"),
              groupValue: _searchWithTitle,
              value: false,
              onChanged: (bool value){setState(() {_searchWithTitle = value;});},
            ),
            RadioListTile<bool>(
              title: const Text("タイトル"),
              groupValue: _searchWithTitle,
              value: true,
              onChanged: (bool value){setState(() {_searchWithTitle = value;});},
            )
          ],
        ),
        TextField(
          controller: searchKeyWord,
          decoration: InputDecoration(
            labelText: "${_searchWithTitle ? "タイトル" : "タグ"}",
            hintText: "検索",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
