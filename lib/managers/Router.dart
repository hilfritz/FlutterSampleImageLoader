import 'package:imageloader_sample/components/PresenterComponent.dart';

/**
 * @author Hilfritz Camallere
 */
abstract class Router{
  PresenterComponent presenterComponent;
  void init(PresenterComponent presenterComponent);
}
/**
 * https://www.filledstacks.com/snippet/quick-and-easy-dialogs-in-flutter-with-rf-flutter/
 * https://medium.com/flutter-community/manager-your-flutter-dialogs-with-a-dialog-manager-1e862529523a
 * https://medium.com/flutter-community/navigate-without-context-in-flutter-with-a-navigation-service-e6d76e880c1c
 */

class RouterImpl implements Router{
  @override
  PresenterComponent presenterComponent;

  @override
  void init(PresenterComponent presenterComponent) {
    this.presenterComponent = presenterComponent;
  }

}