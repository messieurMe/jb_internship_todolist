import 'dart:ui';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jb_internship_todolist/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Item.dart';

class LifecycleWatcher extends StatefulWidget {
  @override
  _LifecycleWatcherState createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    initSharedPref();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      saveData();
    }
    if (state == AppLifecycleState.resumed) {
      getSavedData();
    }
  }

  static SharedPreferences? prefs;

  getSavedData() {
    if (items.value.length == 0) {
      if (prefs != null && prefs!.containsKey("items")) {
        String check = prefs!.getString("items")!;
        //if empty then check == '[]'
        if (check.length > 2) {
          items.value =
              List<Item>.from(jsonDecode(check).map((e) => Item.fromJson(e)));
        }
      }
    }
  }

  static saveData() async {
    var toSave = jsonEncode(items.value);
    //Useless check, but let it be
    if (prefs != null) {
      prefs!.setString("items", toSave);
    }
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    getSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0,
      width: 0,
    );
  }
}
