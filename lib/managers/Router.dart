import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:imageloader_sample/components/PresenterComponent.dart';
import 'package:imageloader_sample/pages/typewriter/typewriter_page.dart';
import 'package:imageloader_sample/pages/typewriter/typewriter_presenter.dart';

/**
 * @author Hilfritz Camallere
 */
abstract class Router implements TypeWriterRouter{
  PresenterComponent presenterComponent;
  void init(PresenterComponent presenterComponent);
  void initContext(BuildContext context);
  GlobalKey<NavigatorState> getNavigatorKey();

  void openIncrementDecrementPage();
  void openImageDetailPage();
  Route<dynamic> generateRoute(RouteSettings settings);
}
/**
 * https://www.filledstacks.com/snippet/quick-and-easy-dialogs-in-flutter-with-rf-flutter/
 * https://medium.com/flutter-community/manager-your-flutter-dialogs-with-a-dialog-manager-1e862529523a
 * https://medium.com/flutter-community/navigate-without-context-in-flutter-with-a-navigation-service-e6d76e880c1c
 */

class ROUTE_NAMES{
  static const String MAIN = "/";
  static const String TYPEWRITER = "/typewriter";
  static const String ABOUT = "/about";
}

class RouterImpl implements Router{


  BuildContext context;
  @override
  PresenterComponent presenterComponent;
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void init(PresenterComponent presenterComponent) {
    this.presenterComponent = presenterComponent;
  }

  @override
  void openImageDetailPage() {

  }

  @override
  void openIncrementDecrementPage() {

  }

  @override
  void openTypeWriterPage() {
    navigatorKey.currentState.pushNamed(ROUTE_NAMES.TYPEWRITER);
  }

  @override
  void initContext(BuildContext ctx) {
    context = ctx;
  }

  @override
  GlobalKey<NavigatorState> getNavigatorKey() {
    return navigatorKey;
  }

  @override
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case ROUTE_NAMES.TYPEWRITER:
        return MaterialPageRoute(builder: (context) {
          var typeWriterPageStatefulWidget = new TypeWriterPage("TypeWriter", this.presenterComponent.typeWriterPresenter);
          return typeWriterPageStatefulWidget;
        });
    }
  }
}