import 'dart:developer';
import 'dart:io';

import 'package:guiapp/ServerControll/Obj.dart';

class bashScript {
  donlowd({required String src, String dest = './donlowd/'}) async {
    src = src.split(' ').join('\\ ');

    await Process.run('bash', [
      "bash/donlowd/donlowd.sh",
      "\"${sshObj.userName}@${sshObj.hostName}:$src\"",
      dest,
    ]);
    await Process.run('xdg-open', [dest]);
  }

  copy({required bool isDir, required String src, required String dest}) async {
    src = src.split(' ').join('\\ ');
    dest = dest.split(' ').join('\\ ');

    if (isDir) {
      Process.run('bash', [
        "bash/copy/copyDir.sh",
        sshObj.userName,
        sshObj.hostName,
        src,
        dest,
        "&"
      ]);
    } else {
      Process.run('bash', [
        "bash/copy/copyFile.sh",
        sshObj.userName,
        sshObj.hostName,
        src,
        dest,
        "&"
      ]);
    }
  }

  mov({required String src, required String dest}) async {
    src = src.split(' ').join('\\ ');
    dest = dest.split(' ').join('\\ ');

    Process.run('bash',
        ["bash/mov.sh", sshObj.userName, sshObj.hostName, src, dest, "&"]);
  }

  void delet({required String type, required String path}) async {
    path = path.split(' ').join('\\ ');

    switch (type) {
      case 'dir':
        Process.run('bash', [
          "bash/delet/deletDir.sh",
          sshObj.userName,
          sshObj.hostName,
          path,
        ]);

        break;
      case 'file':
        Process.run('bash', [
          "bash/delet/deletFile.sh",
          sshObj.userName,
          sshObj.hostName,
          path,
        ]);

        break;
      case 'link':
        Process.run('bash', [
          "bash/delet/deletLink.sh",
          sshObj.userName,
          sshObj.hostName,
          path,
          '&'
        ]);

        break;
      default:
        break;
    }
  }

  opeinTerminal({required String path}) async {
    path = path.split(' ').join('\\ ');

    Process.run('bash',
        ["bash/opeinTerminal.sh", sshObj.userName, sshObj.hostName, path, '&']);
  }

  remotPath({required String remotPath}) async {
    remotPath = remotPath.split(' ').join('\\ ');

    String name =
        "./remotPath/${remotPath.substring(remotPath.lastIndexOf('/') + 1)}"
            .replaceAll("\\", "");

    await Process.run('mkdir', [
      "./$name",
    ]).then((value) => log(value.stderr));
    await Process.run(
      'x-terminal-emulator',
      [
        '-e',
        '/bin/bach -c "nohup sshfs ${sshObj.userName}@${sshObj.hostName}:$remotPath ${name.replaceAll(" ", "\\ ")}"',
      ],
    );

    Process.run('xdg-open', [name]);
  }
}
