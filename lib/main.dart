import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'Pair.dart';
import 'ColorResources.dart';
import 'Item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO List',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: genColorString("S-Dark"),
          primaryColorLight: genColorString("S-Dark"),
          primaryColorDark: genColorString("S-Dark")),
      home: MyHomePage(title: 'TODO List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void removeWidget(int index) {
    setState(() {
      _items.removeAt(index);
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
                                      onPressed: () => {doThat(i)},
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

  void doThat(int tagNum) {
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
    ValueNotifier(Color.fromRGBO(13, 255, 54, 0.5)),
    ValueNotifier(Color.fromRGBO(39, 42, 208, 0.5019607843137255)),
    ValueNotifier(Color.fromRGBO(196, 40, 170, 0.5019607843137255))
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
        _items.add(Item(nameController.text));
        nameController.clear();

        var lastIndex = _items.length - 1;
        for (var i = 0; i < newTags.length; i++) {
          if (newTags[i].text.length != 0) {
            _items[lastIndex]
                .tags
                .add(Pair("#${newTags[i].text}", currentColor[i].value));
            newTags[i].clear();
          }
        }
      }
      Navigator.pop(context);
    });
  }

  var _items = <Item>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        Expanded(
            child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: ReorderableListView.builder(
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                key: ValueKey(index),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: genColorString("S-Dark", op: 170), width: 5.0),
                    borderRadius: BorderRadius.circular(6.0)),
                margin: EdgeInsets.all(9),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.all(5),
                      tileColor: genColorString("S-Light", op: 100),
                      // Color.fromRGBO(110, 150, 250, 0.8274509803921568),
                      subtitle: Row(
                        children: [
                          for (var i = 0; i < _items[index].tags.length; i++)
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  color: _items[index].tags[i].color,
                                  child: Text(
                                    _items[index].tags[i].str,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        "${getItemString(index)}",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
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
                  print("$oldIndex $newIndex");
                  var first = _items[oldIndex];
                  _items.insert(newIndex, first);
                  _items.removeAt(oldIndex + (newIndex < oldIndex ? 1 : 0));
                });
              }
            },
          ),
        )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: genColorString("S-Light"),
        child: Icon(Icons.add),
      ),
    );
  }

  String getItemString(int index) {
    print("$index ${_items[index].title}");
    return _items[index].title;
  }
}
