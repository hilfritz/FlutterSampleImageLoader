import 'package:imageloader_sample/main/ImageLoadingUseCase.dart';
import 'package:imageloader_sample/managers/DownloadManager.dart';
import 'package:imageloader_sample/managers/FileManager.dart';
import 'package:imageloader_sample/managers/Logger.dart';
import 'package:rxdart/rxdart.dart';
/**
 * @author Hilfritz Camallere
 */
abstract class MainPresenter implements ImageLoadingUseCasePresenter{
  MainView view;
  Logger logger;
  DownloadManager downloadManager;
  FileManager fileManager;

  void init(FileManager fm, DownloadManager dm, Logger lg);
  void initView(MainView v);
  void populate();
  void onTap();
  void onTapAndHold();
  void destroy();
}

abstract class MainView implements ImageLoadingUseCaseView{
  bool isLoadingAnimationHidden = true;
}

class MainPresenterImpl implements MainPresenter{
  String TAG = "MainPresenterImpl";
  @override Logger logger;
  @override MainView view;
  @override DownloadManager downloadManager;
  FileManager fileManager;
  ImageLoadingUseCase imageLoadingUseCase;
  void initView(MainView v){
    view = v;
    //INITIALIZE USECASES
    imageLoadingUseCase = new ImageLoadingUseCaseImpl();
    imageLoadingUseCase.init(this, fileManager, downloadManager, logger,view);
  }
  @override
  void init(FileManager fm, DownloadManager dm, Logger lg) {
    //INITIALIZE VARIABLES
    downloadManager = dm;
    fileManager = fm;
    logger = lg;
    logger.start(TAG);
    logger.logg("init");
  }

  @override
  void populate() {
    imageLoadingUseCase.run();
  }

  @override
  void onTap() {
    populate();
  }

  @override
  void onTapAndHold() {
    populate();
    //logger.logg("onTapAndHold");
  }

  @override
  void destroy() {
    imageLoadingUseCase?.destroy();
  }
}