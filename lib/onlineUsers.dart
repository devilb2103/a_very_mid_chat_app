library project.globals;

import 'package:flutter/cupertino.dart';

class onlineUsers with ChangeNotifier {
  ValueNotifier<List> usernames = ValueNotifier([]);
  ValueNotifier<List> typers = ValueNotifier([]);
}

onlineUsers onlineUsersRef = new onlineUsers();
