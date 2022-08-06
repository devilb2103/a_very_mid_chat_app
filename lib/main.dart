import 'package:flutter/material.dart';
import 'package:rest_api_chat_app/pages/chatPage.dart';
import 'package:rest_api_chat_app/pages/loginPage.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowMinSize(const Size(1280, 720));
  setWindowMaxSize(const Size(1280, 720));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat app',
      debugShowCheckedModeBanner: false,
      //home: home(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': ((context) => loginPage()),
        '/chatPage': ((context) => const chatPage()),
      },
    );
  }
}

// class home extends StatelessWidget {
//   const home({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Container(
//         child: loginPage(),
//       ),
//     );
//   }
// }
