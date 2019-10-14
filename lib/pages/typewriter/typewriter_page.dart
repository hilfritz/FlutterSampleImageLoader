import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:imageloader_sample/pages/typewriter/typewriter_presenter.dart';
import 'package:rxdart/rxdart.dart';

class TypeWriterPage extends StatefulWidget  {
  final TypeWriterPresenter presenter;
  final String title;
  TypeWriterPage(this.title, this.presenter);

  @override
  _TypeWriterPageStatefulWidget createState() {

    return _TypeWriterPageStatefulWidget(this.presenter);
  }
}

class _TypeWriterPageStatefulWidget extends State<TypeWriterPage> implements TypeWriterView {

  final TypeWriterPresenter presenter;
  TextEditingController textEditingController = new TextEditingController();
  TextEditingController displayTextController = new TextEditingController();

  @override
  PublishSubject<String> inputTextPublishSubject;

  var inputtedTextWidget;

  int counter=0;

  _TypeWriterPageStatefulWidget(this.presenter);
  @override
  void initState() {
    this.presenter?.initView(this);
    this.presenter?.populate();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(title: Text("Type Writer")),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            Expanded(
              flex: 3,
              child: inputtedTextWidget==null?Container():inputtedTextWidget),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter text to add'
                    ),
                    controller: textEditingController,
//                    onChanged: (s){
//                      return presenter.onTextChanged(s);
//                    },
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
                          "ADD",
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
    print("initBlocs: ");
    inputtedTextWidget = StreamBuilder <String>(
      stream: inputTextPublishSubject,
      initialData: "Empty! please Add first. ["+counter.toString()+"]",
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        print("initBlocs: counter:"+counter.toString());
        return Text(snapshot.data);
      },
    );
  }


}