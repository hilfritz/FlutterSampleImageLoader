import 'package:imageloader_sample/managers/DownloadManager.dart';
import 'package:imageloader_sample/managers/FileManager.dart';
import 'package:imageloader_sample/managers/Logger.dart';
import 'package:imageloader_sample/managers/Router.dart';
import 'package:imageloader_sample/pages/main/MainPresenter.dart';
import 'package:imageloader_sample/pages/typewriter/typewriter_presenter.dart';
/**
 * Component designed to hold all the presenters in the app
 * - singleton helps prevent multiple instances of objects
 * * @author Hilfritz Camallere
 */
abstract class PresenterComponent {
  MainPresenter mainPresenter;
  TypeWriterPresenter typeWriterPresenter;
  void  init(Logger logger, DownloadManager downloadManager, FileManager fileManager, Router router);
}

class PresenterComponentImpl implements PresenterComponent{
  @override
  MainPresenter mainPresenter;
  @override
  TypeWriterPresenter typeWriterPresenter;

  @override
  void init(Logger logger, DownloadManager downloadManager, FileManager fileManager, Router router) {
    mainPresenter = new MainPresenterImpl();
    mainPresenter.init(fileManager, downloadManager,logger, router);
    typeWriterPresenter = new TypeWriterPresenterImpl();
  }


}