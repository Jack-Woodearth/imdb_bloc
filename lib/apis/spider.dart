import 'package:dio/dio.dart';
import 'package:html/parser.dart';

import '../beans/watch_guide.dart';
import '../utils/dio/mydio.dart';
import 'proxy.dart';

Future<List<WatchGuide>> getWatchGuides() async {
  // var resp = await Dio().get(
  //     'https://m.imdb.com/what-to-watch/watch-guides/?ref_=watch_fanfav_tab');
  var resp = await getHttpThruProxy(
      'https://m.imdb.com/what-to-watch/watch-guides/?ref_=watch_fanfav_tab');
  List<WatchGuide> watchGuides = [];
  var document = parse(resp.data['result']);

  var subs =
      document.getElementsByClassName('ipc-page-grid ipc-page-grid--bias-left');

  for (var item in subs) {
    // print('*-----------*');
    WatchGuide watchGuide = WatchGuide()..lists = [];
    var typeH2s = item.getElementsByTagName('h2');
    for (var h2 in typeH2s) {
      if (h2.className == 'ipc-title__text') {
        watchGuide.type = h2.text.trim();
        break;
      }
    }

    if (item.getElementsByClassName('ipc-title__description').isEmpty) {
      continue;
    }
    watchGuide.description =
        item.getElementsByClassName('ipc-title__description').first.text.trim();

    var lists = item.getElementsByClassName(
        'ipc-slate-card ipc-slate-card--baseAlt ipc-slate-card--dynamic-width sc-d4fc4efa-0 jFbkTm imdb-editorial-single ipc-sub-grid-item ipc-sub-grid-item--span-4');
    for (var lista in lists) {
      watchGuide.lists!.add(Lists(
          title: lista
              .getElementsByClassName('ipc-slate-card__content')
              .first
              .text
              .trim(),
          url: lista
              .getElementsByClassName('ipc-slate-card__content')
              .first
              .getElementsByTagName('a')
              .first
              .attributes['href']));
    }

    // print(watchGuide.toJson());
    watchGuides.add(watchGuide);
  }
  // print(watchGuides.length);
  watchGuides.forEach((element) {
    print(element.toJson());
  });
  return watchGuides;
}

getFanFavorites() async {
  var resp = await MyDio().dio.get(
      'https://m.imdb.com/what-to-watch/fan-favorites/?ref_=watch_wchgd_tab');

  var document = parse(resp.data);
  // print(resp.data);
  var ids = document
      .getElementsByTagName('a')
      .map((e) => e.attributes['href'])
      .where((element) => element != null && element.startsWith('/title/tt'))
      .map((e) => RegExp(r'tt\d+').allMatches(e!).first.group(0))
      .toSet()
      .toList();
  print(ids);
  print(document.getElementsByTagName('a').length);
  print(document
      .getElementsByTagName('a')
      .map((e) => e.attributes['href'])
      .toList());
  return ids;
}
