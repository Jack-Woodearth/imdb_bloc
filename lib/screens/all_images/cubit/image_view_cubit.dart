import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'image_view_state.dart';

class ImageViewCubit extends Cubit<ImageViewState> {
  ImageViewCubit() : super(ImageViewState(isScrollable: true, curIndex: 0));
  void set(ImageViewState state) {
    emit(state);
  }
}
