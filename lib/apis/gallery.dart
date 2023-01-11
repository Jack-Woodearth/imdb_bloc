import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../beans/gallery.dart';
import '../constants/config_constants.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';

Future<ImdbGallery?> getPeopleAndMovieOfGalleryApi(String galleryId) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  final key = 'getPeopleAndMovieOfGalleryApi:$galleryId';
  var string = sharedPreferences.getString(key);
  try {
    return ImdbGallery.fromJson(jsonDecode(string!));
  } catch (e) {}
  try {
    var resp = await MyDio()
        .dio
        .get('$baseUrl/gallery/people_and_movie?uuid=$galleryId');
    ImdbGallery? imdbGallery;
    if (reqSuccess(resp)) {
      imdbGallery = ImdbGallery.fromJson(resp.data['result']);
      sharedPreferences.setString(key, jsonEncode(imdbGallery.toJson()));
    }
    return imdbGallery;
  } catch (e) {
    return null;
  }
}
