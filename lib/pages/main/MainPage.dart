
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:imageloader_sample/components/SessionComponent.dart';
import 'package:imageloader_sample/managers/Router.dart';
import 'package:imageloader_sample/pages/typewriter/typewriter_page.dart';
import 'package:imageloader_sample/utils/DisplayElemants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/src/subjects/publish_subject.dart';
import 'package:spring_button/spring_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'MainPresenter.dart';

class MainPage extends StatelessWidget {

  MainPresenter mainPresenter;
  Router router;
  MainPage(this.mainPresenter, this.router);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Amazing Photos',
      navigatorKey: this.router.getPageRouterKey(),
      initialRoute: ROUTE_NAMES.MAIN,
      onGenerateRoute: (RouteSettings routeSettings){
        return router.generateRoute(routeSettings);
      } ,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePageStatefulWidget(this.mainPresenter, this.router),
    );
  }
}

class HomePageStatefulWidget extends StatefulWidget  {
  final MainPresenter mainPresenter;
  final Router router;
  HomePageStatefulWidget( this.mainPresenter, this.router);

  @override
  _MainPageStatefulWidgetState createState() {

    return _MainPageStatefulWidgetState(this.mainPresenter, this.router);
  }
}

class _MainPageStatefulWidgetState extends State<HomePageStatefulWidget> implements MainView {
  @override
  bool goBack = false;
  bool permissionGranted = false;
  List<Uint8List> images = new List<Uint8List>();
  //PublishSubject<List<Uint8List>> imagePublishsubjectStream;
  PublishSubject<Uint8List> imagePublishsubjectStream;
  final MainPresenter mainPresenter;
  final Router router;
  _MainPageStatefulWidgetState(this.mainPresenter, this.router);
  List<Choice> choices = new List<Choice>();
  Widget noneWidget, tapWidget, loadingWidget, listWidget;
  PAGE_STATE pageState;
  @override
  void initState() {

    super.initState();
    this.mainPresenter.initView(this);
    choices.add(new Choice(title:"Typewriter"));
    choices.add(new Choice(title:"About"));
  }

  Widget freeSpace = Container(padding: EdgeInsets.all(10),);
  Widget freeSpageSmall = Container(padding: EdgeInsets.all(5),);

  void askPermissions() async{
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    //WRITE_EXTERNAL_STORAGE
    if (permission==PermissionStatus.granted){
      setState(() {
        permissionGranted = true;
      });      
    }
  }

  @override
  Widget build(BuildContext context) {
    DisplayElements.init(context);
    //ASK THE CORRECT PERMISSIONS FIRST
    askPermissions();
    return new WillPopScope(
      onWillPop: (){
        this.mainPresenter.onBackButtonTap();
        return new Future<bool>.value(goBack);
      } ,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBodyByState(),
        // This trailing comma makes auto-formatting nicer for build methods.
      )
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        centerTitle: true,
        title: Text("Amazing Photos"),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: (Choice choice){
              if (choice.title==choices[0].title){
                this.widget.mainPresenter.router.openTypeWriterPage();
              }else if (choice.title==choices[1].title){

              }
            },
            itemBuilder: (BuildContext context) {
              return choices.skip(0).map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],

      );
  }

