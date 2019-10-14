import 'package:imageloader_sample/managers/DownloadManager.dart';
import 'package:imageloader_sample/managers/FileManager.dart';
import 'package:imageloader_sample/managers/Logger.dart';
import 'package:imageloader_sample/managers/Router.dart';
import 'package:imageloader_sample/pages/main/usecases/CloseAppUseCase.dart';
import '../Base.dart';
import 'usecases/ImageLoadingUseCase.dart';
/**
 * @author Hilfritz Camallere
 */
enum PAGE_STATE {
  none,
  tap,
  loading,
  list
}
abstract class MainPresenter implements  ImageLoadingUseCasePresenter, CloseAppPresenter{
  PAGE_STATE pageState;
  MainView view;
  Logger logger;
  DownloadManager downloadManager;
  FileManager fileManager;
  Router router;
  void init(FileManager fm, DownloadManager dm, Logger lg, Router router);
  void initView(MainView v);
  void populate();
  void onTap();
  void onTapAndHold();
}
abstract class MainView implements ImageLoadingUseCaseView, CloseAppUseCaseView{
}
class MainPresenterImpl implements MainPresenter{
  String TAG = "MainPresenterImpl";
  @override PAGE_STATE pageState;
  @override Logger logger;
  @override MainView view;
  @override DownloadManager downloadManager;
  @override Router router;
  FileManager fileManager;
  ImageLoadingUseCase imageLoadingUseCase;
  CloseAppUseCase closeAppUseCase;
  void initView(MainView v){
    view = v;
    //INITIALIZE USECASES
    imageLoadingUseCase = new ImageLoadingUseCaseImpl();
    imageLoadingUseCase.init(this, fileManager, downloadManager, logger,view);
    closeAppUseCase = new CloseAppUseCaseImpl();
    closeAppUseCase.init(this, view);
  }
  @override
  void init(FileManager fm, DownloadManager dm, Logger lg, Router rt) {
    //INITIALIZE VARIABLES
    downloadManager = dm;
    fileManager = fm;
    logger = lg;
    logger.start(TAG);
    logger.logg("init");
    router = rt;
  }

  @override
  void populate() {
    imageLoadingUseCase.run();
  }

  @override
  void onTap() {
    //router.openTypeWriterPage();
    populate();
  }

  @override
  void onTapAndHold() {
    populate();
  }

  @override
  void destroy() {
    //CALL DESTROY FOR ALL USECASES
    imageLoadingUseCase?.destroy();
    closeAppUseCase?.destroy();
  }

  @override
  void onBackButtonTap() {
    closeAppUseCase.run();
  }
}