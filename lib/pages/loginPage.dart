// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rest_api_chat_app/Widgets/customTextField.dart';
import 'package:rest_api_chat_app/Widgets/dynamicOnlineList.dart';
import 'package:rest_api_chat_app/customColorSwatch.dart';
import 'package:rest_api_chat_app/dynamicUserData.dart';

class loginPage extends StatelessWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    //
    //variables
    final nameController = TextEditingController();
    final ScrollController onlineListController2 = ScrollController();
    //
    //
    //functions
    void saveUserData() {
      if (nameController.text.length > 2) {
        dynamicUserData.name = nameController.text.trim();
        debugPrint(dynamicUserData.name);
        Navigator.pushNamed(context, '/chatPage');
      }
      nameController.text = "";
    }

    return Scaffold(
      backgroundColor: customColorSwatches.swatch1,
      body: Center(
        child: Container(
          height: 720 - 100,
          width: 1280 - 100,
          //foregroundDecoration:
          //BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0))),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(21)),
            child: Row(
              children: <Widget>[
                //
                //left side
                Container(
                  color: customColorSwatches.swatch2,
                  height: double.infinity,
                  width: 270,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 24),
                        Text(
                          "A",
                          style: TextStyle(
                            color: customColorSwatches.swatch5,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "VERY",
                          style: TextStyle(
                            color: customColorSwatches.swatch5,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "MID",
                          style: TextStyle(
                              height: 1,
                              color: customColorSwatches.swatch5,
                              fontSize: 75,
                              letterSpacing: 9,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "CHAT APP",
                          style: TextStyle(
                            height: 1,
                            color: customColorSwatches.swatch5,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(height: 30),
                        Divider(color: customColorSwatches.swatch4),
                        SizedBox(height: 10),
                        Text(
                          "Online",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              height: 1,
                              color: Colors.lightBlueAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 20),
                        onlineList(controller: onlineListController2),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 210,
                        child: customTextField(
                          hintText: "Name",
                          charLimit: 20,
                          controller: nameController,
                          onSubmit: (value) => {saveUserData()},
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => {saveUserData()},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueAccent),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Join Room",
                            style:
                                TextStyle(color: customColorSwatches.swatch5),
                          ),
                        ),
                      )
                    ],
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
