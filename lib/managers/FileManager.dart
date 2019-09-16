import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
/**
 *
 * @author Hilfritz Camallere
 */
abstract class FileManager{
  String basePath = "";
  Future<void> init();
  Future<File> createFileFromBasePath(String filename);
  Future<bool> downloadFile(String urlLink, File destinationFile);
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

  @override
  Future<bool> downloadFile(String urlLink, File destinationFile) async{
    bool retVal = false;
    Uint8List buffer = await http.readBytes(urlLink);
    RandomAccessFile rf = destinationFile.openSync(mode: FileMode.write);
    rf.writeFromSync(buffer);
    rf.flushSync();
    rf.closeSync();
    if (destinationFile != null) {
      int length = await destinationFile.length();
      if (length > 10) {
        return true;
      }
    }

    return retVal;
  }
}