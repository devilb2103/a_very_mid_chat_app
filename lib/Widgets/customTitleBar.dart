import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:rest_api_chat_app/customColorSwatch.dart';

class customTitlebar extends StatelessWidget {
  const customTitlebar({super.key});

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Container(
        color: customColorSwatches.swatch2,
        child: Row(
          children: [
            Expanded(
                child: MoveWindow(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    height: 9,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: customColorSwatches.swatch7)),
                  ),
                ),
              ),
            )),
            windowButtons(),
          ],
        ),
      ),
    );
  }
}

class windowButtons extends StatelessWidget {
  windowButtons({super.key});

  var buttonColor = WindowButtonColors(
      iconNormal: customColorSwatches.swatch5,
      mouseOver: customColorSwatches.swatch4,
      mouseDown: customColorSwatches.swatch2);

  var closeButtonColor = WindowButtonColors(
      iconNormal: customColorSwatches.swatch5,
      mouseOver: Colors.blueAccent,
      mouseDown: customColorSwatches.swatch2);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColor),
        MaximizeWindowButton(colors: buttonColor),
        CloseWindowButton(colors: closeButtonColor),
      ],
    );
  }
}
