// GENERATED CODE - DO NOT MODIFY BY HAND

part of part;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pair _$PairFromJson(Map<String, dynamic> json) {
  return Pair(
    json['str'] as String,
    json['color'] as String,
  );
}

Map<String, dynamic> _$PairToJson(Pair instance) => <String, dynamic>{
      'str': instance.str,
      'color': instance.color,
    };
