import 'package:dartssh2/dartssh2.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/model/fileModel.dart';

class GetFileControll {
  Future<List<dynamic>> getFileData({required String path}) async {
    try {
      List<FileModel> fileModels = [];
      if (path.isEmpty) {
        path = '/';
      }
      List<SftpName> sfs = await sshObj.sftp.listdir(path);

      for (SftpName line in sfs) {
        if (!(line.filename == '.' || line.filename == '..')) {
          String type = line.attr.isDirectory
              ? "dir"
              : line.attr.isFile
                  ? "file"
                  : line.attr.isSymbolicLink
                      ? "link"
                      : "other";

          String name = line.filename;
          String size = (line.attr.size ?? 0) < 1024
              ? "${line.attr.size ?? 0}B"
              : (line.attr.size ?? 0) < 1048576
                  ? "${((line.attr.size ?? 0) / 1024).toStringAsFixed(2)} KB"
                  : (line.attr.size ?? 0) < 1073741824
                      ? "${((line.attr.size ?? 0) / 1048576).toStringAsFixed(2)}MB"
                      : "${((line.attr.size ?? 0) / 1073741824).toStringAsFixed(2)}GB";
          int groupID = line.attr.groupID!;
          int userID = line.attr.userID!;

          String location = '';
          String linklocation = '';
          if (type == 'link') {
            linklocation = await sshObj.sftp.readlink('$path/${line.filename}');
            linklocation = linklocation;
          }
          location = '$path/${line.filename}';

          fileModels.add(FileModel(
              name: name,
              type: type,
              size: size,
              groupID: groupID,
              userID: userID,
              location: location,
              linklocation: linklocation));
        }
      }

      return [true, fileModels];
    } catch (e) {
      return [false, e.toString()];
    }
  }
}
