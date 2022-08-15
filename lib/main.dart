import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_chat_app/pages/chatPage.dart';
import 'package:rest_api_chat_app/pages/loginPage.dart';
import 'package:window_manager/window_manager.dart';
//import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  appWindow.minSize = const Size(900, 600);

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    //center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WindowBorder(
      color: Colors.transparent,
      width: 0,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //home: home(),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': ((context) => const loginPage()),
          '/chatPage': ((context) => const chatPage()),
        },
      ),
    );
  }
}

// class home extends StatelessWidget {
//   const home({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Container(
//         child: loginPage(), LOL
//       ),
//     );
//   }
// }
