import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'resizableWindow.dart';

class MdiController {
  MdiController(this._onUpdate);

  final List<ResizableWindow> _windows = List.empty(growable: true);
  final List<ResizableWindow> _dockerWindows = List.empty(growable: true);

  final VoidCallback _onUpdate;

  List<ResizableWindow> get windows => _windows;

  void addWindow(
      {required String title,
      required Widget child,
      bool isProperties = false,
      double defaultHeight = 500,
      double defaultWidth = 700}) {
    _createNewWindowedApp(
      title: title,
      app: child,
      isProperties: isProperties,
      defaultHeight: defaultHeight,
      defaultWidth: defaultWidth,
    );
  }

  List<ResizableWindow> getMiniMizeByTitle({required String title}) {
    List<ResizableWindow> data = [];
    for (ResizableWindow resizableWindow in _dockerWindows) {
      if (title == resizableWindow.title) {
        data.add(resizableWindow);
      }
    }
    return data;
  }

  List<ResizableWindow> getWindowsByTitle({required String title}) {
    List<ResizableWindow> data = [];
    for (ResizableWindow resizableWindow in _windows) {
      if (title == resizableWindow.title) {
        data.add(resizableWindow);
      }
    }
    return data;
  }

  bool isMiniMizeNotEmpty({required String title}) {
    for (ResizableWindow resizableWindow in _dockerWindows) {
      if (title == resizableWindow.title) {
        return true;
      }
    }
    return false;
  }

  bool isWindowsNotEmpty({required String title}) {
    for (ResizableWindow resizableWindow in _windows) {
      if (title == resizableWindow.title) {
        return true;
      }
    }
    return false;
  }

  void addAllDockertoWindow({required String title}) {
    for (ResizableWindow resizableWindow in _dockerWindows) {
      if (title == resizableWindow.title) {
        _windows.add(resizableWindow);
      }
    }
  }

  void toTop(ResizableWindow resizableWindow) {
    _windows.remove(resizableWindow);
    _windows.add(resizableWindow);
  }

  void addDockertoWindow({required ResizableWindow resizableWindow}) {
    _windows.add(resizableWindow);
    _dockerWindows.remove(resizableWindow);
  }

  void _createNewWindowedApp(
      {required String title,
      required Widget app,
      bool isProperties = false,
      double defaultHeight = 500,
      double defaultWidth = 700}) {
    ResizableWindow resizableWindow = ResizableWindow(
      title: title,
      body: app,
      isProperties: isProperties,
      defaultHeight: defaultHeight,
      defaultWidth: defaultWidth,
    );

    //Set initial position
    var rng = Random();
    resizableWindow.x = rng.nextDouble() * 100;
    resizableWindow.y = rng.nextDouble() * 100;

    //Init onWindowDragged
    resizableWindow.onWindowDragged = (dx, dy) {
      resizableWindow.x = resizableWindow.x! + dx;
      resizableWindow.y = resizableWindow.y! + dy;

      //Put on top of stack
      if (_windows.first == resizableWindow) {
        _windows.remove(resizableWindow);
        _windows.add(resizableWindow);
      }

      _onUpdate();
    };

    // Init onTopWindow
    resizableWindow.onTopWindow = () {
      if (_windows.first == resizableWindow) {
        _windows.remove(resizableWindow);
        _windows.add(resizableWindow);
        _onUpdate();
      }
    };

    //Init onCloseButtonClicked
    resizableWindow.onCloseButtonClicked = () {
      _windows.remove(resizableWindow);
      if (!isMiniMizeNotEmpty(title: resizableWindow.title)) {
        dockerControll.docker[resizableWindow.title] = false;
      }
      _onUpdate();
    };
    resizableWindow.onminMaiz = () {
      _windows.remove(resizableWindow);
      _dockerWindows.add(resizableWindow);
      _onUpdate();
    };
    //Add Window to List
    _windows.add(resizableWindow);

    // Update Widgets after adding the new App
    _onUpdate();
  }
}
