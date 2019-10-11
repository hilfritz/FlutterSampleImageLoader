import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:imageloader_sample/pages/typewriter/typewriter_presenter.dart';

class TypeWriterPageStatefulWidget extends StatefulWidget  {
  final TypeWriterPresenter presenter;
  final String title;
  TypeWriterPageStatefulWidget(this.title, this.presenter);

  @override
  _TypeWriterPageStatefulWidget createState() {

    return _TypeWriterPageStatefulWidget(this.presenter);
  }
}

class _TypeWriterPageStatefulWidget extends State<TypeWriterPageStatefulWidget> implements TypeWriterView {

  final TypeWriterPresenter presenter;
  @override
  String inputText;
  TextEditingController textEditingController = new TextEditingController();

  _TypeWriterPageStatefulWidget(this.presenter);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            
            Expanded(
              flex: 5,
              child: Text(inputText)),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: textEditingController,
                    onChanged: (s){
                      //return presenter.onTextChanged(s);
                    },
                  ), Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          String temp = textEditingController.text+"";
                          textEditingController.text = "";
                          presenter.onTextChanged(temp);
                        },
                        child: Text(
                          "OK, ADD",
                        ),
                      ), 
                      FlatButton(
                        onPressed: () {    
                          presenter.clearText();          
                        },
                        child: Text(
                          "RESET",
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void closePage({int delay = 0}) {

  }

  @override
  void initBlocs() {

  }


}