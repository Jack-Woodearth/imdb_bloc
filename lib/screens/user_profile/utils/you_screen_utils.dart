import 'package:flutter/material.dart';
import 'package:imdb_bloc/beans/new_list_result_resp.dart';

import '../../../beans/details.dart';
import '../../../cubit/filter_button_cubit.dart';
import '../../../utils/string/string_utils.dart';

Offset runtimeToMinutes(String runtime) {
  double max = 0;
  double min = 0;
  switch (runtime) {
    case '1 hour or less':
      min = 0;
      max = 60;
      break;
    case '1 to 2 hours':
      min = 60;
      max = 120;
      break;
    case '2 to 3 hours':
      min = 120;
      max = 180;
      break;
    case 'over 3 hours':
      min = 180;
      max = 999;
  }

  return Offset(min, max);
}

bool filtered(FilterButtonState state, MovieOfList? m) {
  if (m == null) {
    return false;
  }
  var filters = state.filters;
  // var m = MovieBean.fromMovieOfList(movie);
  var runtime = (double.tryParse(m.runtime ?? '') ?? 0.0);
  var year = 9999;
  try {
    year = int.parse(RegExp(r'\d{4}').firstMatch(m.yearRange ?? '')!.group(0)!);
  } catch (e) {}

  var rate = (double.tryParse(m.rate ?? '') ?? 0.0);
  return (filters[btnDisplayName(BtnNames.type)] == null ||
          m.contentType
                  ?.toLowerCase()
                  .contains(filters[btnDisplayName(BtnNames.type)]!) ==
              true) &&
      (filters[btnDisplayName(BtnNames.genres)] == null ||
          m.genres
                  ?.toLowerCase()
                  .contains(filters[btnDisplayName(BtnNames.genres)]!) ==
              true) &&
      (filters[btnDisplayName(BtnNames.runtime)] == null ||
          (runtimeToMinutes(filters[btnDisplayName(BtnNames.runtime)]!).dx <=
                  runtime &&
              runtimeToMinutes(filters[btnDisplayName(BtnNames.runtime)]!).dy >
                  runtime)) &&
      (filters[btnDisplayName(BtnNames.watchOptions)] == null ||
          (filters[btnDisplayName(BtnNames.watchOptions)] == 'comming soon' &&
              year > DateTime.now().year)) &&
      (filters[btnDisplayName(BtnNames.rate)] == null ||
          (int.parse(parseRate(filters[btnDisplayName(BtnNames.rate)].toString())
                      .split('-')[0]) <=
                  rate) &&
              int.parse(parseRate(filters[btnDisplayName(BtnNames.rate)].toString()).split('-')[1]) >
                  rate);
}

String btnDisplayName(BtnNames btn) {
  return capInitial(btn.toString().replaceAll('BtnNames.', ''));
}

String parseRate(String rate) {
  if (rate.toLowerCase().contains('less than')) {
    return '0-${RegExp(r'\d+').firstMatch(rate)?.group(0)}';
  } else if (rate.contains('+')) {
    return '${RegExp(r'\d+').firstMatch(rate)?.group(0)}-10';
  }
  return '0-10';
}

enum BtnNames {
  type,
  genres,
  watchOptions,
  runtime,
  releaseData,
  rate,
  myRate,
  language
}
