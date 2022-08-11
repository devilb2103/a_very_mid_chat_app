import 'package:flutter/material.dart';
import 'package:rest_api_chat_app/Widgets/customTextField.dart';
import 'package:rest_api_chat_app/Widgets/dynamicMessageBoard.dart';
import 'package:rest_api_chat_app/Widgets/dynamicOnlineList.dart';
import 'package:rest_api_chat_app/customColorSwatch.dart';
import 'dart:async';

import 'package:rest_api_chat_app/dynamicUserData.dart';

class chatPage extends StatelessWidget {
  const chatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController onlineListController1 = ScrollController();

    return Scaffold(
      backgroundColor: customColorSwatches.swatch1,
      body: Center(
        child: Container(
          height: 720 - 100,
          width: 1280 - 100,
          //foregroundDecoration:
          //BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0))),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(21)),
            child: Row(
              children: <Widget>[
                //
                //left side
                Container(
                  color: customColorSwatches.swatch2,
                  height: double.infinity,
                  width: 270,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 30),
                        const Text(
                          "Online",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              height: 1,
                              color: Colors.lightBlueAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        onlineList(controller: onlineListController1),
                        const SizedBox(height: 20),
                        Divider(color: customColorSwatches.swatch4),
                        const SizedBox(height: 20),
                        Text(
                          "Connected as \n${dynamicUserData.name}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 1,
                              color: customColorSwatches.swatch6,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 21),
                      ],
                    ),
                  ),
                ),
                //
                //right side
                Container(
                  color: customColorSwatches.swatch4,
                  height: double.infinity,
                  width: 910,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: messageBoard(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
