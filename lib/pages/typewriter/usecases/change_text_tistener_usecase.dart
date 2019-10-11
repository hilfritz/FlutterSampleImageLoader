import 'package:imageloader_sample/pages/Base.dart';

abstract class ChangeTextListenerUseCase implements BaseUseCase{
  void init(ChangeTextListenerPresenter presenter, ChangeTextListenerView view);
  void onTextChanged(String str);
  void clearText();
  void run();

}

abstract class ChangeTextListenerPresenter implements BasePresenter{
  void onTextChanged(String str);
  void clearText();
}

abstract class ChangeTextListenerView implements BaseViews{
  String inputText = "";
  void initBlocs();


}


class ChangeTextListenerUseCaseImpl implements ChangeTextListenerUseCase{
  ChangeTextListenerPresenter presenter;
  ChangeTextListenerView view;

  @override
  void destroy() {

  }

  @override
  void init(ChangeTextListenerPresenter presenter, ChangeTextListenerView view) {
    this.presenter = presenter;
    this.view = view;
  }

  @override
  void run() {
    view.initBlocs();


  }

  @override
  void onTextChanged(String str) {
    this.view.inputText = this.view.inputText+" "+str;
  }

  @override
  void clearText() {
    this.view.inputText = "";
  }

}
