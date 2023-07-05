import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/UI/login.dart';

class ShoutDown extends StatefulWidget {
  Function() close;
  ShoutDown({required this.close, super.key});

  @override
  State<ShoutDown> createState() => _ShoutDownState();
}

class _ShoutDownState extends State<ShoutDown> {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  widget.close();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(.5)),
                  child: const Icon(
                    Icons.clear,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  await sshObj.client.run('shutdown -h now');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => true);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(.5)),
                  child: const Icon(
                    Icons.power_settings_new_outlined,
                    size: 50,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  await sshObj.disConnection();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => true);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(.5)),
                  child: const Icon(
                    Icons.logout,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          )),
    );
  }
}
