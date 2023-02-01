import 'dart:math';

List<List<T>> splitList<T>(List<T> source, int subSize) {
  List<List<T>> ret = [];
  for (var i = 0; i < source.length; i += subSize) {
    ret.add(source.sublist(i, min(i + subSize, source.length)));
  }

  return ret;
}

List<T> firstNOfList<T>(List<T> source, int size) {
  assert(size > 0);
  if (source.isEmpty) {
    return [];
  }
  return source.sublist(0, min(size, source.length));
}

///source will be modified!!!
List<T> extractFirstNOfList<T>(List<T> source, int size) {
  assert(size > 0);
  var list = firstNOfList(source, size);
  for (var i = 0; i < size && i < source.length; i++) {
    source.removeAt(i);
  }
  return list;
}
