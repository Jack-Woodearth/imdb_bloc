import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_lists_card_on_you_screen_covers_state.dart';

class UserListsCardOnYouScreenCoversCubit extends Cubit<UserListsCardOnYouScreenCoversState> {
  UserListsCardOnYouScreenCoversCubit() : super(UserListsCardOnYouScreenCoversInitial());
}
