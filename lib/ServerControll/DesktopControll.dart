import 'package:guiapp/ServerControll/GetFileControll.dart';
import 'package:guiapp/model/fileModel.dart';

class DesktopControll {
  List<FileModel> fileModels = [];
  String error = '';
  bool isload = true;
  String _path = '';
  String _homePath = '';

  Future<void> getFileData(Function Update) async {
    isload = true;
    Update();
    GetFileControll getFileControll = GetFileControll();
    List<dynamic> out = await getFileControll.getFileData(path: _path);
    if (out[0]) {
      fileModels = out[1];
    } else {
      error = out[1];
    }
    isload = false;
    Update();
  }

  setPath({required String path}) {
    _path = '$path/Desktop';
    _homePath = path;
  }

  String getPath() {
    return _path;
  }

  String getHomePath() {
    return _homePath;
  }
}
