import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
/**
 *
 * @author Hilfritz Camallere
 */
abstract class FileManager{
  String basePath = "";
  Future<void> init();
  Future<File> createFileFromBasePath(String filename);
}
class FileManagerImpl implements FileManager{
  String basePath = "";
    @override
  Future<void> init() async{
    print("FileManagerImpl: ");
    final Directory directory = await getApplicationDocumentsDirectory();
    basePath = directory.path;
    bool directoryExist = await directory.exists();
  }
  @override
  Future<File> createFileFromBasePath(String filename) async{
    String path =  basePath+"/"+filename;
    File f = new File(path);
    bool exist = await f.exists();
    if (exist==false){
      f = await f.create();
    }
    var completer = new Completer<File>();
    completer.complete(f);
    return completer.future;
  }
}