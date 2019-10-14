import 'package:imageloader_sample/pages/Base.dart';
import 'package:rxdart/rxdart.dart';

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
  PublishSubject<String> inputTextPublishSubject;
  void initBlocs();
  void scrollToBottom();

}


class ChangeTextListenerUseCaseImpl implements ChangeTextListenerUseCase{
  ChangeTextListenerPresenter presenter;
  ChangeTextListenerView view;
  String inputText = "";
  @override
  void destroy() {
    this.view.inputTextPublishSubject?.close();
  }

  @override
  void init(ChangeTextListenerPresenter presenter, ChangeTextListenerView view) {
    this.presenter = presenter;
    this.view = view;
    //INIT STREAMS
    this.view.inputTextPublishSubject = new PublishSubject<String>();
  }

  @override
  void run() {
    view.initBlocs();
  }

  @override
  void onTextChanged(String str) {
    this.inputText = this.inputText+" "+str+"\n";
    this.view.inputTextPublishSubject.add(this.inputText);
    this.view.scrollToBottom();
  }

  @override
  void clearText() {
    this.inputText = "";
    this.view.inputTextPublishSubject.add(" ");
  }

}
