import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/FileMangerControll.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/UI/Properties.dart';
import 'package:guiapp/UI/TextView.dart';
import 'package:guiapp/model/fileModel.dart';
import 'package:guiapp/widget/Loading.dart';
import 'package:guiapp/widget/viewFileWidget.dart';

class FolderManger extends StatefulWidget {
  String path, lastpath;
  Function(
      {required String title,
      required Widget app,
      bool isProperties,
      double defaultHeight,
      double defaultWidth}) newWindow;

  FolderManger(
      {required this.path,
      required this.lastpath,
      required this.newWindow,
      super.key});

  @override
  State<FolderManger> createState() => _FolderMangerState();
}

class _FolderMangerState extends State<FolderManger> {
  FileMangerControll fileMangerControll = FileMangerControll();
  final TextEditingController _searchController = TextEditingController();

  getdata() async {
    fileMangerControll.addPath(path: widget.path, lastpath: widget.lastpath);
    _searchController.text = fileMangerControll.path;

    await fileMangerControll.getFileData(
        path: fileMangerControll.path,
        reload: false,
        Update: () {
          setState(() {});
        });
  }

  @override
  void initState() {
    super.initState();

    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black26,
        body: Container(
          child: Column(
            children: [
              Container(
                color: Colors.black38,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 5),
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () async {
                        if (_searchController.text != '/') {
                          await fileMangerControll.back(Update: () {
                            setState(() {});
                          });
                          _searchController.text = fileMangerControll.path;
                          if (_searchController.text.isEmpty) {
                            _searchController.text = '/';
                          }
                        }
                      },
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 20,
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () async {
                        await fileMangerControll.lastPath(Update: () {
                          setState(() {});
                        });
                        _searchController.text = fileMangerControll.path;
                        if (_searchController.text.isEmpty) {
                          _searchController.text = '/';
                        }
                      },
                      icon: const Icon(Icons.compare_arrows),
                      iconSize: 20,
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () async {
                        _searchController.text = fileMangerControll.path;
                        await fileMangerControll.getFileData(
                            path: fileMangerControll.path,
                            reload: true,
                            Update: () {
                              setState(() {});
                            });
                      },
                      icon: const Icon(Icons.refresh),
                      iconSize: 20,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: TextField(
                          onSubmitted: (v) async {
                            fileMangerControll.path = _searchController.text;
                            await fileMangerControll.getFileData(
                                path: fileMangerControll.path,
                                reload: false,
                                Update: () {
                                  setState(() {});
                                });
                          },
                          controller: _searchController,
                          decoration: InputDecoration(
                              hintText: "بحث",
                              hintStyle:
                                  const TextStyle(color: Color(0xff3c4046)),
                              border: InputBorder.none,
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () async {
                                  fileMangerControll.path =
                                      _searchController.text;
                                  await fileMangerControll.getFileData(
                                      path: fileMangerControll.path,
                                      reload: false,
                                      Update: () {
                                        setState(() {});
                                      });
                                },
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onSecondaryTapDown: (offset) async {
                      menuControll.menuBody(
                          context: context,
                          offset: offset.globalPosition,
                          path: _searchController.text,
                          update: () {
                            fileMangerControll.getFileData(
                                path: _searchController.text,
                                reload: true,
                                Update: () {
                                  setState(() {});
                                });
                          });
                    },
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Loading(
                              error: fileMangerControll.error,
                              isloading: fileMangerControll.isloading,
                              child: Wrap(
                                children: [
                                  for (FileModel fils
                                      in fileMangerControll.fileModels)
                                    SizedBox(
                                      width: 100,
                                      child: viewFileWidget(
                                        update: () {
                                          fileMangerControll.getFileData(
                                              path: _searchController.text,
                                              reload: true,
                                              Update: () {
                                                setState(() {});
                                              });
                                        },
                                        name: fils.name,
                                        path: fils.location,
                                        type: fils.type,
                                        onProperties: () {
                                          widget.newWindow(
                                            title: "PROPERTiES",
                                            app: Properties(
                                              type: fils.type,
                                              path: fils.type == "link"
                                                  ? fils.linklocation ?? ""
                                                  : fils.location,
                                              size: fils.size,
                                            ),
                                            defaultWidth: 300,
                                            defaultHeight: 700,
                                            isProperties: true,
                                          );
                                        },
                                        linklocation: fils.linklocation ?? '',
                                        onDoubleTap: () async {
                                          log(fils.location);
                                          if (fils.type == 'dir') {
                                            _searchController.text =
                                                fils.location;
                                            await fileMangerControll
                                                .getFileData(
                                                    path: fils.location,
                                                    reload: false,
                                                    Update: () {
                                                      setState(() {});
                                                    });
                                          } else if (fils.type == 'link') {
                                            bool isdir =
                                                await typesData.TypeFile(
                                                    fils.linklocation ?? '');
                                            if (isdir) {
                                              _searchController.text =
                                                  fils.linklocation ?? "";
                                              await fileMangerControll
                                                  .getFileData(
                                                      path: fils.linklocation ??
                                                          "",
                                                      reload: false,
                                                      Update: () {
                                                        setState(() {});
                                                      });
                                            } else {
                                              bool isASCII =
                                                  await typesData.TypeFileASCII(
                                                      fils.linklocation ?? "");
                                              if (isASCII) {
                                                try {
                                                  final out = await sshObj
                                                      .client
                                                      .run(
                                                          'cat "${fils.linklocation!}"')
                                                      .timeout(
                                                          const Duration(
                                                              seconds: 5),
                                                          onTimeout: () =>
                                                              Uint8List(0));
                                                  String dataFile =
                                                      (utf8.decode(out))
                                                          .toString();
                                                  dockerControll
                                                          .docker["TEXT VIEW"] =
                                                      true;
                                                  widget.newWindow(
                                                      title: "TEXT VIEW",
                                                      app: TextView(
                                                          path:
                                                              fils.linklocation ??
                                                                  "",
                                                          data: dataFile));
                                                } catch (e) {
                                                  final snackBar = SnackBar(
                                                    elevation: 7,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    content:
                                                        AwesomeSnackbarContent(
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
                                                  content:
                                                      AwesomeSnackbarContent(
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
                                                    .run(
                                                        'cat "${fils.location}"')
                                                    .timeout(
                                                        const Duration(
                                                            seconds: 5),
                                                        onTimeout: () =>
                                                            Uint8List(0));
                                                String dataFile =
                                                    (utf8.decode(out))
                                                        .toString();
                                                dockerControll
                                                    .docker["TEXT VIEW"] = true;
                                                widget.newWindow(
                                                    title: "TEXT VIEW",
                                                    app: TextView(
                                                        path: fils.location,
                                                        data: dataFile));
                                              } catch (e) {
                                                final snackBar = SnackBar(
                                                  elevation: 7,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content:
                                                      AwesomeSnackbarContent(
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
                                        },
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
