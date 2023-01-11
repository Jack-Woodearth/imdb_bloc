import '../beans/season_episodes.dart';
import '../beans/seasons_info.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<SeasonsInfo?> getSeasonsInfoApi(String mid) async {
  final url = baseUrl + '/seasons_info?mid=$mid';
  final resp = await BasicDio().dio.get(url);
  return SeasonsInfoResp.fromJson(resp.data).result;
}

Future<List<SeasonEpisode>?> getSeasonEpisodes(String mid, int season) async {
  final url = baseUrl + '/episodes?mid=$mid&season=$season';
  final resp = await MyDio().dio.get(url);
  final seasonEpisodesResp = SeasonEpisodesResp.fromJson(resp.data);
  return seasonEpisodesResp.result;
}
