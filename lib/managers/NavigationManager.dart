import 'package:imageloader_sample/components/PresenterComponent.dart';

abstract class NavigationManager{
  PresenterComponent presenterComponent;
  void init(PresenterComponent presenterComponent);
}

class NavigationManagerImpl implements NavigationManager{
  @override
  PresenterComponent presenterComponent;

  @override
  void init(PresenterComponent presenterComponent) {
    this.presenterComponent = presenterComponent;
  }

}