import 'package:flutter/material.dart';

import 'package:bentsuyo_app/tools/tool.dart';
import 'package:bentsuyo_app/tools/data.dart';

import 'detail_parts.dart';

// ignore: must_be_immutable
class DetailViewRoot extends StatelessWidget {
  toLeft(widget) => Tools.toLeft(widget);
  getWidth(context) => Tools.getWidth(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Tools.drawer(context),
      body: Scaffold(
        body: Padding(
          child: Column(
            children: <Widget>[
              // タイトル
              toLeft(WordsDetailTitle()),
              Divider(),

              // 意味
              toLeft(Text("意味")),
              SizedBox(
                child: Card(
                    child: Flex(
                      children: <Widget>[
                        Flexible(
                            child: WordsDetailMean()
                        ),
                      ],
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.start,
                    )
                ),
                width: getWidth(context) * 0.9,
                height: 200,
              ),

              // 詳細データ(正答率など)
              toLeft(Text("詳細")),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    child: Card(
                        child: WordsDetailDetail()
                    ),
                  )
              ),

              // 単語削除ボタン
              _wordRemoveButton(context)
            ],
          ),
          padding: EdgeInsets.all(20.0),
        ),
      ),
    );
  }

  Widget _wordRemoveButton(BuildContext context){
    return RaisedButton(
      child: Text("単語の削除"),
      color: Colors.red,
      shape: StadiumBorder(),
      onPressed: () {
        HoldData.removeWord();
        Navigator.pop(context);
      },
    );
  }
}