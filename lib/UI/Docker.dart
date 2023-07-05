import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/UI/FolderManger.dart';
import 'package:guiapp/UI/Prosses.dart';
import 'package:guiapp/UI/UserManger.dart';
import 'package:guiapp/widget/ItemDocer.dart';
import 'package:guiapp/windows/mdiController.dart';

class Docker extends StatefulWidget {
  MdiController mdiController;

  String path, lastpath;
  Function(String title) viewMinimizeWindows;
  Function(String title) viewWindows;
  Function() shutDown;

  Docker(
      {required this.lastpath,
      required this.path,
      required this.shutDown,
      required this.mdiController,
      required this.viewWindows,
      required this.viewMinimizeWindows,
      super.key});

  @override
  State<Docker> createState() => _DockerState();
}

class _DockerState extends State<Docker> {
  bool isHoverterm = false, isHovershutdown = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ItemDocker(
            icon: 'image/folder.png',
            title: "FOLDER MANGER",
            addWindows: (title) {
              widget.mdiController.addWindow(
                  title: title,
                  child: FolderManger(
                    path: widget.path,
                    lastpath: widget.lastpath,
                    newWindow: (
                        {required Widget app,
                        double defaultHeight = 500,
                        double defaultWidth = 700,
                        bool isProperties = false,
                        required String title}) {
                      widget.mdiController.addWindow(title: title, child: app);
                    },
                  ));
            },
            viewWindows: (title) {
              if (widget.mdiController.isMiniMizeNotEmpty(title: title)) {
                widget.viewMinimizeWindows(title);
              } else {
                widget.viewWindows(title);
              }
            }),
        const SizedBox(
          width: 10,
        ),
        ItemDocker(
            icon: 'image/user.png',
            title: "USER MANGER",
            addWindows: (title) {
              widget.mdiController
                  .addWindow(title: title, child: const UserManger());
            },
            viewWindows: (title) {
              if (widget.mdiController.isMiniMizeNotEmpty(title: title)) {
                widget.viewMinimizeWindows(title);
              } else {
                widget.viewWindows(title);
              }
            }),
        const SizedBox(
          width: 10,
        ),
        ItemDocker(
            icon: 'image/prosess.png',
            title: "PROSSER MANGER",
            addWindows: (title) {
              widget.mdiController
                  .addWindow(title: title, child: const Prosses());
            },
            viewWindows: (title) {
              if (widget.mdiController.isMiniMizeNotEmpty(title: title)) {
                widget.viewMinimizeWindows(title);
              } else {
                widget.viewWindows(title);
              }
            }),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () async {
            Process.run('bash', [
              "bash/opeinTerminal.sh",
              sshObj.userName,
              sshObj.hostName,
              desktopControll.getHomePath(),
              '&'
            ]);
          },
          onHover: (v) {
            setState(() {
              isHoverterm = v;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: isHoverterm
                    ? Colors.white.withOpacity(.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(3)),
            alignment: Alignment.center,
            child: Image.asset(
              'image/terminal.png',
              height: 90,
              width: 90,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () async {
            widget.shutDown();
          },
          onHover: (v) {
            setState(() {
              isHovershutdown = v;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: isHovershutdown
                    ? Colors.white.withOpacity(.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(3)),
            alignment: Alignment.center,
            child: Image.asset(
              'image/shutdown.png',
              height: 90,
              width: 90,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        if (widget.mdiController.isMiniMizeNotEmpty(title: "TEXT VIEW") ||
            widget.mdiController.isWindowsNotEmpty(title: "TEXT VIEW"))
          ItemDocker(
              icon: 'image/file.png',
              title: "TEXT VIEW",
              addWindows: (title) {},
              viewWindows: (title) {
                if (widget.mdiController.isMiniMizeNotEmpty(title: title)) {
                  widget.viewMinimizeWindows(title);
                } else {
                  widget.viewWindows(title);
                }
              }),
      ],
    );
  }
}
