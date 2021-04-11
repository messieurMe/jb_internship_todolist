import 'Pair.dart';

class Item {
  String title = "";

  String getTitle() {
    return title;
  }

  var tags = <Pair>[];

  Item(this.title);

  // ignore: non_constant_identifier_names
  Item.ILoveDartContructors(this.title, List<Pair> newTags) {
    for (var i = 0; i < tags.length; i++) {
      if (tags[i].str.length != 0) {
        tags.add(newTags[i]);
      }
    }
  }
}