import 'package:imageloader_sample/components/PresenterComponent.dart';
import 'package:imageloader_sample/managers/DownloadManager.dart';
import 'package:imageloader_sample/managers/FileManager.dart';
import 'package:imageloader_sample/managers/Logger.dart';


/**
 * Singleton object for the app runtime
 * - THIS IS WHERE PRESENTERS, MODELS ARE INITIALIZED
 * - AND OTHER OBJECTS THAT DONT NEED MULTIPLE INSTANCES
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


  Future<void> init() async{
    _logger = new LoggerImpl();
    fileManager = new FileManagerImpl();
    await fileManager.init();
    downloadManager = new DownloadManagerImpl();
    presenterComponent = new PresenterComponentImpl();
    presenterComponent.init(_logger, downloadManager, fileManager);

  }

}