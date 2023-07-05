import 'package:flutter/material.dart';
import 'package:guiapp/ServerControll/Obj.dart';
import 'package:guiapp/UI/UsersView.dart';
import 'package:guiapp/model/UserModel.dart';
import 'package:guiapp/widget/Loading.dart';

class UserManger extends StatefulWidget {
  const UserManger({super.key});

  @override
  State<UserManger> createState() => _UserMangerState();
}

class _UserMangerState extends State<UserManger> {
  @override
  void initState() {
    super.initState();
    getusers();
    getgroup();
  }

  getusers() async {
    await userControll.getUsers(() {
      setState(() {});
    });
  }

  getgroup() async {
    await userControll.getgrups(() {
      setState(() {});
    });
  }

  getgrups(UserModel user) async {
    await userControll.getUsrtGrups(user.id, () {
      setState(() {});
    });
  }

  int index = 0;

  bool _switch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'ALL Users',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Loading(
                        isloading: userControll.isloadingGetUser,
                        error: userControll.errorGetUser,
                        child: body(userControll.users))),
              ],
            ),
          ),
          Expanded(
              flex: 7,
              child: _switch
                  ? Loading(
                      error: userControll.errorGetGrupUser,
                      isloading: userControll.isloadingGetGrupUser,
                      child: UsersView(
                        grups: userControll.grups,
                        usermod: userControll.usermod,
                        clear: () {
                          setState(() {
                            _switch = false;
                          });
                        },
                        update: () async {
                          await getgrups(userControll.users[index]);
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.people,
                        size: 80,
                      ),
                    )),
        ],
      ),
    );
  }

  Widget body(List<UserModel> data) {
    return Column(
      children: [
        Expanded(
          child: RawScrollbar(
            thumbColor: Colors.black45,
            radius: const Radius.circular(20),
            thickness: 20,
            thumbVisibility: true,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    setState(() {
                      _switch = true;
                    });
                    this.index = index;
                    getgrups(data[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      data[index].name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 5),
        FloatingActionButton(
          onPressed: () async {
            userControll.addUser(context, () {
              getusers();
            });
          },
          backgroundColor: Colors.black38,
          tooltip: "add user",
          child: const Icon(Icons.add),
        )
      ],
    );
  }
}
