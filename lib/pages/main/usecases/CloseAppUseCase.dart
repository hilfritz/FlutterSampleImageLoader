
import 'package:imageloader_sample/pages/Base.dart';

abstract class CloseAppPresenter implements BasePresenter{
  void onBackButtonTap();
}

abstract class CloseAppUseCaseView implements BaseViews{
  bool goBack =  false; //by default is false, override back button
  void showToast(String str);
}

abstract class CloseAppUseCase implements BaseUseCase{
  int lastTap = 0;
  CloseAppPresenter presenter;
  CloseAppUseCaseView view;
  void init(CloseAppPresenter presenter, CloseAppUseCaseView view);
  void run();
}
class CloseAppUseCaseImpl implements CloseAppUseCase{
  @override
  int lastTap = 0;
  CloseAppPresenter presenter;
  CloseAppUseCaseView view;
  @override
  void init(CloseAppPresenter presenter, CloseAppUseCaseView view) {
    this.view = view;
    this.presenter = presenter;
  }

  @override
  void run() {
    int now = new DateTime.now().millisecondsSinceEpoch;
    int difference = now - lastTap;
    //view.setEnableBack(false);
    view.goBack = false;
    if (lastTap==0){
      view.showToast("Press back again to exit app. ");
    }else{
      if (difference < 1500){
        view.goBack = true;  
        //view.closePage(delay: 3000);
        //  view.updateBySetState((){
        //      view.goBack = true;  
        //    });
        
      }else{
        view.showToast("Press back again to exit app. ");
      }
    }
    lastTap = now;
  }
  @override
  void destroy() {

  }


}