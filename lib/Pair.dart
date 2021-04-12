library part;

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Pair.g.dart';

@JsonSerializable()
class Pair {
  String str = "";

  Pair(this.str, this.color);

  String color = Colors.pinkAccent.toString();

  Map<String, dynamic> toJson() => _$PairToJson(this);

  factory Pair.fromJson(Map<String, dynamic> json) => _$PairFromJson(json);
}
