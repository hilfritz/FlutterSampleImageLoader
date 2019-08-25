import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
/**
 * Download manager uses the Android Work manager class to download files in the background
 * - https://developer.android.com/topic/libraries/architecture/workmanager
 * 
 */
abstract class DownloadManager{
  FileDownloadCallback downloadCallback;
  List<DownloadTaskInfo> downloadTasksList = List<DownloadTaskInfo>();
  void init(FileDownloadCallback downloadCallback);
  Future<String> _addTaskForConcurrentDownload(String url, String pathToSave, String fileName, bool isShowNotification, bool openFileFromNotification, File file, bool exist);
  Future<String> addTaskForConcurrentDownload(String url, String pathToSave, String fileName, bool isShowNotification, bool openFileFromNotification, File file, bool exist);
  void startDownload();
  void cancelAll();
  DownloadTaskInfo getDownloadTaskInfoById(String id);
}

class DownloadTaskInfo{
  File file;
  bool exist = false;
  String taskId = "";
  String path = "";
  DownloadTaskInfo(this.taskId, this.path, this.file, this.exist);
}

abstract class FileDownloadCallback{
  void onFileDownLoaded(DownloadTaskInfo downloadTaskInfo, DownloadTaskStatus status);
  void onDownloadException(dynamic e);
}

class DownloadManagerImpl implements DownloadManager{
  List<DownloadTaskInfo> downloadTasksList = List<DownloadTaskInfo>();
  FileDownloadCallback downloadCallback;
  @override
  Future<String> _addTaskForConcurrentDownload(String url, String pathToSave, String fileName, bool isShowNotification, bool openFileFromNotification, File file, bool exist) async {
    return await FlutterDownloader.enqueue(
        url: url,
        savedDir: pathToSave,
        fileName: fileName,
        showNotification: isShowNotification,
        openFileFromNotification: openFileFromNotification
    );
  }

   @override
  Future<String> addTaskForConcurrentDownload(String url, String pathToSave, String fileName, bool isShowNotification, bool openFileFromNotification, File file, bool exist) async {
    String taskId = await _addTaskForConcurrentDownload(
       url,
      pathToSave,
      fileName,
      isShowNotification,
      openFileFromNotification,
      file, exist
    );
    print("addTaskForConcurrentDownload: taskId: $taskId");
    //Add task ID to task pool
    downloadTasksList.add(DownloadTaskInfo(taskId, pathToSave+fileName, file, exist));
    //add file callback when download finishes
      FlutterDownloader.registerCallback((id, status, progress) {
        if (status==DownloadTaskStatus.complete){
          DownloadTaskInfo downloadTaskInfo = getDownloadTaskInfoById(id);
          int index = getTaskIndex(id);
          downloadTasksList.removeAt(index);
          print("addTaskForConcurrentDownload: registerCallback id: $id download complete path:"+downloadTaskInfo.path);
          this.downloadCallback.onFileDownLoaded(DownloadTaskInfo(id, downloadTaskInfo.path, File(downloadTaskInfo.path), true), status);
        }
      });
      return taskId;
  }

  @override
  void init(FileDownloadCallback downloadCallback) {
    this.downloadCallback = downloadCallback;
  }

  @override
  void startDownload() {
    FlutterDownloader.loadTasks().then((List<DownloadTask> x){
      x.forEach((DownloadTask y){
      });
    }).catchError((onError){
      print(onError);
      downloadCallback.onDownloadException(onError);
    });
  }

  @override
  void cancelAll() {
    FlutterDownloader.cancelAll();
  }

  int getTaskIndex(String id) {
    int retVal = -1;
    int size = downloadTasksList.length;
    for (int x = 0; x< size; x++){
      if (downloadTasksList[x].taskId.compareTo(id)==0){
        retVal = x;
        break;
      }
    }
    return retVal;
  }
  @override
  DownloadTaskInfo getDownloadTaskInfoById(String id) {
    DownloadTaskInfo retVal = null;
    int size = downloadTasksList.length;
    for (int x = 0; x< size; x++){
      if (downloadTasksList[x].taskId.compareTo(id)==0){
        retVal = downloadTasksList[x];
        break;
      }
    }
    return retVal;
  }

}