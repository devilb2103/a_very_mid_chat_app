import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:rest_api_chat_app/Widgets/customTextField.dart';
import 'package:rest_api_chat_app/Widgets/messageStruct.dart';
import 'package:rest_api_chat_app/customColorSwatch.dart';
import 'package:rest_api_chat_app/dynamicUserData.dart';
import 'package:rest_api_chat_app/onlineUsers.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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

  final IO.Socket socket = IO.io(
      //"https://your-mother-chat-app.herokuapp.com",
      "http://localhost:5000",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

  ScrollController messageBoardController = ScrollController();
  TextEditingController messageBoxController = TextEditingController();

  late FocusNode messageBoxFocus;

  @override
  void initState() {
    super.initState();
    connect();
    socket.emit("signin", dynamicUserData.name);

    Timer(const Duration(milliseconds: 60), () {
      messageBoardController
          .jumpTo(messageBoardController.position.maxScrollExtent);
    });
    messageBoxFocus = FocusNode();
  }

  void disconnect() {
    socket.disconnect();
    onlineUsersRef.usernames.value.clear();
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
              // debugPrint(List<dynamic>.from(data)
              //     .toString()
              //     .substring(1, List<dynamic>.from(data).toString().length - 1)
              //     .split(',')
              //     .toString()),
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

    socket.onConnectError((data) => debugPrint("connection error"));
    socket.onDisconnect((data) => debugPrint("disconnected"));
  }

  void setMessage(String sender, String id, String message, String time) {
    debugPrint(id);
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
        ])
      ],
    );
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
