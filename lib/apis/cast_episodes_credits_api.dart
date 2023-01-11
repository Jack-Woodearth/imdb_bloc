import '../beans/new_cast_episode_credit.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

// Future<List<CastEpisodesCredit>?> getCastEpisodesCreditsApi(
//     String titleId, String nameId) async {
//   final url =
//       baseUrl + '/cast_episodes_credits?title_id=$titleId&name_id=$nameId';
//   final resp = await MyDio().dio.get(url);
//   return CastEpisodesCreditsResp.fromJson(resp.data).result;
// }

Future<List<NewCastEpisodeCredit>> getCastEpisodesCreditsApi(
    String titleId, String nameId) async {
  final url =
      baseUrl + '/cast_episodes_credits?title_id=$titleId&name_id=$nameId';
  final resp = await MyDio().dio.get(url);
  return NewCastEpisodeCreditResp.fromJson(resp.data).result ?? [];
}
