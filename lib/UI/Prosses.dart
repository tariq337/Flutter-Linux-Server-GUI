import 'dart:async';
import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/widget/Loading.dart';

class Prosses extends StatefulWidget {
  const Prosses({super.key});

  @override
  State<Prosses> createState() => _ProssesState();
}

class _ProssesState extends State<Prosses> {
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await prossesControll.getProssers(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  String select = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black26,
        child: Loading(
            error: prossesControll.error,
            isloading: prossesControll.prosses.isEmpty,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white70,
                  ),
                  child: Row(
                    children: [
                      for (String name in prossesControll.title)
                        Expanded(child: Text(name)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: prossesControll.prosses.length,
                      itemBuilder: (context, num) {
                        int index = prossesControll.prosses.length - num - 1;
                        return InkWell(
                          onTap: () {
                            if (prossesControll.prosses.isNotEmpty) {
                              setState(() {
                                select = prossesControll.prosses[index];
                              });
                            }
                          },
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white54,
                            ),
                            child: Row(
                              children: [
                                for (String name in prossesControll
                                    .prosses[index]
                                    .split(' | '))
                                  Expanded(child: Text(name)),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                select.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(select),
                            ),
                            IconButton(
                              onPressed: () async {
                                bool chick = await prossesControll.killer(
                                    pid: select.split(" | ")[1]);
                                log(select.split(" | ")[1]);
                                if (chick) {
                                  prossesControll.getProssers(() {
                                    setState(() {
                                      select = '';
                                    });
                                  });
                                } else {
                                  final snackBar = SnackBar(
                                    elevation: 7,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Oops!',
                                      message: prossesControll.errorKill,
                                      contentType: ContentType.failure,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                }
                              },
                              tooltip: "SIGTERM Kills",
                              icon: const Icon(Icons.delete),
                              iconSize: 30,
                              color: const Color(0xFFD16464),
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              onPressed: () async {
                                bool chick = await prossesControll.killer(
                                    pid: "-SIGKILL ${select.split(" | ")[1]}");
                                log(select.split(" | ")[1]);
                                if (chick) {
                                  prossesControll.getProssers(() {
                                    setState(() {
                                      select = '';
                                    });
                                  });
                                } else {
                                  final snackBar = SnackBar(
                                    elevation: 7,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Oops!',
                                      message: prossesControll.errorKill,
                                      contentType: ContentType.failure,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                }
                              },
                              tooltip: "SIGKILL Kills",
                              icon: const Icon(Icons.delete_forever),
                              iconSize: 30,
                              color: const Color(0xFFFF0101),
                            )
                          ],
                        ),
                      )
                    : Container()
              ],
            )),
      ),
    );
  }
}
