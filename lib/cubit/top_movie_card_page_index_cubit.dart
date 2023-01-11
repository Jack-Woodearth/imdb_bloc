import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class TopMovieCardPageIndexCubit extends Cubit<int> {
  TopMovieCardPageIndexCubit() : super(0);
  void set(int index) {
    emit(index);
  }
}