//  Widget _buildRequestPermissionWidget(){
//    Widget requestButton = MaterialButton(
//      onPressed: (){
//        return askPermissions();
//      },
//      highlightColor: Colors.white,
//      color: Colors.white,
//      textColor: Colors.blue,
//      padding: EdgeInsets.all( 15),
//      textTheme: ButtonTextTheme.accent,
//      child: Text('Allow Storage Permission', style: TextStyle(fontSize: 20.0),),
//      shape: StadiumBorder(
//
//      ),
//
//    );
//    Widget body =  Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          new Text(
//            "This app needs Storage permission to download data.",
//            style: TextStyle(fontWeight: FontWeight.w400,
//                fontSize: 20,
//              color: Colors.black54,
//            ),
//            textAlign: TextAlign.center,
//          ),
//          freeSpace,
//          freeSpace,
//          requestButton,
//        ]);
//    return Container(
//      padding: EdgeInsets.all( 25),
//      child: body,
//    );
//  }


  
  Widget _buildLoadingWidget(){
    return Container(
        color: Colors.black,
        padding: EdgeInsets.all(30),
        child:
          Center(          
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitWave(
                                color: Colors.lightBlueAccent,
                                size: 50.0,
                              ),
                freeSpace,
                //"Alright!, \nNow loading..."
                Center(
                        child:
                        new InstructionTextWidget("Now loading..", true),
                      ),
                Container(),
              ],
            ),
          )
    );
  }

  Widget _buildTapWidget(){
    return Container(
        color: Colors.black,
        padding: EdgeInsets.all(30),
        child:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SpringButton(
                SpringButtonType.OnlyScale,
                new InstructionTextWidget("Tap & Hold", false),
                onLongPress: () {
                    this.mainPresenter.populate();
                    },
              ),
            ],
          ),
        )
    );
  }


  Widget _buildBodyByState(){
    if (tapWidget==null || noneWidget==null){
      tapWidget = _buildTapWidget();
    }
    if (loadingWidget==null){
      loadingWidget = _buildLoadingWidget();
    }
//    if (listWidget==null){
//      listWidget = _buildPhotoGridWidget();
//    }
//    noneWidget = _buildTapWidget();
//    tapWidget = _buildTapWidget();
//    loadingWidget = _buildLoadingWidget();
    listWidget = _buildPhotoGridWidget();
    Widget body = tapWidget;
    print("getBodyByState: "+pageState.toString());
      if (pageState==PAGE_STATE.none){
        body = noneWidget;
      }else if (pageState==PAGE_STATE.tap){
        body = tapWidget;
      }else if (pageState==PAGE_STATE.loading){
        body = loadingWidget;
      }else if (pageState==PAGE_STATE.list){
        body = listWidget;
      }
    return body;
  }


  GestureDetector _buildPhotoGridWidget() {
    return GestureDetector(
        onTap: (){

        },
         onLongPress: () {
          this.mainPresenter.onTap();
        },
        child: Container(
            constraints: BoxConstraints.expand(),
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
                      ],
                    )
                    ,
                    freeSpageSmall,
                Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: _getImageGrid())
                    //child: getGridView(isPortrait)),
              ]))),
    );
  }

  Widget _getImageGrid() {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget orientationBuilder = Container();

//    orientationBuilder = StreamBuilder(
//      stream: imagePublishsubjectStream.stream,
//      builder: (context, AsyncSnapshot<List<Uint8List>> snapshot) {
//        if (snapshot.hasData) {
//          //return createGridListItems(isPortrait, snapshot.data);
//          List<Widget> list = List<Widget>();
//          print("_getImageGrid length: "+snapshot.data.length.toString());
//          for (int x = 0; x < snapshot.data.length; x++){
//            print("_getImageGrid $x ");
//            list.add(_getPhotoItem(isPortrait, snapshot.data[x]));
//          }
//          return new OrientationBuilder(
//            builder: (context, orientation) {
//              return GridView.count(
//                crossAxisCount: orientation == Orientation.portrait ?  2: 3,
//                //children: createGridListItems(isPortrait, this.images)
//                children: list,
//              );
//            },
//          );
//        } else if (snapshot.hasError) {
//          print("_getImageGrid has error");
//          return Container();
//        }
//        print("_getImageGrid no data");
//        return Center(child: CircularProgressIndicator());
//      },
//    );
//    List<Widget> grids = new List<Widget>();
//    StreamBuilder(
//        stream: imagePublishsubjectStream,
//        builder: (context, AsyncSnapshot<Uint8List> snapshot) {
//          if (snapshot.hasData) {
//            print("_getImageGrid has data");
//            grids.add(_getPhotoItem(isPortrait, snapshot.data));
//            //return _getPhotoItem(isPortrait, snapshot.data );
//          } else if (snapshot.hasError) {
//            print("_getImageGrid has error");
//            return Container();
//          }
//          print("_getImageGrid no data");
//          return Center(child: CircularProgressIndicator());
//        }
//    );
//    orientationBuilder = OrientationBuilder(
//      builder: (context, orientation) {
//        return GridView.count(
//          crossAxisCount: orientation == Orientation.portrait ?  2: 3,
//          //children: createGridListItems(isPortrait, this.images)
//          children: grids,
//        );
//      },
//    );
    orientationBuilder = new OrientationBuilder(
      builder: (context, orientation) {
        return GridView.count(
          crossAxisCount: orientation == Orientation.portrait ?  2: 3,
          children: createGridListItems(isPortrait, this.images)
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

  Widget _getPhotoItem(bool isPortrait, Uint8List file){
    return Container(
        padding: EdgeInsets.all(isPortrait==true?10:0),
        child: Stack(
          children: <Widget>[
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

  List<Widget> createGridListItems(bool isPortrait, List<Uint8List> images) {
    int length = images.length;
    //print("createGridListItems: length:$length");
    List<Widget> list = List<Widget>();
    for (int x = 0; x < length; x++){
      list.add(_getPhotoItem(isPortrait, images[x]));
    }
    list.add(Container());
    list.add(Container());
    list.add(Container());
    return list;
  }

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

    imagePublishsubjectStream.close();
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
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black12,
        textColor: Colors.lightBlueAccent,
        fontSize: 16.0
    );
  }

  @override
  void closePage({int delay = 0}) async {
    //Navigator.canPop(context);
    router.goBack();
  }

  @override
  void setPageState(PAGE_STATE pageState) {
    setState(() {
      this.pageState = pageState;
    });
  }




}

class Choice {
  const Choice({this.title});
  final String title;
}

class InstructionTextWidget extends StatelessWidget {
  String text = "";
  bool repeatAnimation = false;
  Color color;
  InstructionTextWidget(this.text, this.repeatAnimation, {this.color = Colors.lightBlueAccent});
  @override
  Widget build(BuildContext context) {
    Widget retVal = Center(
          child:
            new FadeAnimatedTextKit(  
              isRepeatingAnimation: repeatAnimation,            
              textStyle: TextStyle(fontWeight: FontWeight.w400,
                fontSize: 25,
                color: color,

              ),
              textAlign: TextAlign.center, text: [text],
            ) ,
        );
    return retVal;
  }
}
