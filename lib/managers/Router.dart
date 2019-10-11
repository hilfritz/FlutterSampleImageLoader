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

  Map<String, dynamic > generateRoutes(BuildContext context);
  Route<dynamic> generateRoute(RouteSettings settings);
}
/**
 * https://www.filledstacks.com/snippet/quick-and-easy-dialogs-in-flutter-with-rf-flutter/
 * https://medium.com/flutter-community/manager-your-flutter-dialogs-with-a-dialog-manager-1e862529523a
 * https://medium.com/flutter-community/navigate-without-context-in-flutter-with-a-navigation-service-e6d76e880c1c
 */

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
    navigatorKey.currentState.pushNamed("/typewriter");
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
  Map<String, dynamic> generateRoutes(BuildContext context) {

    var typeWriterPageStatefulWidget = new TypeWriterPageStatefulWidget("TypeWriter", this.presenterComponent.typeWriterPresenter);

      return {
        "/typewriter":(context) => new TypeWriterPageStatefulWidget("TypeWriter", this.presenterComponent.typeWriterPresenter)
      };

  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/typewriter':
        return MaterialPageRoute(builder: (context) => new TypeWriterPageStatefulWidget("TypeWriter", this.presenterComponent.typeWriterPresenter));
    }
  }
}