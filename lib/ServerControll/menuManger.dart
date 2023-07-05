import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/widget/Dilog.dart';

class MenuControll {
  String cpath = '', ctype = '';
  bool controllPast = false;

  past(String path) async {
    if (cpath.isNotEmpty) {
      if (controllPast) {
        bash.mov(src: cpath, dest: path);
      } else {
        bash.copy(isDir: ctype == 'dir', src: cpath, dest: path);
      }
      cpath = '';
      ctype = '';
    }
  }

  Future<void> new_foder(context, String path, Function update) async {
    try {
      DialogWidget(context, (name) async {
        try {
          await sshObj.client.run('mkdir "$path/${name.join(" ")}"');
          update();
        } catch (e) {
          log(e.toString());
        }
      }, "Enter your Folder Name");
    } catch (e) {}
  }

  Future<void> Rename(context, String path, Function update) async {
    try {
      DialogWidget(context, (name) async {
        try {
          log('mv "$path" "${path.substring(0, path.lastIndexOf("/") + 1)}${name.join(' ')}"');
          await sshObj.client.run(
              'mv "$path" "${path.substring(0, path.lastIndexOf("/") + 1)}${name.join(' ')}"');
          update();
        } catch (e) {
          log(e.toString());
        }
      }, "Enter your New Name");
    } catch (e) {}
  }

  Future<void> new_file(context, String path, Function update) async {
    try {
      DialogWidget(context, (name) async {
        try {
          await sshObj.client.run('touch "$path/${name.join(" ")}"');
          update();
        } catch (e) {
          log(e.toString());
        }
      }, "Enter your File Name");
    } catch (e) {}
  }

  menuBody(
      {required BuildContext context,
      required Offset offset,
      required String path,
      required Function update}) async {
    await showMenu(
            color: Colors.white70,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            context: context,
            position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, 0),
            items: [
              const PopupMenuItem(
                  value: 1,
                  child: Center(
                    child: Text('New foder'),
                  )),
              const PopupMenuItem(
                  value: 2,
                  child: Center(
                    child: Text('New file'),
                  )),
              PopupMenuItem(
                  value: 3,
                  child: Center(
                    child: Text(
                      'paste',
                      style: TextStyle(
                          color: cpath.isEmpty ? Colors.black38 : Colors.black),
                    ),
                  )),
              const PopupMenuItem(
                  value: 4,
                  child: Center(
                    child: Text(
                      'open in terminal',
                    ),
                  )),
              const PopupMenuItem(
                  value: 5,
                  child: Center(
                    child: Text(
                      'remot this path',
                    ),
                  )),
            ],
            elevation: 5)
        .then((value) async {
      if (value != null) {
        switch (value) {
          case 1:
            new_foder(context, path, update);

            break;
          case 2:
            new_file(context, path, update);
            break;
          case 3:
            past(path);
            break;
          case 4:
            bash.opeinTerminal(path: path);
            break;

          case 5:
            bash.remotPath(
              remotPath: path,
            );

            break;
        }
      }
    });
  }

  menuFile(
      {required BuildContext context,
      required Offset offset,
      required String path,
      required String type,
      required Function open,
      required Function onProperties,
      required Function update}) async {
    await showMenu(
            color: Colors.white70,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            context: context,
            position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, 0),
            items: [
              const PopupMenuItem(
                  value: 1,
                  child: Center(
                    child: Text('open'),
                  )),
              const PopupMenuItem(
                  value: 9,
                  child: Center(
                    child: Text('Rename'),
                  )),
              const PopupMenuItem(
                  value: 2,
                  child: Center(
                    child: Text('cut'),
                  )),
              const PopupMenuItem(
                  value: 3,
                  child: Center(
                    child: Text('copy'),
                  )),
              if (type == "dir")
                PopupMenuItem(
                    value: 4,
                    child: Center(
                      child: Text(
                        'paste',
                        style: TextStyle(
                            color:
                                cpath.isEmpty ? Colors.black38 : Colors.black),
                      ),
                    )),
              const PopupMenuItem(
                  value: 5,
                  child: Center(
                    child: Text('delet'),
                  )),
              if (type == "dir")
                const PopupMenuItem(
                    value: 6,
                    child: Center(
                      child: Text('remot this path'),
                    )),
              if (type != "link")
                const PopupMenuItem(
                    value: 7,
                    child: Center(
                      child: Text('Download'),
                    )),
              const PopupMenuItem(
                  value: 8,
                  child: Center(
                    child: Text('Properties'),
                  )),
            ],
            elevation: 5)
        .then((value) {
      if (value != null) {
        switch (value) {
          case 1:
            open();

            break;
          case 9:
            Rename(context, path, update);
            break;
          case 2:
            cpath = path;
            ctype = type;

            controllPast = true;

            break;
          case 3:
            cpath = path;
            ctype = type;

            controllPast = false;
            break;
          case 4:
            past(path);

            break;

          case 5:
            bash.delet(type: type, path: path);
            break;
          case 6:
            bash.remotPath(remotPath: path);

            break;
          case 7:
            bash.donlowd(src: path);
            break;
          case 8:
            onProperties();
            break;
        }
      }
    });
  }
}
