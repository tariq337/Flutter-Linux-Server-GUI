//It converts the coding of data
import 'dart:convert';
//using ssh
import 'package:dartssh2/dartssh2.dart';

import 'package:guiapp/ServerControll/Obj.dart';

class ControllSSh {
  String error = '';
  late SSHClient client;
  late SSHSocket socket;
  late SftpClient sftp;
  String userName = '', password = '', hostName = '';

  Future<bool> connection(
      {required String userName,
      required String hostName,
      String password = ''}) async {
    try {
      //create socket
      socket = await SSHSocket.connect(
        hostName,
        22,
        //   timeout: const Duration(days: 30),
      );
      //connection to server
      client = SSHClient(
        socket,
        username: userName,
        onPasswordRequest: () => password,
      );
      //create sftp objekt
      sftp = await client.sftp();
      //get home path
      List<String> pwd = utf8.decode(await client.run('pwd')).split('\n');
      //pass home path to desktop
      desktopControll.setPath(path: pwd[0]);
      //save login data
      this.userName = userName;
      this.hostName = hostName;
      this.password = password;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    }
  }

  Future<bool> disConnection() async {
    try {
      sftp.close();
      client.close();
      socket.close();
      client.done;
      socket.done;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    }
  }
}
