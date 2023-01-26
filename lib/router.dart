import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/apis/apis.dart';
import 'package:imdb_bloc/screens/all_cast/all_cast.dart';
import 'package:imdb_bloc/screens/all_cast/cast_episodes_credits_screen.dart';
import 'package:imdb_bloc/screens/all_images/all_images.dart';
import 'package:imdb_bloc/screens/event/event_history_screen.dart';
import 'package:imdb_bloc/screens/home/home_screen.dart';
import 'package:imdb_bloc/screens/movie_detail/awards_screen/AwardsScreen.dart';
import 'package:imdb_bloc/screens/movie_detail/movie_details_screen_lazyload.dart';
import 'package:imdb_bloc/screens/movie_detail/plot/plot_screen.dart';
import 'package:imdb_bloc/screens/movie_detail/rate_movie_screen.dart';
import 'package:imdb_bloc/screens/movie_detail/reviews_screen/all_reviews_screen.dart';
import 'package:imdb_bloc/screens/movie_detail/tv_seasons_info/tv_seasons_info_screen.dart';
import 'package:imdb_bloc/screens/movies_list/movies_list.dart';
import 'package:imdb_bloc/screens/people_screen/person_list_screen.dart';
import 'package:imdb_bloc/screens/person/person_detail_screen.dart';
import 'package:imdb_bloc/screens/person/person_full_bio_screen.dart';
import 'package:imdb_bloc/screens/poll/poll_screen.dart';
import 'package:imdb_bloc/screens/settings/settings_home.dart';
import 'package:imdb_bloc/screens/signin/imdb_signin.dart';
import 'package:imdb_bloc/screens/user_lists/add_list.dart';
import 'package:imdb_bloc/screens/user_lists/select_list.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';

import 'beans/details.dart';
import 'screens/movie_detail/movie_full_detail_screen.dart';
import 'screens/person/cubit/person_photos_cubit.dart';

class MyRouteObserver extends RouteObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    // dp('route pushed... last: ${previousRoute?.settings.name}(${previousRoute?.settings.arguments}) now: ${route.settings.name}(${route.settings.arguments}) ');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    // dp('route popped... now: ${previousRoute?.settings.name}(${previousRoute?.settings.arguments}) last: ${route.settings.name}(${route.settings.arguments}) ');

    super.didPop(route, previousRoute);
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  observers: [MyRouteObserver()],
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/details',
      builder: (BuildContext context, GoRouterState state) {
        return const Scaffold();
      },
    ),
    GoRoute(
      path: '/signin',
      builder: (BuildContext context, GoRouterState state) {
        return const ImdbSignInScreen();
      },
    ),
    GoRoute(
      path: '/title/:mid',
      builder: (BuildContext context, GoRouterState state) {
        var mid = state.params['mid']!;
        // updateRecentViewed(mid, context);
        return MovieFullDetailScreenLazyLoad(mid: mid);
      },
    ),
    GoRoute(
      path: '/title',
      name: '/title',
      builder: (BuildContext context, GoRouterState state) {
        // var movie = state.queryParams['movie']!;
        // var movieBean2 = MovieBean.fromJson(jsonDecode(movie));
        MovieBean movieBean2 = state.extra as MovieBean;
        // updateRecentViewed(movieBean2.id!, context);
        return MovieFullDetailScreen(movieBean: movieBean2);
      },
    ),
    GoRoute(
      path: '/person/:id',
      builder: (BuildContext context, GoRouterState state) {
        var personId = state.params['id']!;
        // updateRecentViewed(personId, context);
        return PersonDetailScreen(pid: personId);
      },
    ),
    GoRoute(
      path: '/person_bio/:id',
      name: '/person_bio/:id',
      builder: (BuildContext context, GoRouterState state) {
        return PersonFullBioScreen(
          pid: state.params['id']!,
        );
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsHomeScreen();
      },
    ),
    GoRoute(
      path: '/plot',
      name: '/plot',
      builder: (BuildContext context, GoRouterState state) {
        return PlotScreen(
            movieBeanStr: state.queryParams['movie']!,
            plot: state.queryParams['plot']!);
      },
    ),
    GoRoute(
      path: '/photos',
      name: '/photos',
      builder: (BuildContext context, GoRouterState state) {
        return AllImagesScreen(
          data: state.extra as AllImagesScreenData,
        );
      },
    ),
    GoRoute(
      path: '/title_rate',
      name: '/title_rate',
      builder: (BuildContext context, GoRouterState state) {
        RateMovieScreenData data = state.extra as RateMovieScreenData;
        return RateMovieScreen(data: data);
      },
    ),
    GoRoute(
      path: '/movies_list',
      name: '/movies_list',
      builder: (BuildContext context, GoRouterState state) {
        MoviesListScreenData data = state.extra as MoviesListScreenData;
        return MoviesListScreen(data: data);
      },
    ),
    GoRoute(
      path: '/poll/:id',
      // name: '/poll',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return PollScreen(
          pollId: state.params['id']!,
        );
      },
    ),
    GoRoute(
      path: '/cast_episodes_credits',
      name: '/cast_episodes_credits',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return CastEpisodesCreditsScreen(
          data: state.extra as CastEpisodesCreditsScreenData,
        );
      },
    ),
    GoRoute(
      path: '/all_cast',
      name: '/all_cast',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return AllCastScreen(
          data: state.extra as AllCastScreenData,
        );
      },
    ),
    GoRoute(
      path: '/people_list_lazy',
      name: '/people_list_lazy',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return PeopleListScreenLazy(
          data: state.extra as PeopleListScreenLazyData,
        );
      },
    ),
    GoRoute(
      path: '/people_list',
      name: '/people_list',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return PeopleListScreen(
          data: state.extra as PeopleListScreenData,
        );
      },
    ),
    GoRoute(
      path: '/add_list',
      name: '/add_list',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return const AddListScreen();
      },
    ),
    GoRoute(
      path: '/select_list/:subjectId',
      name: '/select_list/:subjectId',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return SelectListScreen(
          subjectId: state.params['subjectId']!,
        );
      },
    ),
    GoRoute(
      path: '/awards/:id',
      name: '/awards/:id',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return AwardsScreen(
          id: state.params['id']!,
        );
      },
    ),
    GoRoute(
      path: '/event_history/:id',
      name: '/event_history/:id',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return EventHistoryScreen(
          historyId: state.params['id']!,
        );
      },
    ),
    GoRoute(
      path: '/reviews',
      name: '/reviews',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return AllReviewsScreen(
          movieBean: state.extra as MovieBean,
        );
      },
    ),
    GoRoute(
      path: '/seasons_info',
      name: '/seasons_info',
      builder: (BuildContext context, GoRouterState state) {
        // MoviesListScreenData data = state.extra as MoviesListScreenData;
        return TvSeasonsInfoScreen(
          data: state.extra as TvSeasonsInfoScreenData,
        );
      },
    ),
  ],
);
