import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/UI/Docker.dart';
import 'package:guiapp/UI/FolderManger.dart';
import 'package:guiapp/UI/Properties.dart';
import 'package:guiapp/UI/TextView.dart';
import 'package:guiapp/model/fileModel.dart';
import 'package:guiapp/widget/Loading.dart';
import 'package:guiapp/widget/viewFileWidget.dart';
import 'package:guiapp/widget/ShutDown.dart';
import 'package:guiapp/windows/ViewWindows.dart';
import 'package:guiapp/windows/mdiController.dart';
import 'package:guiapp/windows/mdiManager.dart';

class Desktop extends StatefulWidget {
  const Desktop({super.key});

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  late MdiController mdiController;
  String dd = '';
  @override
  void initState() {
    super.initState();
    mdiController = MdiController(() {
      setState(() {});
    });

    desktopControll.getFileData(() {
      setState(() {});
    });
  }

  bool isView = false;
  bool isMinimze = true;
  String title = '';
  bool isShutDown = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
        child: DragTarget(
            builder: (context, List<dynamic> candidata, List<dynamic> rejects) {
          if (candidata.isNotEmpty) {
            final snackBar = SnackBar(
              elevation: 7,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Oops!',
                message: candidata.toString(),
                contentType: ContentType.success,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('image/backimage.jpg'),
                    fit: BoxFit.cover)),
            child: Stack(
              children: [
                GestureDetector(
                  onSecondaryTapDown: (offset) async {
                    menuControll.menuBody(
                        context: context,
                        offset: offset.globalPosition,
                        path: desktopControll.getPath(),
                        update: () {
                          desktopControll.getFileData(() {
                            setState(() {});
                          });
                        });
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Loading(
                      error: desktopControll.error,
                      isloading: desktopControll.isload,
                      child: Wrap(
                        children: [
                          for (FileModel fils in desktopControll.fileModels)
                            SizedBox(
                                width: 100,
                                child: viewFileWidget(
                                    update: () {
                                      desktopControll.getFileData(() {
                                        setState(() {});
                                      });
                                    },
                                    onProperties: () {
                                      mdiController.addWindow(
                                          defaultWidth: 300,
                                          defaultHeight: 700,
                                          isProperties: true,
                                          title: "PROPERTiES",
                                          child: Properties(
                                              type: fils.type,
                                              path: fils.type == "link"
                                                  ? fils.linklocation ?? ""
                                                  : fils.location,
                                              size: fils.size));
                                    },
                                    name: fils.name,
                                    path: fils.location,
                                    type: fils.type,
                                    linklocation: fils.linklocation ?? '',
                                    onDoubleTap: () async {
                                      if (fils.type == 'dir') {
                                        dockerControll.docker["FOLDER MANGER"] =
                                            true;

                                        mdiController.addWindow(
                                            title: "FOLDER MANGER",
                                            child: FolderManger(
                                              path: fils.location,
                                              lastpath:
                                                  desktopControll.getPath(),
                                              newWindow: (
                                                  {required Widget app,
                                                  double defaultHeight = 500,
                                                  double defaultWidth = 700,
                                                  bool isProperties = false,
                                                  required String title}) {
                                                mdiController.addWindow(
                                                  title: title,
                                                  child: app,
                                                  isProperties: isProperties,
                                                  defaultHeight: defaultHeight,
                                                  defaultWidth: defaultWidth,
                                                );
                                              },
                                            ));
                                      } else if (fils.type == 'link') {
                                        bool isdir = await typesData.TypeFile(
                                            fils.linklocation ?? '');
                                        if (isdir) {
                                          dockerControll
                                              .docker["FOLDER MANGER"] = true;

                                          mdiController.addWindow(
                                              title: "FOLDER MANGER",
                                              child: FolderManger(
                                                path: fils.linklocation ?? "",
                                                lastpath:
                                                    desktopControll.getPath(),
                                                newWindow: (
                                                    {required Widget app,
                                                    double defaultHeight = 500,
                                                    double defaultWidth = 700,
                                                    bool isProperties = false,
                                                    required String title}) {
                                                  mdiController.addWindow(
                                                      title: title, child: app);
                                                },
                                              ));
                                        } else {
                                          bool isASCII =
                                              await typesData.TypeFileASCII(
                                                  fils.linklocation ?? '');
                                          if (isASCII) {
                                            try {
                                              final out = await sshObj.client.run(
                                                  'cat "${fils.linklocation!.replaceAll('\\', "")}"');
                                              String dataFile =
                                                  (utf8.decode(out)).toString();
                                              dockerControll
                                                  .docker["TEXT VIEW"] = true;

                                              mdiController.addWindow(
                                                  title: 'TEXT VIEW',
                                                  child: TextView(
                                                      path: fils.linklocation ??
                                                          "",
                                                      data: dataFile));
                                            } catch (e) {
                                              final snackBar = SnackBar(
                                                elevation: 7,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: AwesomeSnackbarContent(
                                                  title: 'Oops!',
                                                  message:
                                                      "Error red file : $e",
                                                  contentType:
                                                      ContentType.failure,
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(snackBar);
                                            }
                                          } else {
                                            final snackBar = SnackBar(
                                              elevation: 7,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title: 'Oops!',
                                                message:
                                                    "Error red file : the File is not ASCII",
                                                contentType:
                                                    ContentType.failure,
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                          }
                                        }
                                      } else {
                                        bool isASCII =
                                            await typesData.TypeFileASCII(
                                                fils.location);
                                        if (isASCII) {
                                          try {
                                            final out = await sshObj.client
                                                .run('cat "${fils.location}"')
                                                .timeout(
                                                    const Duration(seconds: 5),
                                                    onTimeout: () =>
                                                        Uint8List(0));
                                            String dataFile =
                                                (utf8.decode(out)).toString();
                                            dockerControll.docker["TEXT VIEW"] =
                                                true;
                                            mdiController.addWindow(
                                                title: 'TEXT VIEW',
                                                child: TextView(
                                                    path: fils.location,
                                                    data: dataFile));
                                          } catch (e) {
                                            final snackBar = SnackBar(
                                              elevation: 7,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title: 'Oops!',
                                                message: "Error red file : $e",
                                                contentType:
                                                    ContentType.failure,
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                          }
                                        } else {
                                          final snackBar = SnackBar(
                                            elevation: 7,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            content: AwesomeSnackbarContent(
                                              title: 'Oops!',
                                              message:
                                                  "Error red file : the File is not ASCII",
                                              contentType: ContentType.failure,
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);
                                        }
                                      }
                                    }))
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                              height: 70,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white.withOpacity(.4)),
                              child: Docker(
                                  viewWindows: (title) {
                                    setState(() {
                                      isView = true;
                                      isMinimze = false;
                                      this.title = title;
                                    });
                                  },
                                  viewMinimizeWindows: (title) {
                                    setState(() {
                                      isView = true;
                                      isMinimze = true;
                                      this.title = title;
                                    });
                                  },
                                  shutDown: () {
                                    setState(() {
                                      isShutDown = true;
                                    });
                                  },
                                  lastpath: desktopControll.getPath(),
                                  path: desktopControll.getHomePath(),
                                  mdiController: mdiController)),
                        ),
                      ),
                    ),
                  ),
                ),
                MdiManager(
                  mdiController: mdiController,
                ),
                isView
                    ? ViewWindows(
                        title: title,
                        mdiController: mdiController,
                        isMinimze: isMinimze,
                        select: (resizableWindow) {
                          if (isMinimze) {
                            mdiController.addDockertoWindow(
                                resizableWindow: resizableWindow);
                          } else {
                            mdiController.toTop(resizableWindow);
                          }

                          setState(() {
                            isView = false;
                          });
                        },
                        clear: () {
                          setState(() {
                            isView = false;
                          });
                        })
                    : const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                isShutDown
                    ? ShoutDown(
                        close: () {
                          setState(() {
                            isShutDown = false;
                          });
                        },
                      )
                    : Container()
              ],
            ),
          );
        }),
      ),
    );
  }
}
