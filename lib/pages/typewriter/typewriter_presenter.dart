import 'package:imageloader_sample/pages/Base.dart';
import 'package:imageloader_sample/pages/typewriter/usecases/change_text_tistener_usecase.dart';

abstract class TypeWriterPresenter implements  ChangeTextListenerPresenter{
  TypeWriterView view;
  void initView(TypeWriterView v);
  void populate();
}
abstract class TypeWriterView implements ChangeTextListenerView{
}

abstract class TypeWriterRouter{
  void openTypeWriterPage();
  void closePage();
}

class TypeWriterPresenterImpl implements TypeWriterPresenter{
  @override
  TypeWriterView view;
  ChangeTextListenerUseCase changeTextListenerUseCase;

  @override
  void initView(TypeWriterView v) {
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