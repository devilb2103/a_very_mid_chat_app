library project.globals;

import 'package:flutter/cupertino.dart';

class onlineUsers with ChangeNotifier {
  ValueNotifier<List> usernames = ValueNotifier([]);
}

onlineUsers onlineUsersRef = new onlineUsers();
