import 'dart:developer';
/**
 *
 * @author Hilfritz Camallere
 */
abstract class Logger{
  void start(String tag);
  void end();
  void logg(String logString);
  void printLogs();
  void save();
}

class LoggerImpl implements Logger{
  String TAG = "";
  String logString = "";

  @override
  void end() {
    logString = "";
  }

  @override
  void logg(String logString) {
    print(TAG+": "+logString);
    logString+="\n"+logString;
  }

  @override
  void save() {
    //SAVE TO FILE or upload to server
  }

  @override
  void start(String tag) {
    TAG = tag;
    logString = "";
  }

  @override
  void printLogs() {
    log(TAG+": "+logString);
  }

}