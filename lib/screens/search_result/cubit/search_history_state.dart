part of 'search_history_cubit.dart';

@immutable
class SearchHistoryState {
  final List<Item> items;

  const SearchHistoryState(this.items);
}

class Item {
  final String name;
  final String? id;
  final int timeMilliseconds;
  final bool isPeople;
  bool operator ==(Object other) {
    return (other is Item) &&
        other.id == id &&
        other.name == name &&
        other.isPeople == isPeople;
  }

  Item(
      {required this.name,
      this.id,
      required this.timeMilliseconds,
      required this.isPeople});

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'timeMilliseconds': timeMilliseconds,
        'isPeople': isPeople
      };
  static Item fromJson(Map<String, dynamic> json) => Item(
      name: json['name'],
      timeMilliseconds: json['timeMilliseconds'],
      isPeople: json['isPeople'],
      id: json['id']);
}

List<Map<String, dynamic>> serializeHistoryItems(List<Item> items) {
  final ret = <Map<String, dynamic>>[];
  for (var element in items) {
    ret.add(element.toJson());
  }
  return ret;
}

List<Item> deSerializeHistoryItems(String? jsonString) {
  try {
    List<Item> ret = [];
    var json = jsonDecode(jsonString ?? '');
    for (var item in json) {
      ret.add(Item.fromJson(item));
    }
    return ret;
  } catch (e) {
    return [];
  }
}
