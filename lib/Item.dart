library item;

import 'Pair.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'Item.g.dart';

@JsonSerializable()
class Item {
  Item(this.title);

  String title = "";

  List<Pair> tags = <Pair>[];

  // ignore: non_constant_identifier_names
  Item.ILoveDartContructors(this.title, List<Pair> newTags) {
    for (var i = 0; i < tags.length; i++) {
      if (tags[i].str.length != 0) {
        tags.add(newTags[i]);
      }
    }
  }

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
