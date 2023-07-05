import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  bool isloading;
  String error;
  Widget child;

  Loading({required this.isloading, required this.error, required this.child});

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return const Center(child: CircularProgressIndicator());
    } else if (error.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: AwesomeSnackbarContent(
            title: 'Oops!',
            message: error,
            contentType: ContentType.failure,
          ),
        ),
      );
    }
    return child;
  }
}
