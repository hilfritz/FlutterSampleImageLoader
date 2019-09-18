
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:imageloader_sample/components/SessionComponent.dart';
import 'package:imageloader_sample/utils/DisplayElemants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spring_button/spring_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'MainPresenter.dart';

void main() {
  //INITIALIZE SINGLETON SESSION
  SessionComponent sessionComponent = new SessionComponent();
  sessionComponent.init().then((x){

    runApp(MyApp(sessionComponent));
  });
}

class MyApp extends StatelessWidget {
  SessionComponent sessionComponent;
  MainPresenter mainPresenter;
  MyApp(this.sessionComponent);

  @override
  Widget build(BuildContext context) {
    this.mainPresenter = this.sessionComponent.presenterComponent.mainPresenter;

    return MaterialApp(
      title: 'Amazing Photos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage('Amazing Photos', this.mainPresenter),
    );
  }
}

class MyHomePage extends StatefulWidget  {
  final MainPresenter mainPresenter;
  final String title;
  MyHomePage(this.title, this.mainPresenter);

  @override
  _MyHomePageState createState() {

    return _MyHomePageState(this.mainPresenter);
  }
}

class _MyHomePageState extends State<MyHomePage> implements MainView {
  @override
  bool enableBack = false;
  bool permissionGranted = false;
  @override
  List<Uint8List> images = new List<Uint8List>();
  final MainPresenter mainPresenter;
  bool isTapped = false;
  _MyHomePageState(this.mainPresenter);

  @override
  void initState() {
    super.initState();
    this.mainPresenter.initView(this);
  }

  Widget freeSpace = Container(padding: EdgeInsets.all(10),);
  Widget freeSpageSmall = Container(padding: EdgeInsets.all(5),);

  void askPermissions() async{
    //Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission==PermissionStatus.granted){
      setState(() {
        permissionGranted = true;
      });      
    }
  }

  Future<bool> getEnabledBack(){
    var completer = new Completer();

    // At some time you need to complete the future:
    completer.complete(enableBack);
    //Future<String>.value("");
    Future<bool>.value(enableBack);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    DisplayElements.init(context);
    //ASK THE CORRECT PERMISSIONS FIRST
    askPermissions();
    return new WillPopScope(
      onWillPop: () async{
        this.mainPresenter.onBackButtonTap();
        return new Future<bool>.value(enableBack);
      } ,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: getBody(),
        // This trailing comma makes auto-formatting nicer for build methods.
      )
    );

  }

  Widget requestPermissionBody(){
    Widget requestButton = MaterialButton(
      onPressed: (){
        return askPermissions();
      },
      highlightColor: Colors.white,
      color: Colors.white,
      textColor: Colors.blue,
      padding: EdgeInsets.all( 15),
      textTheme: ButtonTextTheme.accent,
      child: Text('Allow Storage Permission', style: TextStyle(fontSize: 20.0),),
      shape: StadiumBorder(

      ),

    );
    Widget body =  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "This app needs Storage permission to download data.",
            style: TextStyle(fontWeight: FontWeight.w400,
                fontSize: 20,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          freeSpace,
          freeSpace,
          requestButton,
        ]);
    return Container(
      padding: EdgeInsets.all( 25),
      child: body,
    );
  }


  
  Widget getInstructionsWidget(){  
    return Container(
        color: Colors.black,
        padding: EdgeInsets.all(30),
        child:
          Center(          
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                isTapped==true?SpinKitWave(
                                color: Colors.lightBlueAccent,
                                size: 50.0,
                              ):Container(),
                isTapped==true?freeSpace:Container(),
                //"Alright!, \nNow loading..."
                isTapped==true?Center(
                        child:
                        new InstructionTextWidget("Now loading..", true),
                      ):Container(),
                isTapped==false?SpringButton(
                  SpringButtonType.OnlyScale,
                  new InstructionTextWidget("Tap & Hold", false),
                  onLongPress: () {
                    setState(() {
                      print("tap:");
                      isTapped = !isTapped;                      
                      this.mainPresenter.populate();                      
                    });                   
                  },
                ):Container(),                
              ],
            ),
          )
    );
  }

  Widget getBody() {
    if (this.images.length==0){
      return getInstructionsWidget();
    }
    return GestureDetector(
           onLongPress: () {
            this.mainPresenter.onTap();
          },
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      freeSpageSmall,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            'Tap & hold again',
                            style: TextStyle(fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: Colors.lightBlueAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // freeSpageSmall,
                          //  (this.loadingVisibility==true?SpinKitFadingCircle(
                          //   color: Colors.lightBlueAccent,
                          //   size: 15.0,
                          // ):Container())
                        ],
                      )
                      ,
                      freeSpageSmall,
                  Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: getImageGrid())
                      //child: getGridView(isPortrait)),
                ]))),
    );
  }

  Widget getImageGrid() {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget orientationBuilder = new OrientationBuilder(
      builder: (context, orientation) {
        return GridView.count(
          crossAxisCount: orientation == Orientation.portrait ?  2: 3,
          children: createGridListItems(isPortrait)
        );
      },
    );
    double w = width;
    double h = height;
    return SizedBox(
      child: orientationBuilder,
      width: w ,
      height: h ,
    );
  }

  Widget _getGridviewItems(int index, bool isPortrait, Uint8List file){        
    return Container(
        padding: EdgeInsets.all(isPortrait==true?10:0),
        child: Stack(
          children: <Widget>[
            Center(child: SpinKitThreeBounce(
                                color: Colors.lightBlueAccent,
                                size: 15.0,)),
            Center(                
                child:                 
                Image.memory(              
                  file, fit: BoxFit.cover, width: 200, height: 200,
                  )                
            ),
          ],
        )
    );
  }

  List<Widget> createGridListItems(bool isPortrait) {
    int length = this.images.length;
    print("createGridListItems: length:$length");
    List<Widget> list = List<Widget>();
    for (int x = 0; x < length; x++){
      list.add(_getGridviewItems(x,isPortrait, this.images[x]));
    }
    list.add(Container());
    list.add(Container());
    list.add(Container());
    return list;
  }
  @override
  bool isLoadingAnimationHidden;

  @override
  void showErrorPopup(String str) {
    //Alert(context: context, title: "Info", desc: str).show();
  }

  @override
  void addImageToDisplay(Uint8List files) {
    setState(() {
      this.images.add(files);
    });
  }

  @override
  void dispose() {
    super.dispose();
    this.mainPresenter.destroy();
  }

  @override
  void  clearImages() {
    setState(() {
      images= new List<Uint8List>();
    });    
  }

  @override
  void showToast(String str) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  void closePage({int delay = 0}) {
    Future.delayed(const Duration(milliseconds: 500), () {
      //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      Navigator.pop(context, true);
    });
  }
}

class InstructionTextWidget extends StatelessWidget {
  String text = "";
  bool repeatAnimation = false;
  InstructionTextWidget(this.text, this.repeatAnimation);
  @override
  Widget build(BuildContext context) {
    Widget retVal = Center(
          child:
            new FadeAnimatedTextKit(  
              isRepeatingAnimation: repeatAnimation,            
              textStyle: TextStyle(fontWeight: FontWeight.w400,
                fontSize: 25,
                color: Colors.lightBlueAccent,

              ),
              textAlign: TextAlign.center, text: [text],
            ) ,
        );
    return retVal;
  }
}
