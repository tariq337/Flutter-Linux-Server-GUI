import 'package:flutter/material.dart';

class ResizableWindow extends StatefulWidget {
  double? currentHeight, defaultHeight;
  double? currentWidth, defaultWidth;
  double? x;
  double? y;
  String title;
  Widget body;
  bool isProperties = false;

  Function(double, double)? onWindowDragged;
  Function()? onTopWindow;
  Function()? onminMaiz;

  VoidCallback? onCloseButtonClicked;

  ResizableWindow(
      {required this.title,
      required this.body,
      this.isProperties = false,
      this.defaultHeight = 500,
      this.defaultWidth = 700})
      : super(key: UniqueKey()) {
    currentHeight = defaultHeight;
    currentWidth = defaultWidth;
  }
  @override
  _ResizableWindowState createState() => _ResizableWindowState();
}

class _ResizableWindowState extends State<ResizableWindow> {
  final _headerSize = 50.0;
  final _borderRadius = 10.0;
  Size get size => MediaQuery.of(context).size;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //Here goes the same radius, u can put into a var or function
        borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
        child: Stack(
          children: [
            Column(
              children: [_getHeader(), _getBody()],
            ),
            Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragRight,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    opaque: true,
                    child: Container(
                      width: 4,
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragLeft,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    opaque: true,
                    child: Container(
                      width: 4,
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: _onHorizontalDragTop,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpDown,
                    opaque: true,
                    child: Container(
                      height: 4,
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: _onHorizontalDragBottom,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpDown,
                    opaque: true,
                    child: Container(
                      height: 4,
                    ),
                  ),
                )),
            Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onPanUpdate: _onHorizontalDragBottomRight,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.resizeUpLeftDownRight,
                    opaque: true,
                    child: SizedBox(
                      height: 6,
                      width: 6,
                    ),
                  ),
                )),
            Positioned(
                bottom: 0,
                left: 0,
                child: GestureDetector(
                  onPanUpdate: _onHorizontalDragBottomLeft,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.resizeUpRightDownLeft,
                    opaque: true,
                    child: SizedBox(
                      height: 6,
                      width: 6,
                    ),
                  ),
                )),
            Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onPanUpdate: _onHorizontalDragTopRight,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.resizeUpRightDownLeft,
                    opaque: true,
                    child: SizedBox(
                      height: 6,
                      width: 6,
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                top: 0,
                child: GestureDetector(
                  onPanUpdate: _onHorizontalDragTopLeft,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.resizeUpLeftDownRight,
                    opaque: true,
                    child: SizedBox(
                      height: 6,
                      width: 6,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _getHeader() {
    return GestureDetector(
      onPanUpdate: (tapInfo) {
        widget.onWindowDragged!(tapInfo.delta.dx, tapInfo.delta.dy);
      },
      onTap: () {
        widget.onTopWindow!();
      },
      child: Container(
        width: widget.currentWidth,
        height: _headerSize,
        color: Colors.black45,
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: Row(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(3)),
                    alignment: Alignment.center,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        widget.onCloseButtonClicked!();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  widget.isProperties
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 10),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(3)),
                          alignment: Alignment.center,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              widget.onTopWindow!();
                              onMaxMinMWindow();
                            },
                            child: const Icon(
                              Icons.square_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  widget.isProperties
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 10),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(3)),
                          alignment: Alignment.center,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              widget.onminMaiz!();
                            },
                            child: const Icon(
                              Icons.minimize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Positioned.fill(
                child: Center(
                    child: Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ))),
          ],
        ),
      ),
    );
  }

  _getBody() {
    return Container(
      width: widget.currentWidth,
      height: widget.currentHeight! - _headerSize,
      color: Colors.blueGrey,
      child: widget.body,
    );
  }

  void _onHorizontalDragLeft(DragUpdateDetails details) {
    setState(() {
      widget.currentWidth = widget.currentWidth! - details.delta.dx;
      if (widget.currentWidth! < widget.defaultWidth!) {
        widget.currentWidth = widget.defaultWidth;
      } else {
        widget.onWindowDragged!(details.delta.dx, 0);
      }
    });
  }

  void _onHorizontalDragRight(DragUpdateDetails details) {
    setState(() {
      widget.currentWidth = widget.currentWidth! + details.delta.dx;
      if (widget.currentWidth! < widget.defaultWidth!) {
        widget.currentWidth = widget.defaultWidth;
      }
    });
  }

  void _onHorizontalDragBottom(DragUpdateDetails details) {
    setState(() {
      widget.currentHeight = widget.currentHeight! + details.delta.dy;
      if (widget.currentHeight! < widget.defaultHeight!) {
        widget.currentHeight = widget.defaultHeight;
      }
    });
  }

  void _onHorizontalDragTop(DragUpdateDetails details) {
    setState(() {
      widget.currentHeight = widget.currentHeight! - details.delta.dy;
      if (widget.currentHeight! < widget.defaultHeight!) {
        widget.currentHeight = widget.defaultHeight;
      } else {
        widget.onWindowDragged!(0, details.delta.dy);
      }
    });
  }

  void _onHorizontalDragBottomRight(DragUpdateDetails details) {
    _onHorizontalDragRight(details);
    _onHorizontalDragBottom(details);
  }

  void _onHorizontalDragBottomLeft(DragUpdateDetails details) {
    _onHorizontalDragLeft(details);
    _onHorizontalDragBottom(details);
  }

  void _onHorizontalDragTopRight(DragUpdateDetails details) {
    _onHorizontalDragRight(details);
    _onHorizontalDragTop(details);
  }

  void _onHorizontalDragTopLeft(DragUpdateDetails details) {
    _onHorizontalDragLeft(details);
    _onHorizontalDragTop(details);
  }

  void onMaxMinMWindow() {
    setState(() {
      widget.x = 0;
      widget.y = 0;
      if (widget.currentWidth == size.width &&
          widget.currentHeight == size.height) {
        widget.currentWidth = size.width * .7;
        widget.currentHeight = size.height * .7;
      } else {
        widget.currentWidth = size.width;
        widget.currentHeight = size.height;
      }
    });
  }
}
