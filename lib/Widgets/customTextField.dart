import 'package:flutter/material.dart';
import 'package:rest_api_chat_app/customColorSwatch.dart';

class customTextField extends StatelessWidget {
  customTextField({Key? key, this.hintText, this.controller, this.onSubmit})
      : super(key: key);

  final String? hintText;
  final TextEditingController? controller;
  final Function(String value)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmit,
      maxLength: 15,
      style: TextStyle(color: customColorSwatches.swatch5),
      cursorColor: customColorSwatches.swatch5,
      decoration: InputDecoration(
        counterText: "",
        hintText: hintText,
        hintStyle: TextStyle(color: customColorSwatches.swatch7),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: customColorSwatches.swatch7)),
      ),
    );
  }
}
