import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:rest_api_chat_app/Widgets/customTextField.dart';
import 'package:rest_api_chat_app/Widgets/messageStruct.dart';
import 'package:rest_api_chat_app/customColorSwatch.dart';
import 'package:rest_api_chat_app/dynamicUserData.dart';
import 'package:rest_api_chat_app/onlineUsers.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:window_manager/window_manager.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class messageBoard extends StatefulWidget {
  messageBoard({Key? key}) : super(key: key);

  @override
  State<messageBoard> createState() => _messageBoardState();
}

class _messageBoardState extends State<messageBoard> {
  //
  List<messageStruct> messages = [];
  String lastTextBoxValue = "";

  final IO.Socket socket = IO.io(
      "https://your-mother-chat-app.herokuapp.com",
      //"http://localhost:5000",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

  ScrollController messageBoardController = ScrollController();
  TextEditingController messageBoxController = TextEditingController();

  late FocusNode messageBoxFocus;

  @override
  void initState() {
    messageBoxController.addListener(_messageBoxListener);
    super.initState();
    connect();
    socket.emit("signin", dynamicUserData.name);
    socket.emit("requestOldMessages");

    messageBoxFocus = FocusNode();

    //check for events triggering typing status to false
  }

  @override
  void dispose() {
    messageBoxController.removeListener(_messageBoxListener);
    super.dispose();
  }

  void disconnect() {
    socket.disconnect();
    onlineUsersRef.usernames.value.clear();
    onlineUsersRef.typers.value.clear();
    dynamicUserData.socketId = "";
    Navigator.pushNamed(context, '/');
  }

  void connect() {
    socket.connect();
    socket.onConnect((data) {
      debugPrint("connected");
      socket.on(
          "broadcast",
          (data) => setMessage(
              Map<String, dynamic>.from(data)
                  .entries
                  .elementAt(0)
                  .value
                  .toString(),
              Map<String, dynamic>.from(data)
                  .entries
                  .elementAt(1)
                  .value
                  .toString(),
              Map<String, dynamic>.from(data)
                  .entries
                  .elementAt(2)
                  .value
                  .toString(),
              Map<String, dynamic>.from(data)
                  .entries
                  .elementAt(3)
                  .value
                  .toString()));
    });
    socket.on(
        "userChange",
        (data) => {
              onlineUsersRef.usernames.value = List<dynamic>.from(data)
                  .toString()
                  .substring(1, List<dynamic>.from(data).toString().length - 1)
                  .split(',')
            });
    socket.on(
        "socketId",
        (data) => {
              dynamicUserData.socketId = data.toString(),
              debugPrint(dynamicUserData.socketId),
            });
    socket.on(
        "retrieveOldMessages",
        (data) => {
              recieveOldMessages(data),
            });
    socket.on(
        "typers",
        (data) => {
              onlineUsersRef.typers.value = List<dynamic>.from(data)
                  .toString()
                  .substring(1, List<dynamic>.from(data).toString().length - 1)
                  .split(','),
            });

    socket.onConnectError((data) => debugPrint("connection error"));
    socket.onDisconnect((data) => debugPrint("disconnected"));
  }

  void setTypingStatus(bool typing) {
    if (typing) {
      socket.emit("addTyper", dynamicUserData.name.toString());
    } else {
      socket.emit("removeTyper", dynamicUserData.name.toString());
    }
  }

  void _messageBoxListener() {
    if (lastTextBoxValue.length >= messageBoxController.text.length) {
      //debugPrint("Not Typing");
      setTypingStatus(false);
    } else {
      //debugPrint("Typing");
      setTypingStatus(true);
    }
    lastTextBoxValue = messageBoxController.text.toString();
  }

  void recieveOldMessages(List<dynamic> old) {
    List<messageStruct> currentMessages = messages;
    List<dynamic> oldMessages = old;
    List<messageStruct> newList = [];
    for (var i = 0; i < oldMessages.length; i++) {
      final String user = oldMessages[i]['user'];
      final String id = oldMessages[i]['id'];
      final String message = oldMessages[i]['message'];
      final String time = oldMessages[i]['time'];

      final item =
          messageStruct(sender: user, id: id, message: message, time: time);
      newList.add(item);
    }
    newList.addAll(currentMessages);
    messages = newList;
    setState(() {});
    scrollDownMessageBoard();
  }

  void setMessage(String sender, String id, String message, String time) {
    //debugPrint(id);
    if (id == "") {
      return;
    }
    setState(() {
      messages.add(
          messageStruct(sender: sender, id: id, message: message, time: time));
    });
    //debugPrint(DateTime.parse(time); -----------------------
    scrollDownMessageBoard();
  }

  void sendMessage(String msg) {
    if (messageBoxController.text.isEmpty) {
      return;
    }

    socket.emit("message", {
      'user': dynamicUserData.name,
      'id': dynamicUserData.socketId,
      'message': msg,
      'time': DateTime.now().toUtc().toString(),
    });

    messageBoxController.clear();
    messageBoxFocus.requestFocus();
    setTypingStatus(false);
  }

  void scrollDownMessageBoard() {
    double maxScroll = messageBoardController.position.maxScrollExtent;
    double currentScroll = messageBoardController.position.pixels;

    if (maxScroll - currentScroll <= 200) {
      Timer(const Duration(milliseconds: 60), () {
        messageBoardController
            .jumpTo(messageBoardController.position.maxScrollExtent);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              controller: messageBoardController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messageCard(
                  messages: messages,
                  index: index,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(children: [
          SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                splashColor: Colors.transparent,
                icon: const Icon(Icons.logout),
                onPressed: () => {disconnect()},
                color: customColorSwatches.swatch6,
              ),
            ),
          ),
          Expanded(
            child: customTextField(
                focusNode: messageBoxFocus,
                controller: messageBoxController,
                hintText: "Your message here",
                charLimit: 100000,
                onSubmit: (value) => {
                      sendMessage(messageBoxController.text.trim()),
                    }),
          ),
        ]),
        TypingStatusLine(),
      ],
    );
  }
}

