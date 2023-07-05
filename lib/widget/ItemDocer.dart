import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';

class ItemDocker extends StatefulWidget {
  ItemDocker(
      {Key? key,
      required this.icon,
      required this.title,
      required this.addWindows,
      required this.viewWindows})
      : super(key: key);

  String icon;
  String title;
  Function(String title) viewWindows;
  Function(String title) addWindows;

  @override
  State<ItemDocker> createState() => _ItemDockerState();
}

class _ItemDockerState extends State<ItemDocker> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (v) {
        setState(() {
          isHover = v;
        });
      },
      onTap: () {
        if (dockerControll.docker[widget.title] ?? false) {
          widget.viewWindows(widget.title);
        } else {
          dockerControll.docker[widget.title] = true;
          widget.addWindows(widget.title);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: dockerControll.docker[widget.title] ?? false
                ? Colors.black38.withOpacity(.5)
                : isHover
                    ? Colors.white.withOpacity(.3)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(3)),
        alignment: Alignment.center,
        child: Image.asset(
          widget.icon,
          fit: BoxFit.scaleDown,
          height: 90,
          width: 90,
        ),
      ),
    );
  }
}
