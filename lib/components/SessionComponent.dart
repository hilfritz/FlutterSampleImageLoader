import 'package:imageloader_sample/components/PresenterComponent.dart';
import 'package:imageloader_sample/managers/DownloadManager.dart';
import 'package:imageloader_sample/managers/FileManager.dart';
import 'package:imageloader_sample/managers/Logger.dart';
import 'package:imageloader_sample/managers/Router.dart';
/**
 * Singleton object for the app runtime
 * - THIS IS WHERE PRESENTERS, MODELS ARE INITIALIZED
 * - AND OTHER OBJECTS THAT DONT NEED MULTIPLE INSTANCES
 * @author Hilfritz Camallere
 */
class SessionComponent {
  static final SessionComponent _singleton = new SessionComponent._internal();
  factory SessionComponent() {
    return _singleton;
  }
  SessionComponent._internal();
  Logger _logger;
  PresenterComponent presenterComponent;
  DownloadManager downloadManager;
  FileManager fileManager;
  Router routeManager;

  Future<void> init() async{
    _logger = new LoggerImpl();
    fileManager = new FileManagerImpl();
    await fileManager.init();
    downloadManager = new DownloadManagerImpl();
    presenterComponent = new PresenterComponentImpl();

    routeManager = new RouterImpl();
    presenterComponent.init(_logger, downloadManager, fileManager, routeManager);
    routeManager.init(presenterComponent);
  }
}