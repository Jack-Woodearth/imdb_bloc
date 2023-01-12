import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loader_state.dart';

class LoaderCubit extends Cubit<LoaderState> {
  LoaderCubit() : super(LoaderStateLoaded());
  void beginLoading() {
    emit(LoaderStateLoading());
  }

  void cancelLoading() {
    emit(LoaderStateLoaded());
  }
}
