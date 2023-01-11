import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/constants/config_constants.dart';
import 'package:imdb_bloc/cubit/user_list_screen_filter_cubit.dart';
import 'package:imdb_bloc/cubit/user_recently_viewed_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_galleries_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_people_cubit.dart';
import 'package:imdb_bloc/cubit/user_rated_cubit.dart';
import 'package:imdb_bloc/cubit/user_watch_list_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/user_cubit_cubit.dart';
import '../../singletons/user.dart';

void logout(BuildContext context) async {
  user = User();
  context.read<UserCubit>().setUser(user);
  context
      .read<UserWatchListCubit>()
      .setState(const UserWatchListState(movies: []));
  context.read<UserFavGalleriesCubit>().setGids([]);
  context
      .read<UserFavPeopleCubit>()
      .setState(const UserFavPeopleState(people: []));
  context.read<UserRecentlyViewedCubit>().set([]);
  context.read<UserRatedCubit>().set([]);
  context.read<UserListCubit>().reset();

  SharedPreferences.getInstance().then((value) => value.remove(userObjKey));
  // GoRouter.of(context).go('/');
}
