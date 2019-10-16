import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:imageloader_sample/pages/main/MainPage.dart';
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
  @override
  PublishSubject<String> inputTextPublishSubject;
  var inputtedTextWidget;
  int counter=0;
  ScrollController _scrollController;

  _TypeWriterPageStatefulWidget(this.presenter);
  @override
  void initState() {
    this.presenter.initView(this);
    this.presenter.populate();
    super.initState();
  }


  void scrollToBottom(){
    var scrollPosition = _scrollController.position;
    print("scrollToBottom: scrollPosition.viewportDimension:"+scrollPosition.viewportDimension.toString()+" scrollPosition.maxScrollExtent:"+scrollPosition.maxScrollExtent.toString());
    //if (scrollPosition.viewportDimension < scrollPosition.maxScrollExtent) {
    _scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: new Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    //}
  }

  void hideKeyboard(BuildContext context){
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(title: Text("TypeWriter")),

        body: new GestureDetector(
          onTap: (){
            hideKeyboard(context);
          },
          child:
            Stack(
            children: <Widget>[
              Container(
                color: Colors.black,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: inputtedTextWidget==null?Container():inputtedTextWidget,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter text to add',
                                  contentPadding: const EdgeInsets.all(20.0)
                              ),
                              controller: textEditingController,
//                    onChanged: (s){
//                      return presenter.onTextChanged(s);
//                    },
                            ),
                          )
                          ,
                        )
                        , Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                String temp = textEditingController.text+"";
                                textEditingController.text = "";
                                presenter.onTextChanged(temp);
                              },
                              child: InstructionTextWidget("Add", false),
                            ),
                            FlatButton(
                              onPressed: () {
                                presenter.clearText();
                              },
                              child: InstructionTextWidget("Reset", false, color: Colors.grey),

                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
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
    _scrollController = new ScrollController(  initialScrollOffset: 0.0,
      keepScrollOffset: true);
    inputtedTextWidget = StreamBuilder <String>(
      stream: inputTextPublishSubject,
      initialData: "a\n b\n c \n d \n e \n f \n g \n h \n i \n j \n k",
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        print("initBlocs: counter:"+counter.toString());
        return Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Text(snapshot.data,
                style: new TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                )
            ),
          ),
        );
        //return Text(snapshot.data);
      },
    );


  }


}