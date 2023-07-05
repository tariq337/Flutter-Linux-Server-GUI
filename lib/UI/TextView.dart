import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/widget/Loading.dart';

class TextView extends StatefulWidget {
  String data, path;

  TextView({
    super.key,
    required this.data,
    required this.path,
  });

  @override
  State<TextView> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  final TextEditingController fileView = TextEditingController();
  late CodeController codeController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileView.text = widget.data;
    codeController = CodeController(
      text: widget.data,
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  String error = '';
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Loading(
          error: error,
          isloading: isloading,
          child: CodeField(
            controller: codeController,
            expands: true,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            isloading = true;
          });
          try {
            await sshObj.client.run(
                'echo "${codeController.text}" > "${widget.path.replaceAll("\\", "")}"');
            setState(() {
              isloading = false;
              error = '';
            });
          } catch (e) {
            setState(() {
              isloading = false;
              error = 'error seve data :$e';
            });
          }
        },
        child: const Icon(Icons.add_to_drive_outlined),
      ),
    );
  }
}
