import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'content_type_state.dart';

class ContentTypeCubit extends Cubit<ContentTypeState> {
  ContentTypeCubit() : super(ContentTypeInitial());
  void setState(ContentTypeState state) {
    emit(state);
  }
}
