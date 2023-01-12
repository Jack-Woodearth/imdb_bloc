import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../beans/seasons_info.dart';

part 'tv_seasons_info_state.dart';

class TvSeasonsInfoCubit extends Cubit<TvSeasonsInfoState> {
  TvSeasonsInfoCubit() : super(TvSeasonsInfoInitial());
  void set(SeasonsInfo? info) {
    emit(TvSeasonsInfoState(info));
  }
}
