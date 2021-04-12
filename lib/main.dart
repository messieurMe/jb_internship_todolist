import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:jb_internship_todolist/LifeCycleWatcher.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'Pair.dart';
import 'Item.dart';
import 'ColorResources.dart';
import 'LifeCycleWatcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: genColorString("S-Dark"),
        primaryColorDark: genColorString("S-Dark"),
        primaryColorLight: genColorString("S-Dark"),
      ),
      title: 'TODO List',
      home: MyHomePage(title: 'TODO List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String? title = "";

  MyHomePage({Key? key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var items = ValueNotifier(<Item>[]);

class _MyHomePageState extends State<MyHomePage> {
  void removeWidget(int index) {
    setState(() {
      items.value.removeAt(index);
    });
  }

  void _incrementCounter() {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('Add new item to TODOList'),
                    ),
                    body: ListView(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          maxLength: 15,
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'TODO',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      for (var i = 0; i < 3; i++)
                        Padding(
                          padding: EdgeInsets.all(3),
                          child: ValueListenableBuilder<Color>(
                              valueListenable: currentColor[i],
                              builder: (context, value, child) {
                                return TextField(
                                  maxLength: 10,
                                  controller: newTags[i],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Additional tag #${i + 1}',
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          {chooseColorFromPalette(i)},
                                      icon: Icon(
                                        Icons.palette,
                                        color: currentColor[i].value,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      Center(
                        child: ElevatedButton(
                          child: Text('Add'),
                          onPressed: addItemToList,
                        ),
                      ),
                    ]),
                  )));
    });
  }

  void chooseColorFromPalette(int tagNum) {
    // setState(() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            titlePadding: const EdgeInsets.all(0.0),
            contentPadding: const EdgeInsets.all(0.0),
            content: SingleChildScrollView(
              child: ColorPicker(
                showLabel: true,
                enableAlpha: true,
                colorPickerWidth: 300.0,
                displayThumbColor: true,
                pickerAreaHeightPercent: 0.7,
                paletteType: PaletteType.hsv,
                pickerColor: currentColor[tagNum].value,
                onColorChanged: colorChangeFunction[tagNum],
                pickerAreaBorderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(2.0),
                  topRight: const Radius.circular(2.0),
                ),
              ),
            ));
      },
    );
  }

  static var currentColor = [
    ValueNotifier(Color.fromRGBO(13, 255, 54, 0.7)),
    ValueNotifier(Color.fromRGBO(39, 42, 208, 0.712)),
    ValueNotifier(Color.fromRGBO(196, 40, 170, 0.7134)),
  ];

  static var colorChangeFunction = [
    (Color color) => {currentColor[0].value = color},
    (Color color) => {currentColor[1].value = color},
    (Color color) => {currentColor[2].value = color}
  ];

  TextEditingController nameController = TextEditingController();
  List<TextEditingController> newTags = [
    for (var i = 0; i < 3; i++) TextEditingController()
  ];

  void addItemToList() {
    setState(() {
      if (nameController.text.length > 0) {
        items.value.add(Item(nameController.text));
        nameController.clear();

        var lastIndex = items.value.length - 1;
        for (var i = 0; i < newTags.length; i++) {
          if (newTags[i].text.length != 0) {
            items.value[lastIndex].tags.add(
                Pair("#${newTags[i].text}", currentColor[i].value.toString()));
            newTags[i].clear();
          }
        }
      }
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Column(children: <Widget>[
        LifecycleWatcher(),
        Expanded(
          child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: ValueListenableBuilder<List<Item>>(
                valueListenable: items,
                builder: (context, value, child) {
                  return ReorderableListView.builder(
                    itemCount: items.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        key: ValueKey(index),
                        margin: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: genColorString("S-Dark", op: 170),
                                width: 5.0),
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(5),
                              tileColor: genColorString("S-Light", op: 100),
                              subtitle: Row(
                                children: [
                                  for (var i = 0;
                                      i < items.value[index].tags.length;
                                      i++)
                                    Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          color: Color(int.parse(
                                              items.value[index].tags[i].color
                                                  .split('(0x')[1]
                                                  .split(')')[0],
                                              radix: 16)),
                                          child: Text(
                                            items.value[index].tags[i].str,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              title: Text(
                                "${getItemString(index)}",
                                maxLines: 1,
                                softWrap: false,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.fade,
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => {removeWidget(index)},
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    onReorder: (int oldIndex, int newIndex) {
                      if (mounted) {
                        setState(() {
                          var first = items.value[oldIndex];
                          items.value.insert(newIndex, first);
                          items.value.removeAt(
                              oldIndex + (newIndex < oldIndex ? 1 : 0));
                        });
                      }
                    },
                  );
                },
              )),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: _incrementCounter,
        backgroundColor: genColorString("S-Light"),
      ),
    );
  }

  String getItemString(int index) {
    return items.value[index].title;
  }
}
