import 'dart:async';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:imageloader_sample/main/MainPresenter.dart';
import 'package:imageloader_sample/managers/DownloadManager.dart';
import 'package:imageloader_sample/managers/FileManager.dart';
import 'package:imageloader_sample/managers/Logger.dart';

abstract class ImageLoadingUseCase {
  int NUMBER_OF_IMAGES = 0;

  ImageLoadingUseCaseView view;
  DownloadManager downloadManager;
  FileManager fileManager;
  Logger logger;
  ImageLoadingUseCasePresenter presenter;

  void init(MainPresenter p, FileManager fm, DownloadManager dm, Logger lg,
      ImageLoadingUseCaseView v);

  void run();
  void destroy();
}

abstract class ImageLoadingUseCasePresenter {}

abstract class ImageLoadingUseCaseView {

  List<DownloadTaskInfo> filePaths = new List<DownloadTaskInfo>();
  bool loadingVisibility = false;
  void showErrorPopup(String str);
  void addImageToDisplay(DownloadTaskInfo files);
  void setLoadingAnimationVisibility(bool visibility);
}

abstract class ImageLoadingUseCaseModel {}

class ImageLoadingUseCaseImpl
    implements ImageLoadingUseCase, FileDownloadCallback {
  FileManager fileManager;
  Logger logger;
  String TAG = "ImageLoadingUseCaseImpl";
  List<DownloadTaskInfo> list = new List<DownloadTaskInfo>();

  DateTime lastRun;

  DownloadManager downloadManager;
  @override
  int NUMBER_OF_IMAGES = 10;

  @override
  ImageLoadingUseCasePresenter presenter;

  @override
  ImageLoadingUseCaseView view;

  @override
  void init(MainPresenter p, FileManager fm, DownloadManager dm, Logger lg,
      ImageLoadingUseCaseView v) {
    //INTITIALIZE
    presenter = p;
    fileManager = fm;
    downloadManager = dm;
    logger = lg;
    view = v;

    downloadManager.init(this);
    logger.start(TAG);
    logger.logg("init:");
  }

  @override
  void run() async {
    int currentMilli = new DateTime.now().millisecondsSinceEpoch;
    if (lastRun != null &&
        (currentMilli - lastRun.millisecondsSinceEpoch) < 3000) {
      logger.logg("run: too soon");
      return;
    }
    lastRun = new DateTime.now();
    logger.logg("run: ");
    view.setLoadingAnimationVisibility(true);
    for (int x = 0; x < NUMBER_OF_IMAGES; x++) {
      String currentTimestamp =
          new DateTime.now().millisecondsSinceEpoch.toString();
      String fileNameWithExtension =
          currentTimestamp + "_" + x.toString() + ".png";
      String url = "https://picsum.photos/200";
      String taskId = "";
      File file = File(fileManager.basePath + "/" + fileNameWithExtension);
      taskId = await downloadManager.addTaskForConcurrentDownload(
          url,
          fileManager.basePath + "/",
          fileNameWithExtension,
          false,
          false,
          file,
          false);
//      logger.logg("run: [" +
//          x.toString() +
//          "] [url:" +
//          url +
//          "] [taskId: $taskId][fileNameWithExtension:" +
//          fileNameWithExtension +
//          "] [path:" +
//          fileManager.basePath +
//          "/" +
//          "]");
    }
    //DOWNLOAD ALL FILES CONCURRENTLY

    downloadManager.startDownload();
  }

  @override
  void onDownloadException(dynamic e) {
    logger.logg("onDownloadException: ");
    view.setLoadingAnimationVisibility(false);
    view.showErrorPopup("Oops something went wrong, please try again.");
  }


  @override
  void onFileDownLoaded(
      DownloadTaskInfo downloadTaskInfo, DownloadTaskStatus status) {
    if (status == DownloadTaskStatus.complete) {
      view.addImageToDisplay(downloadTaskInfo);
      if (downloadManager.downloadTasksList.length==0){
        view.setLoadingAnimationVisibility(false);
      }

    }
  }

  @override
  void destroy() {
    downloadManager.cancelAll();
  }
}
