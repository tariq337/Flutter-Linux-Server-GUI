import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/widget/Loading.dart';

class Properties extends StatefulWidget {
  String type, size, path;
  Properties({required this.type, required this.path, required this.size})
      : super(key: UniqueKey());

  @override
  State<Properties> createState() => _PropertiesState();
}

class _PropertiesState extends State<Properties> {
  int ownerValue = 0, groupValue = 0, othersValue = 0;
  bool loading = true;
  getpermissions() async {
    String data = (utf8.decode(await sshObj.client
            .run("ls -ld ${widget.path} | awk '{ print \$1}'")))
        .toString()
        .split('\n')[0];
    ownerValue = data.substring(1, 3).contains('rw')
        ? 6
        : data.substring(1, 3).contains('r')
            ? 4
            : data.substring(1, 3).contains('w')
                ? 2
                : 0;
    groupValue = data.substring(4, 6).contains('rw')
        ? 6
        : data.substring(4, 6).contains('r')
            ? 4
            : data.substring(4, 6).contains('w')
                ? 2
                : 0;

    othersValue = data.substring(7, 9).contains('rw')
        ? 6
        : data.substring(7, 9).contains('r')
            ? 4
            : data.substring(7, 9).contains('w')
                ? 2
                : 0;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpermissions();
  }

  bool changed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Loading(
        isloading: loading,
        error: '',
        child: Container(
          color: Colors.black12,
          alignment: Alignment.topCenter,
          child: RawScrollbar(
            thumbColor: Colors.black12.withOpacity(.1),
            radius: const Radius.circular(20),
            thickness: 20,
            thumbVisibility: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: ListView(
                children: [
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white70,
                    ),
                    child: Row(
                      children: [
                        const Expanded(flex: 2, child: Text("name:")),
                        Expanded(
                            flex: 8,
                            child: Text(widget.path
                                .substring(widget.path.lastIndexOf("/") + 1)
                                .replaceAll("\\", ""))),
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white70,
                    ),
                    child: Row(
                      children: [
                        const Expanded(flex: 2, child: Text("path:")),
                        Expanded(
                            flex: 8,
                            child: Tooltip(
                              message: widget.path,
                              child: Text(
                                widget.path.toString().length > 25
                                    ? '${widget.path.substring(0, 20)}..${widget.path.substring(widget.path.length - 3)}'
                                    : widget.path,
                              ),
                            )),
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white70,
                    ),
                    child: Row(
                      children: [
                        const Expanded(flex: 2, child: Text("type:")),
                        Expanded(flex: 8, child: Text(widget.type)),
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white70,
                    ),
                    child: Row(
                      children: [
                        const Expanded(flex: 2, child: Text("size:")),
                        Expanded(flex: 8, child: Text(widget.size)),
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white70,
                    ),
                    child: const Text(
                      "permissions:",
                    ),
                  ),
                  const Divider(),
                  Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white70,
                      ),
                      child: Row(
                        children: [
                          const Expanded(child: Text("Owner:")),
                          Expanded(
                            child: DropdownButton(
                              value: ownerValue,
                              onChanged: (value) {
                                setState(() {
                                  changed = true;
                                  ownerValue = int.parse(value.toString());
                                });
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: 4,
                                  child: Text('red'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('writ'),
                                ),
                                DropdownMenuItem(
                                  value: 6,
                                  child: Text('red&writ'),
                                ),
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text('none'),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white70,
                    ),
                    child: Row(
                      children: [
                        const Expanded(child: Text("Grup:")),
                        Expanded(
                          child: DropdownButton(
                            value: groupValue,
                            onChanged: (value) {
                              setState(() {
                                changed = true;

                                groupValue = int.parse(value.toString());
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 4,
                                child: Text('red'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('writ'),
                              ),
                              DropdownMenuItem(
                                value: 6,
                                child: Text('red&writ'),
                              ),
                              DropdownMenuItem(
                                value: 0,
                                child: Text('none'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white70,
                    ),
                    child: Row(
                      children: [
                        const Expanded(child: Text("others:")),
                        Expanded(
                          child: DropdownButton(
                            value: othersValue,
                            onChanged: (value) {
                              setState(() {
                                changed = true;

                                othersValue = int.parse(value.toString());
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 4,
                                child: Text('red'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('writ'),
                              ),
                              DropdownMenuItem(
                                value: 6,
                                child: Text('red&writ'),
                              ),
                              DropdownMenuItem(
                                value: 0,
                                child: Text('none'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  MaterialButton(
                    onPressed: () async {
                      try {
                        if (changed) {
                          String data = '';
                          if (widget.type == "dir") {
                            data = (utf8.decode(await sshObj.client.run(
                                    "chmod ${ownerValue + 1}${groupValue + 1}${othersValue + 1} ${widget.path}")))
                                .toString();
                          } else {
                            data = (utf8.decode(await sshObj.client.run(
                                    "chmod $ownerValue$groupValue$othersValue ${widget.path}")))
                                .toString();
                          }
                          if (data.trim().isEmpty) {
                            setState(() {
                              changed = false;
                            });
                          } else {
                            final snackBar = SnackBar(
                              elevation: 7,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Oops!',
                                message: "Error chmod ${widget.path} : $data",
                                contentType: ContentType.failure,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                        }
                      } catch (e) {}
                    },
                    color: changed ? Colors.greenAccent : Colors.grey,
                    child: const Text(
                      "APPLI",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
