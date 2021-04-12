// GENERATED CODE - DO NOT MODIFY BY HAND

part of item;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  // var f****ngFLutterCantAutogenerateFileWithoutErrors = true;
  var itemFromJSON = Item(json['title'] as String);
  itemFromJSON
    ..tags = (json['tags'] as List<dynamic>)
        .map((e) => Pair(e['str'], e['color']))
        .toList();
  return itemFromJSON;
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'title': instance.title,
      'tags': instance.tags,
    };
