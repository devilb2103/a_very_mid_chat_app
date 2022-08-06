import 'package:flutter/material.dart';
import 'package:rest_api_chat_app/customColorSwatch.dart';
import 'package:rest_api_chat_app/dynamicUserData.dart';

class chatPage extends StatelessWidget {
  const chatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Container(
                color: Colors.red,
                child: IconButton(
                  icon: Icon(Icons.abc),
                  onPressed: () => {debugPrint(dynamicUserData.name)},
                ),
              )),
        ),
      ),
    );
  }
}
