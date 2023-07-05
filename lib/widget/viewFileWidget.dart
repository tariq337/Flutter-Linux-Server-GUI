import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';

class viewFileWidget extends StatefulWidget {
  Function onDoubleTap, onProperties, update;
  String path, type, name, linklocation;

  viewFileWidget({
    required this.update,
    required this.name,
    required this.onDoubleTap,
    required this.type,
    required this.linklocation,
    required this.path,
    required this.onProperties,
  }) : super(key: UniqueKey());

  @override
  State<viewFileWidget> createState() => _viewFileWidgetState();
}

class _viewFileWidgetState extends State<viewFileWidget> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    log(widget.path);
    return Tooltip(
      message: widget.name,
      child: MouseRegion(
        onEnter: (v) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (v) {
          setState(() {
            isHover = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.all(5),
          width: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isHover
                  ? Colors.black12.withOpacity(.2)
                  : Colors.transparent),
          child: GestureDetector(
            onDoubleTap: () {
              widget.onDoubleTap();
            },
            onSecondaryTapDown: (v) {
              log(widget.path);
              menuControll.menuFile(
                context: context,
                offset: v.globalPosition,
                open: widget.onDoubleTap,
                type: widget.type,
                update: () {
                  widget.update();
                },
                onProperties: () {
                  widget.onProperties();
                },
                path: widget.type == "link" ? widget.linklocation : widget.path,
              );
            },
            child: Column(children: <Widget>[
              SizedBox(
                height: 60,
                width: 60,
                child: Image.asset(
                  widget.type == 'dir'
                      ? 'image/folder.png'
                      : widget.type == 'link'
                          ? 'image/folder_link.png'
                          : 'image/file.png',
                ),
              ),
              Text(
                widget.name.toString().length > 15
                    ? '${widget.name.toString().substring(0, 7)}..${widget.name.toString().substring(widget.name.toString().length - 5)}'
                    : widget.name.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 15),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
