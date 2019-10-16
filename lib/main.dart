import 'package:flutter/material.dart';
import 'package:imageloader_sample/pages/main/MainPage.dart';

import 'components/SessionComponent.dart';

void main() {
  //INITIALIZE SINGLETON SESSION
  SessionComponent sessionComponent = new SessionComponent();
  sessionComponent.init().then((x){
    //runApp(MainPage(sessionComponent));
    runApp(MainPage(sessionComponent.presenterComponent.mainPresenter, sessionComponent.routeManager));
  });
}