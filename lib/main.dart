
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:imageloader_sample/components/SessionComponent.dart';
import 'package:imageloader_sample/main/MainPresenter.dart';
import 'package:imageloader_sample/managers/DownloadManager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spring_button/spring_button.dart';

void main() {
  //INITIALIZE SINGLETON SESSION
  SessionComponent sessionComponent = new SessionComponent();
  sessionComponent.init().then((x){
    runApp(MyApp(sessionComponent.presenterComponent.mainPresenter));
  });


}

class MyApp extends StatelessWidget {
  final MainPresenter mainPresenter;
  MyApp(this.mainPresenter);

  @override
  Widget build(BuildContext context) {
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
  bool permissionGranted = false;
  @override
  bool loadingVisibility = false;
  @override
  List<DownloadTaskInfo> filePaths = new List<DownloadTaskInfo>();
  final MainPresenter mainPresenter;
  _MyHomePageState(this.mainPresenter);
  @override
  void initState() {
    super.initState();
    this.mainPresenter.initView(this);
    WidgetsBinding.instance
        .addPostFrameCallback((x){
          //this.mainPresenter.populate();

    });
  }

  Widget freeSpage = Container(padding: EdgeInsets.all(10),);
  Widget freeSpageSmall = Container(padding: EdgeInsets.all(5),);

  void askPermissions() async{
    //Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission==PermissionStatus.granted){
      permissionGranted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      permissionGranted = false;
    });
    //ASK THE CORRECT PERMISSIONS FIRST
    askPermissions();
    return GestureDetector(
        onTap: () {
          this.mainPresenter.onTap();
        },
        onLongPress: () {
          this.mainPresenter.onTapAndHold();
        },
        child: Scaffold(

          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: permissionGranted==false?getBody():requestPermissionBody(),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
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
          freeSpage,
          freeSpage,
          requestButton,

          //child: getGridView(isPortrait)),
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
        child: Center(
          child:new Text(
            'Just a small Tap',
            style: TextStyle(fontWeight: FontWeight.w400,
              fontSize: 25,
              color: Colors.lightBlueAccent,
            ),
            textAlign: TextAlign.left,
          ) ,
        )
    );
  }

  Widget getBody() {
    if (this.filePaths.length==0){
      return getInstructionsWidget();
    }

    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
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
                        'Another gentle a tap',
                        style: TextStyle(fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.lightBlueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      (this.loadingVisibility==true?SpinKitFadingCircle(
                        color: Colors.lightBlueAccent,
                        size: 25.0,
                      ):Container()),
                    ],
                  )
                  ,
                  freeSpageSmall,


              Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: getImageGrid())
                  //child: getGridView(isPortrait)),
            ])));

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

  Widget _getGridviewItems(int index, bool isPortrait, DownloadTaskInfo file){
    //print("_getGridviewItems: [index:$index] [isPortrait:$isPortrait] [path:${file.path}");
    File tempFile = File (file.path);
    return Container(
        padding: EdgeInsets.all(isPortrait==true?10:0),
        child: Stack(
          children: <Widget>[
            Center(child: CircularProgressIndicator()),
            Center(
                child: Image.file(tempFile,width: 200,height: 200,fit: BoxFit.fill )
            ),
          ],
        )

    );
  }

  List<Widget> createGridListItems(bool isPortrait) {
    int length = this.filePaths.length;
    print("createGridListItems: length:$length");
    List<Widget> list = List<Widget>();
    for (int x = 0; x < length; x++){
      list.add(_getGridviewItems(x,isPortrait, this.filePaths[x]));
    }
    list.add(Container());
    list.add(Container());
    list.add(Container());
    return list;
  }




  @override
  Widget getLoadingAnimation() {

    return Container();
  }

  @override
  bool isLoadingAnimationHidden;

  @override
  void showErrorPopup(String str) {
    //Alert(context: context, title: "Info", desc: str).show();
  }

  @override
  void addImageToDisplay(DownloadTaskInfo files) {
    setState(() {
      this.filePaths.add(files);
    });
  }

  @override
  void setLoadingAnimationVisibility(bool vs) {

    if (vs==false){
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          this.loadingVisibility = vs;
        });

      });
    }else{
      setState(() {
        this.loadingVisibility = vs;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    this.mainPresenter.destroy();
  }

}
