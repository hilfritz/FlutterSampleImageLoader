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
  GlobalKey<NavigatorState> getPageRouterKey();
  void goBack();

  void openIncrementDecrementPage();
  void openImageDetailPage();
  Route<PageRoute> generateRoute(RouteSettings settings);
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


  var typeWriterPage;

  BuildContext context;
  @override
  PresenterComponent presenterComponent;
  final GlobalKey<NavigatorState> pageRouterKey = new GlobalKey<NavigatorState>();

  @override
  void init(PresenterComponent presenterComponent) {
    this.presenterComponent = presenterComponent;

    //INITIALIZE PAGES
    typeWriterPage = new TypeWriterPage(this.presenterComponent.typeWriterPresenter, this);


  }

  @override
  void openImageDetailPage() {

  }

  @override
  void openIncrementDecrementPage() {

  }

  @override
  void openTypeWriterPage() {
    pageRouterKey.currentState.pushNamed(ROUTE_NAMES.TYPEWRITER);
  }

  @override
  GlobalKey<NavigatorState> getPageRouterKey() {
    return pageRouterKey;
  }

  @override
  Route<PageRoute> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_NAMES.TYPEWRITER:
        return OpenPageAnimationMaterialPageRoute(builder: (context) {
          return typeWriterPage;
        });
    }
  }

  @override
  void goBack() {
    pageRouterKey.currentState.pop();
  }
}

/*
 * https://stackoverflow.com/questions/56792479/flutter-animate-transition-to-named-route
 * https://medium.com/flutter-community/everything-you-need-to-know-about-flutter-page-route-transition-9ef5c1b32823
 */
class OpenPageAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  OpenPageAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
      builder: builder,
      maintainState: maintainState,
      settings: settings,
      fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: RotationTransition(
        turns: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      ),
    );
    //return child;
  }
}
