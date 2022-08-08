import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rest_api_chat_app/customColorSwatch.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

//final ScrollController onlineListController1 = ScrollController();

class onlineList extends StatelessWidget {
  onlineList({Key? key, required this.controller}) : super(key: key);

  final ScrollController? controller;

  final List users = [
    'user 1',
    'user 2',
    'user 3',
    'user 4',
    'user 1',
    'user 2',
    'user 3',
    'user 4',
    'user 1',
    'user 2',
    'user 3',
    'user 4',
    'user 1',
    'user 2',
    'user 3',
    'user 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: ListView.builder(
            controller: ScrollController(),
            physics: const BouncingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return onlineListItem(
                users: users,
                index: index,
              );
            }),
      ),
    );
  }
}

class onlineListItem extends StatelessWidget {
  const onlineListItem({
    Key? key,
    required this.users,
    required this.index,
  }) : super(key: key);

  final List users;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            color: customColorSwatches.swatch4,
          ),
          height: 30,
          width: 250,
          child: Text(
            users[index],
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.75,
                color: customColorSwatches.swatch5,
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
