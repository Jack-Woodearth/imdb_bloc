part of 'user_lists_card_on_you_screen_covers_cubit.dart';

@immutable
abstract class UserListsCardOnYouScreenCoversState {
  final List<String> covers;

  const UserListsCardOnYouScreenCoversState(this.covers);
}

class UserListsCardOnYouScreenCoversInitial
    extends UserListsCardOnYouScreenCoversState {
  const UserListsCardOnYouScreenCoversInitial() : super(const []);
}

class UserListsCardOnYouScreenCoversNormal
    extends UserListsCardOnYouScreenCoversState {
  const UserListsCardOnYouScreenCoversNormal(super.covers);
}
