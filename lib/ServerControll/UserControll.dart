import 'dart:convert';
import 'dart:developer';

import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/model/UserModel.dart';
import 'package:guiapp/widget/Dilog.dart';

class UserControll {
  List<UserModel> users = [];
  List<String> grups = [];

  List<String> allgrups = [];

  List<String> usermod = [];
  String errorGetUser = '';
  String errorGetGrupUser = '';
  String errorGetGrup = '';
  String errorUserMode = '';

  bool isloadingGetUser = false;
  bool isloadingGetGrupUser = false;
  bool isloadingGetGrup = false;

  Future<void> getUsers(Function update) async {
    try {
      isloadingGetUser = true;
      update();
      final out = await sshObj.client.run(
          'getent passwd | awk -F : \' \$3 >=1000 { print \$1 " " \$3 } \'');
      List<String> data = [];
      users = [];
      data = (utf8.decode(out)).toString().split('\n');
      data.removeLast();
      for (String item in data) {
        String name = item.split(' ')[0];
        String id = item.split(' ')[1];

        users.add(UserModel(name: name, id: id));
      }
      errorGetUser = '';
      isloadingGetUser = false;
      update();
    } catch (e) {
      errorGetUser = 'error get users :$e';
      isloadingGetUser = false;
      update();
    }
  }

  addUser(context, Function update) async {
    try {
      DialogWidgetUser(context, (name) async {
        try {
          log('echo td | sudo -S useradd $name');
          await sshObj.client.run('echo td | sudo -S useradd $name');
          update();
        } catch (e) {}
      }, "Enter your New User", "enter name");
    } catch (e) {}
  }

  getgrups(Function update) async {
    try {
      isloadingGetGrup = true;
      update();
      final out = await sshObj.client
          .run('getent group | awk -F : \' \$3 >= 1000 { print \$1 } \'');
      allgrups = [];

      allgrups = (utf8.decode(out)).toString().split('\n');
      allgrups.removeLast();
      errorGetGrup = '';
      isloadingGetGrup = false;
      update();
    } catch (e) {
      errorGetGrup = 'error get grups :$e';
      isloadingGetGrup = false;
      update();
    }
  }

  Future<void> getUsrtGrups(String id, Function update) async {
    try {
      isloadingGetGrupUser = true;
      update();
      final out = await sshObj.client.run('id -Gn $id');
      grups = [];
      grups = (utf8.decode(out)).toString().split(' ');
      final outmod = await sshObj.client.run(
          'getent passwd | awk -F : \' \$3 ==$id { print \$1 ":" \$2 ":" \$5 ":" \$6 ":" \$7 } \'');
      usermod = (utf8.decode(outmod)).toString().split('\n')[0].split(':');
      errorGetGrupUser = '';
      isloadingGetGrupUser = false;
      update();
    } catch (e) {
      errorGetGrupUser = 'error get users :$e';
      isloadingGetGrupUser = false;
      update();
    }
  }

  Future<List<dynamic>> deletgrups(String user, String group) async {
    try {
      final out = await sshObj.client
          .run('echo ${sshObj.password} | sudo -S gpasswd -d $user $group');
      grups = [];

      grups = (utf8.decode(out)).toString().split('\n');
      grups.removeLast();

      return [true, ''];
    } catch (e) {
      return [false, 'error delet grou : $e'];
    }
  }

  Future<bool> userMod(
      {required String name,
      String home = '',
      String shell = '',
      String command = '',
      String passwd = '',
      String group = ''}) async {
    try {
      final out = await sshObj.client.run(
          'echo ${sshObj.password} | sudo -S usermod  ${home.isEmpty ? '' : "-md $home"} ${shell.isEmpty ? '' : "-s $shell"} ${command.isEmpty ? '' : "-c $command"} ${passwd.isEmpty ? '' : "-p $passwd"} ${group.isEmpty ? '' : "-a -G $group"} $name  &> /tmp/e ; echo \$?');
      String data = (utf8.decode(out)).toString().split('\n')[0];
      if (data == '0') {
        errorUserMode = '';
        return true;
      }
      return false;
    } catch (e) {
      errorUserMode = 'error get users :$e';
      return false;
    }
  }
}

UserControll userControll = UserControll();
