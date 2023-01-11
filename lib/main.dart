import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/cubit/favlist_count_cubit.dart';
import 'package:imdb_bloc/cubit/user_recently_viewed_cubit.dart';
import 'package:imdb_bloc/cubit/theme_mode_cubit_cubit.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_galleries_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_people_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_photos_cubit.dart';
import 'package:imdb_bloc/cubit/user_rated_cubit.dart';
import 'package:imdb_bloc/cubit/user_watch_list_cubit.dart';
import 'package:imdb_bloc/screens/settings/methods_collections.dart';
import 'package:imdb_bloc/singletons/user.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/dio/mydio.dart';
import 'cubit/user_list_screen_filter_cubit.dart';
import 'extensions/theme_extension.dart';
import 'package:imdb_bloc/utils/colors.dart';

import 'init.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await globalInit();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => ThemeModeCubit(),
    ),
    BlocProvider(
      create: (context) => UserCubit(),
    ),
    BlocProvider(
      create: (context) => UserFavGalleriesCubit(),
    ),
    BlocProvider(
      create: (context) => UserWatchListCubit(),
    ),
    BlocProvider(
      create: (context) => FavListCountCubit(),
    ),
    BlocProvider(
      create: (context) => UserRecentlyViewedCubit(),
    ),
    BlocProvider(
      create: (context) => UserFavPeopleCubit(),
    ),
    BlocProvider(
      create: (context) => UserListCubit(),
    ),
    BlocProvider(
      create: (context) => UserRatedCubit(),
    ),
    BlocProvider(
      create: (context) => UserFavPhotosCubit(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    initWithContext(context)
        .then((value) => userStreamController.stream.listen((event) {
              dp(' userStreamController.stream.listen...');
              if (event.token == '') {
                EasyLoading.showError('Not logged in or login expired!');
                logout(context);
              }
            }));
    networkErrorStreamController.stream.listen((event) {
      EasyLoading.showError('$event');
    });
  }

  @override
  Widget build(BuildContext context) {
    var timesNewRoman = 'TimesNewRoman';
    var lightTheme = ThemeData(
      // pageTransitionsTheme: pageTransitionsTheme,
      fontFamily: timesNewRoman,
      appBarTheme: const AppBarTheme(elevation: 0, color: Colors.transparent),
      primarySwatch:
          MaterialColor(ImdbColors.themeYellow.value, ImdbColors.yellow700Map),
      // backgroundColor: Colors.red,
      scaffoldBackgroundColor:
          ColorsUtils.darken(Theme.of(context).colorScheme.surface, 0.05),
      textTheme: TextTheme(
          headline4: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
              color: context.isDarkMode ? Colors.white : Colors.black)),
    );
    var buttonColor =
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return ImdbColors.themeYellow;
      }
      return Colors.grey;
    });

    var darkTheme = ThemeData(
      // pageTransitionsTheme: pageTransitionsTheme,
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.white),
      primarySwatch:
          MaterialColor(ImdbColors.themeYellow.value, ImdbColors.yellow700Map),
      fontFamily: timesNewRoman,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(elevation: 0, color: Colors.transparent),
      buttonTheme: ButtonThemeData(focusColor: ImdbColors.themeYellow),
      radioTheme: RadioThemeData(fillColor: buttonColor),
      checkboxTheme: CheckboxThemeData(fillColor: buttonColor),
      switchTheme: SwitchThemeData(
        thumbColor: buttonColor,
        trackColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return ImdbColors.themeYellow.withOpacity(.5);
          }
          return Colors.grey;
        }),
      ),
      textTheme: TextTheme(
          headline4: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
              color: context.isDarkMode ? Colors.white : Colors.black)),
    );
    return BlocBuilder<ThemeModeCubit, ThemeMode>(
      builder: (context, state) {
        return MaterialApp.router(
          scrollBehavior: AppScrollBehavior(),
          title: 'Imdb',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            // print('MaterialApp builder...');
            widget = EasyLoading.init()(context, widget);
            return widget;
          },
        );
      },
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
