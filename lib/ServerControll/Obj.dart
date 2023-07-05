import 'package:guiapp/ServerControll/ControllSSh.dart';
import 'package:guiapp/ServerControll/DesktopControll.dart';
import 'package:guiapp/ServerControll/DockerControll.dart';
import 'package:guiapp/ServerControll/ProssesControll.dart';
import 'package:guiapp/ServerControll/TypesData.dart';
import 'package:guiapp/ServerControll/UserControll.dart';
import 'package:guiapp/ServerControll/menuManger.dart';
import 'package:guiapp/bash/bash.dart';

DesktopControll desktopControll = DesktopControll();

UserControll userControll = UserControll();
MenuControll menuControll = MenuControll();
ControllSSh sshObj = ControllSSh();

bashScript bash = bashScript();

TypesData typesData = TypesData();

DockerControll dockerControll = DockerControll();
ProssesControll prossesControll = ProssesControll();