class TypingStatusLine extends StatefulWidget {
  const TypingStatusLine({Key? key}) : super(key: key);

  @override
  State<TypingStatusLine> createState() => _TypingStatusLineState();
}

class _TypingStatusLineState extends State<TypingStatusLine> {
  @override
  Widget build(BuildContext context) {
    //
    String returnTypingStatusLine(ValueNotifier<List<dynamic>> typers) {
      String line = "";
      List<String> user = [];
      for (var i = 0; i < typers.value.length; i++) {
        user.add(typers.value[i].toString());
      }
      for (var i = 0; i < user.length; i++) {
        if (i == 0) {
          line += user[i];
        } else if (i == user.length - 1) {
          line += " and${user[i]}";
        } else {
          line += ",${user[i]}";
        }
      }

      //check for and
      //if true then more than 2 or more users, else only 1 user.
      //if true then as "are typing", else "is typing".
      if (line.length > 1) {
        if (line.contains("and")) {
          line += " are typing...";
        } else {
          line += " is typing...";
        }
      }

      return line;
    }

    return ValueListenableBuilder(
        valueListenable: onlineUsersRef.typers,
        builder: (context, value, _) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              returnTypingStatusLine(onlineUsersRef.typers),
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }
}

class messageCard extends StatelessWidget {
  const messageCard({
    Key? key,
    required this.messages,
    required this.index,
  }) : super(key: key);

  final int index;
  final List<messageStruct> messages;

  String getTimeStamp() {
    final DateTime time = DateTime.parse(messages[index].time).toLocal();
    final DateTime curTime = DateTime.now().toLocal();

    if (time.year == curTime.year) {
      if (time.month == curTime.month) {
        if (time.day == curTime.day) {
          return DateFormat()
              .add_jm()
              .format(DateTime.parse(messages[index].time).toLocal())
              .toString();
        } else {
          return DateFormat()
              .add_d()
              .add_MMM()
              .format(DateTime.parse(messages[index].time).toLocal())
              .toString();
        }
      } else {
        return DateFormat()
            .add_d()
            .add_MMM()
            .format(DateTime.parse(messages[index].time).toLocal())
            .toString();
      }
    } else {
      return DateFormat()
          .add_d()
          .add_MMM()
          .add_y()
          .format(DateTime.parse(messages[index].time).toLocal())
          .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: (messages[index].id == dynamicUserData.socketId)
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            left: (messages[index].id == dynamicUserData.socketId) ? 270 : 0,
            right: (messages[index].id == dynamicUserData.socketId) ? 0 : 270),
        child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: customColorSwatches.swatch3,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 5,
                        bottom: 0,
                      ),
                      child: Text(
                        messages[index].sender,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 30,
                        top: 20,
                        bottom: 20,
                      ),
                      child: Text(
                        messages[index].message,
                        style: TextStyle(
                          fontSize: 16,
                          color: customColorSwatches.swatch5,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, bottom: 10, right: 21),
                  child: Text(
                    (getTimeStamp()),
                    style: TextStyle(
                      fontSize: 9,
                      height: -0.5,
                      color: customColorSwatches.swatch6,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
