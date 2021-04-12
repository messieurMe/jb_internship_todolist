import 'package:flutter/cupertino.dart';

// var myColorPalette = {
//   "Primary": _genColor("5c6bc0"),
//   "P-Light": _genColor("8e99f3"),
//   "P-Dark": _genColor("26418f")
// };

Color genColorString(String code, {int? op}) {
  switch (code) {
    case "Primaary":
      return _getColor("5c6bc0", op: op);
    case "P-Light":
      return _getColor("8e99f3",op: op);
    case "P-Dark":
      return _getColor("26418f",op: op);
    case "Secondary":
      return _getColor("7886cc",op: op);
    case "S-Light":
      return _getColor("aab6ff",op: op);
    case "S-Dark":
      return _getColor("47599b",op: op);

    default:
      return _getColor("ffffff");
  }
}

Color _getColor(String s, {int? op}) {
  return Color.fromARGB(op == null ? 255 : op, _hexToInt(s, 0, 2),
      _hexToInt(s, 2, 4), _hexToInt(s, 4, 6));
}

int _hexToInt(String hex, int from, int to) {
  return int.parse(hex.substring(from, to), radix: 16);
}
