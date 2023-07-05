import 'package:guiapp/ServerControll/GetFileControll.dart';
import 'package:guiapp/model/fileModel.dart';

class FileMangerControll {
  List<FileModel> fileModels = [];
  String error = '';
  String path = '/', lastpath = '/';
  bool isloading = true;
  Future<bool> getFileData(
      {required String path,
      required bool reload,
      required Function Update}) async {
    if (!reload) {
      switchPath(path: path);
    }
    isloading = true;
    Update();
    GetFileControll getFileControll = GetFileControll();
    List<dynamic> out = await getFileControll.getFileData(path: path);
    if (out[0]) {
      fileModels = out[1];
    } else {
      error = out[1];
    }
    isloading = false;
    Update();
    return out[0];
  }

  Future<void> open() async {}
  addPath({required String path, required String lastpath}) {
    this.path = path;
    this.lastpath = lastpath;
  }

  switchPath({required String path}) {
    lastpath = this.path;
    this.path = path;
  }

  Future<void> back({required Function Update}) async {
    if (path != '/') {
      String cashPath = lastpath;
      lastpath = path;
      path = path.substring(0, path.lastIndexOf('/'));
      try {
        await getFileData(
            path: path,
            Update: () {
              Update();
            },
            reload: true);
      } catch (e) {
        path = lastpath;
        lastpath = cashPath;
      }
    }
  }

  Future<void> lastPath({required Function Update}) async {
    String cashPath = lastpath;
    lastpath = path;
    path = cashPath;
    try {
      await getFileData(
          path: path,
          Update: () {
            Update();
          },
          reload: true);
    } catch (e) {
      path = lastpath;
      lastpath = cashPath;
    }
  }
}
