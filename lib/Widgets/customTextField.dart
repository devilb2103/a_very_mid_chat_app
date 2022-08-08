import 'package:flutter/material.dart';
import 'package:rest_api_chat_app/customColorSwatch.dart';

class customTextField extends StatelessWidget {
  customTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.onSubmit,
      this.charLimit,
      this.focusNode})
      : super(key: key);

  final String? hintText;
  final int? charLimit;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String value)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      autofocus: true,
      controller: controller,
      onSubmitted: onSubmit,
      maxLength: charLimit,
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
