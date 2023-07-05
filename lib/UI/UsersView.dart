// ignore_for_file: deprecated_member_use

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/widget/Dilog.dart';

class UsersView extends StatefulWidget {
  List<String> usermod;
  List<String> grups;

  Function() clear;
  Function() update;

  UsersView(
      {required this.usermod,
      required this.grups,
      required this.clear,
      required this.update,
      super.key});

  @override
  State<UsersView> createState() => _UsersState();
}

class _UsersState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: RawScrollbar(
        thumbColor: Colors.black45.withOpacity(.5),
        radius: const Radius.circular(20),
        thickness: 15,
        thumbVisibility: true,
        child: ListView(
          children: [
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onPressed: () {
                widget.clear();
              },
              icon: const Icon(Icons.arrow_back_outlined),
              iconSize: 40,
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "User Name : ${widget.usermod[0]}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Item("password : ${widget.usermod[1]}", () async {
                  DialogWidgetUser(context, (name) async {
                    bool iserror = await userControll.userMod(
                        name: widget.usermod[0], passwd: name);
                    if (!iserror) {
                      final snackBar = SnackBar(
                        elevation: 7,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Oops!',
                          message: "Error Enter password",
                          contentType: ContentType.failure,
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    } else {
                      widget.update();
                    }
                  }, "Enter your password", "Enter password..");
                }),
                Item("commend : ${widget.usermod[2]}", () async {
                  DialogWidgetUser(context, (name) async {
                    bool iserror = await userControll.userMod(
                        name: widget.usermod[0], command: name);
                    if (!iserror) {
                      final snackBar = SnackBar(
                        elevation: 7,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Oops!',
                          message: "Error Enter commend",
                          contentType: ContentType.failure,
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    } else {
                      widget.update();
                    }
                  }, "Enter your commend", "Enter commend..");
                }),
                Item("Home Path : ${widget.usermod[3]}", () async {
                  DialogWidgetUser(context, (name) async {
                    bool iserror = await userControll.userMod(
                        name: widget.usermod[0], home: name);
                    if (!iserror) {
                      final snackBar = SnackBar(
                        elevation: 7,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Oops!',
                          message: "Error Enter Home Path",
                          contentType: ContentType.failure,
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    } else {
                      widget.update();
                    }
                  }, "Enter your Home Path", "Enter Home Path..");
                }),
                Item("Sher Path : ${widget.usermod[4]}", () async {
                  DialogWidgetUser(context, (name) async {
                    bool iserror = await userControll.userMod(
                        name: widget.usermod[0], shell: name);
                    if (!iserror) {
                      final snackBar = SnackBar(
                        elevation: 7,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Oops!',
                          message: "Error Enter Sher Path",
                          contentType: ContentType.failure,
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    } else {
                      widget.update();
                    }
                  }, "Enter your Sher Path", "Enter Sher Path..");
                }),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'ALL Groups',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(spacing: 5, runSpacing: 5, children: [
                  for (String grup in widget.grups)
                    Chip(
                      label: Text(grup),
                      onDeleted: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Expanded(
                              child: AlertDialog(
                                title: const Text(
                                  'Delet',
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ),
                                content: Text(
                                  'Are you sure that you want to delete group :\n ( ${grup.trim()} )',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      List<dynamic> chick =
                                          await userControll.deletgrups(
                                              widget.usermod[0], grup.trim());

                                      if (chick[0]) {
                                        widget.update();
                                      } else {
                                        final snackBar = SnackBar(
                                          elevation: 7,
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          content: AwesomeSnackbarContent(
                                            title: 'Oops!',
                                            message: chick[1],
                                            contentType: ContentType.failure,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(snackBar);
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'ok',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'close',
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    )
                ]),
                const SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {
                    DialogWidgetgroups(context, (name) async {
                      bool iserror = await userControll.userMod(
                          name: widget.usermod[0],
                          group: name.toString().trim());
                      if (!iserror) {
                        final snackBar = SnackBar(
                          elevation: 7,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Oops!',
                            message: "Error add group $name",
                            contentType: ContentType.failure,
                          ),
                        );
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      } else {
                        widget.update();
                      }
                    }, "Enter your group", userControll.allgrups);
                  },
                  backgroundColor: Colors.black38,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container Item(String data, Function dialog) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(7),
        ),
        child: ListTile(
          onTap: () {
            dialog();
          },
          trailing: const Icon(
            Icons.border_color_outlined,
            color: Colors.white,
          ),
          leading: Text(
            data,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
