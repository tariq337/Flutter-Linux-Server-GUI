import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guiapp/windows/mdiController.dart';
import 'package:guiapp/windows/resizableWindow.dart';

class ViewWindows extends StatefulWidget {
  String title;
  final MdiController mdiController;
  Function(ResizableWindow widget) select;
  Function() clear;
  bool isMinimze;
  ViewWindows(
      {required this.select,
      required this.mdiController,
      required this.title,
      required this.isMinimze,
      required this.clear,
      super.key});

  @override
  State<ViewWindows> createState() => _ViewWindowsState();
}

class _ViewWindowsState extends State<ViewWindows> {
  final PageController _pageController = PageController(
    viewportFraction: .5,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: RawScrollbar(
            thumbColor: Colors.black,
            radius: const Radius.circular(20),
            thickness: 20,
            thumbVisibility: true,
            child: ListView(
              children: [
                IconButton(
                  onPressed: () {
                    widget.clear();
                  },
                  icon: const Icon(Icons.clear),
                  iconSize: 60,
                  color: Colors.white,
                ),
                GridView.count(
                    primary: true,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: (widget.isMinimze
                            ? widget.mdiController
                                .getMiniMizeByTitle(title: widget.title)
                            : widget.mdiController.windows)
                        .map((e) {
                      return Transform.scale(
                        scale: .6,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              e.body,
                              InkWell(
                                onTap: () {
                                  widget.select(e);
                                },
                                child: Container(
                                  color: Colors.black12.withOpacity(.5),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList()),
              ],
            ),
          )),
    );
  }
}
