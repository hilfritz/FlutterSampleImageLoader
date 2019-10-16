import 'package:imageloader_sample/managers/Router.dart';
import 'package:imageloader_sample/pages/Base.dart';
import 'package:imageloader_sample/pages/typewriter/usecases/change_text_tistener_usecase.dart';

abstract class TypeWriterPresenter implements  ChangeTextListenerPresenter{
  TypeWriterView view;
  void init(TypeWriterView v, Router router);
  void populate();
}
abstract class TypeWriterView implements ChangeTextListenerView{
}

abstract class TypeWriterRouter{
  void openTypeWriterPage();
}

class TypeWriterPresenterImpl implements TypeWriterPresenter{
  @override
  TypeWriterView view;
  ChangeTextListenerUseCase changeTextListenerUseCase;

  @override
  void init(TypeWriterView v, Router router) {
    changeTextListenerUseCase = new ChangeTextListenerUseCaseImpl();
    changeTextListenerUseCase.init(this, v);

  }

  @override
  void populate() {
    changeTextListenerUseCase.run();
  }

  @override
  void destroy() {
    changeTextListenerUseCase.destroy();
  }

  @override
  void onTextChanged(String str) {
    changeTextListenerUseCase.onTextChanged(str);
  }

  @override
  void clearText() {
    changeTextListenerUseCase.clearText();
  }


}