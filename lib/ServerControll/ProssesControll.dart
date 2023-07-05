import 'dart:convert';

import 'package:guiapp/ServerControll/Obj.dart';

class ProssesControll {
  List<String> prosses = [];
  String error = '';
  String errorKill = '';
  List<String> title = [];

  getProssers(Function update) async {
    try {
      final out = await sshObj.client.run(
          'ps -eaux | awk \' { print \$1 " | " \$2 " | " \$3 " | " \$4 " | " \$5 " | " \$6 " | " \$7 " | " \$8 " | " \$9 " | " \$10 " | " \$11 } \' ');
      List<String> data = (utf8.decode(out)).toString().split('\n');
      title = data[0].split(" | ");
      data.removeAt(0);
      data.removeLast();
      prosses = data;

      error = '';
      update();
    } catch (e) {
      error = 'error get prosses $e';
      update();
    }
  }

  Future<bool> killer({required String pid}) async {
    try {
      await sshObj.client.run('echo ${sshObj.password} | sudo -S kill $pid');

      return true;
    } catch (e) {
      errorKill = 'error kill prosses PID: [$pid ] = $e';
      return false;
    }
  }
}
