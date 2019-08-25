import 'package:imageloader_sample/main/MainPresenter.dart';
import 'package:imageloader_sample/managers/DownloadManager.dart';
import 'package:imageloader_sample/managers/FileManager.dart';
import 'package:imageloader_sample/managers/Logger.dart';


/**
 * Component designed to hold all the presenters in the app
 * - singleton helps prevent multiple instances of objects
 */
abstract class PresenterComponent {
  MainPresenter mainPresenter;
  void  init(Logger logger, DownloadManager downloadManager, FileManager fileManager);
}

class PresenterComponentImpl implements PresenterComponent{
  @override
  MainPresenter mainPresenter;

  @override
  void init(Logger logger, DownloadManager downloadManager, FileManager fileManager) {
    mainPresenter = new MainPresenterImpl();
    mainPresenter.init(fileManager, downloadManager,logger);
  }



}