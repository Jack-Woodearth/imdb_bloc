import 'package:flutter_bloc/flutter_bloc.dart';

class FavListCountCubit extends Cubit<int> {
  FavListCountCubit() : super(0);
  void set(int count) {
    emit(count);
  }
}
