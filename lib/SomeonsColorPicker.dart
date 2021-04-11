import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatefulWidget {
  @override
  State createState() => ColorPickerWidgetState();
}

class ColorPickerWidgetState extends State {
  Color currentColor = Colors.amber;

  void changeColor(Color color) => setState(() => currentColor = color);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Color Picker Example'),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'HSV'),
              const Tab(text: 'Material'),
              const Tab(text: 'Block'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Center(
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          titlePadding: const EdgeInsets.all(0.0),
                          contentPadding: const EdgeInsets.all(0.0),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: currentColor,
                              onColorChanged: changeColor,
                              colorPickerWidth: 300.0,
                              pickerAreaHeightPercent: 0.7,
                              enableAlpha: true,
                              displayThumbColor: true,
                              showLabel: true,
                              paletteType: PaletteType.hsv,
                              pickerAreaBorderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight: const Radius.circular(2.0),
                              ),
                            ),
                          ));
                    },
                  );
                },
                child: const Text('Change me'),
                color: currentColor,
                textColor: useWhiteForeground(currentColor)
                    ? const Color(0xffffffff)
                    : const Color(0xff000000),
              ),
            ),
            Center(
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0.0),
                        contentPadding: const EdgeInsets.all(0.0),
                        content: SingleChildScrollView(
                          child: MaterialPicker(
                            pickerColor: currentColor,
                            onColorChanged: changeColor,
                            enableLabel: true,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Change me'),
                color: currentColor,
                textColor: useWhiteForeground(currentColor)
                    ? const Color(0xffffffff)
                    : const Color(0xff000000),
              ),
            ),
            Center(
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select a color'),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: currentColor,
                            onColorChanged: changeColor,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Change me'),
                color: currentColor,
                textColor: useWhiteForeground(currentColor)
                    ? const Color(0xffffffff)
                    : const Color(0xff000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}