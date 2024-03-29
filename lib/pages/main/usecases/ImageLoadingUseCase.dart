import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Image;
import 'package:rxdart/rxdart.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:imageloader_sample/managers/DownloadManager.dart';
import 'package:imageloader_sample/managers/FileManager.dart';
import 'package:imageloader_sample/managers/Logger.dart';

import '../../Base.dart';
import '../MainPresenter.dart';

abstract class ImageLoadingUseCase implements BaseUseCase{
  int NUMBER_OF_IMAGES = 0;

  ImageLoadingUseCaseView view;
  DownloadManager downloadManager;
  FileManager fileManager;
  Logger logger;
  ImageLoadingUseCasePresenter presenter;
  void init(MainPresenter p, FileManager fm, DownloadManager dm, Logger lg,
      ImageLoadingUseCaseView v);
  void run();
}
abstract class ImageLoadingUseCasePresenter implements BasePresenter{}
abstract class ImageLoadingUseCaseView{
  PublishSubject<Uint8List> imagePublishsubjectStream;
  void showErrorPopup(String str);
  void addImageToDisplay(Uint8List files);
  void clearImages();
  void setPageState(PAGE_STATE pageState);
}

abstract class ImageLoadingUseCaseModel {}
/**
 * The usecase that triggers and downloads images to local storage
 * - uses downloadManager.dart - ensures download is done in the background and native side of the platform
 *    in case of Android - the download will be handled by the native WorkManager library
 * @author Hilfritz Camallere
 */
class ImageLoadingUseCaseImpl
    implements ImageLoadingUseCase, FileDownloadCallback {
  FileManager fileManager;
  Logger logger;
  String TAG = "ImageLoadingUseCaseImpl";
  DateTime lastRun;
  DownloadManager downloadManager;

  @override int NUMBER_OF_IMAGES = 4;
  @override ImageLoadingUseCasePresenter presenter;
  @override ImageLoadingUseCaseView view;

  @override
  void init(MainPresenter p, FileManager fm, DownloadManager dm, Logger lg,
      ImageLoadingUseCaseView v
      ) {
    //INTITIALIZE
    presenter = p;
    fileManager = fm;
    downloadManager = dm;
    logger = lg;
    view = v;
    downloadManager.init(this);
    logger.start(TAG);
    logger.logg("init:");
    if (this.view.imagePublishsubjectStream==null){
      this.view.imagePublishsubjectStream = new PublishSubject<Uint8List>();
    }
  }

  bool canSetStateToList = false;

  @override
  void run() async {

    int currentMilli = new DateTime.now().millisecondsSinceEpoch;
    if (lastRun != null &&
        (currentMilli - lastRun.millisecondsSinceEpoch) < 3000) {
      logger.logg("run: too soon");
      return;
    }
    canSetStateToList = true;
    view.setPageState(PAGE_STATE.loading);
    lastRun = new DateTime.now();
    logger.logg("run: ");
    view.clearImages();
    await Future.delayed(const Duration(milliseconds: 1500));
    //DOWNLOAD THE IMAGES
    for (int x = 0; x < NUMBER_OF_IMAGES; x++) {
      String currentTimestamp =
      new DateTime.now().millisecondsSinceEpoch.toString();
      String fileNameWithExtension =
          currentTimestamp + "_" + x.toString() + ".png";
      String url = "https://picsum.photos/600/800";
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
    }

//    await Future.delayed(const Duration(milliseconds: 1500));
//    for (int x = 0; x < NUMBER_OF_IMAGES; x++) {
//      String currentTimestamp =
//      new DateTime.now().millisecondsSinceEpoch.toString();
//      String fileNameWithExtension =
//          currentTimestamp + "_" + x.toString() + ".png";
//      String url = "https://picsum.photos/600/800";
//      String taskId = "";
//      File file = File(fileManager.basePath + "/" + fileNameWithExtension);
//      File downloadedFile = await fileManager.downloadFile(url, file);
//      if (downloadedFile!=null && downloadedFile.existsSync()){
//        Uint8List readFileByte = await _readFileByte(downloadedFile.path);
//        view.addImageToDisplay(readFileByte);
//      }else{
//
//      }
//    }
  }

  @override
  void onDownloadException(dynamic e) {
    logger.logg("onDownloadException: ");
    view.showErrorPopup("Oops something went wrong, please try again.");
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value); 
      //print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
      onError.toString());
    });
    return bytes;
  }



  @override
  void onFileDownLoaded(
      DownloadTaskInfo downloadTaskInfo, DownloadTaskStatus status) {
    if (canSetStateToList) {
      canSetStateToList = false;
      view.setPageState(PAGE_STATE.list);
    }
    if (status == DownloadTaskStatus.complete) {
      //PASS IMAGE BYTES TO VIEW
      _readFileByte(downloadTaskInfo.path).then((x){
        view.addImageToDisplay(x);
        //view.imagePublishsubjectStream.add(x);
      }).catchError((onError){
        view.showErrorPopup("Oops something went wrong, please try again.");
      });
      if (downloadManager.downloadTasksList.length==0){
        
      }
    }
  }

  @override
  void destroy() {
    downloadManager.cancelAll();
  }
}
