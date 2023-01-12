part of 'tv_seasons_info_cubit.dart';

@immutable
class TvSeasonsInfoState {
  final SeasonsInfo? info;

  const TvSeasonsInfoState(this.info);
}

class TvSeasonsInfoInitial extends TvSeasonsInfoState {
  TvSeasonsInfoInitial() : super(null);
}
