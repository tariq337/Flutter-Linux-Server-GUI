import 'dart:convert';
import 'dart:developer';

import 'package:guiapp/ServerControll/Obj.dart';

class TypesData {
  Future<bool> TypeFile(String path) async {
    try {
      String typeFile = utf8
          .decode(await sshObj.client.run("file $path | awk ' { print \$2 } '"))
          .toString()
          .split('\n')[0];
      if (typeFile == 'directory') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> TypeFileASCII(String path) async {
    try {
      String typeFile =
          utf8.decode(await sshObj.client.run('file $path ')).toString();
      log(typeFile);
      if (typeFile.contains("ASCII") ||
          typeFile.contains("UTF-8") ||
          typeFile.contains("empty") ||
          typeFile.contains("script")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
