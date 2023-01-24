import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/constants/config_constants.dart';
import 'package:imdb_bloc/enums/enums.dart';
import 'package:imdb_bloc/screens/all_images/all_images.dart';

import '../apis/apis.dart';
import '../apis/birth_date.dart';
import '../apis/user_fav_photos_api.dart';
import '../apis/user_lists.dart';
import '../beans/new_list_result_resp.dart';
import '../beans/user_fav_photos.dart';
import 'dart:io';

import '../screens/movies_list/movies_list.dart';
import '../screens/people_screen/person_list_screen.dart';

Future<void> showConfirmDialog(
  BuildContext context,
  String title,
  void Function() onConfirm,
) async {
  if (Platform.isIOS || Platform.isMacOS) {
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        actions: [
          CupertinoDialogAction(
            onPressed: onConfirm,
            isDestructiveAction: true,
            child: const Text(
              'Confirm',
            ),
          ),
          CupertinoDialogAction(
            onPressed: GoRouter.of(context).pop,
            isDestructiveAction: false,
            child: const Text(
              'Cancel',
            ),
          ),
        ],
      ),
    );
  } else {
    await showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: Text(title),
              actions: [
                TextButton(onPressed: onConfirm, child: const Text('Confirm')),
                TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Cancel'))
              ],
            )));
  }
}

SnackBar buildFavPhotoAddSuccessSnackBar(BuildContext context,
    {bool preventDuplicates = false, int length = 1}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content:
        Text('$length photo${length > 1 ? "s" : ""} added to your favorites'),
    action: SnackBarAction(
        label: 'See detail',
        onPressed: () {
          pushRoute(
              context: context,
              screen: const AllImagesScreen(
                  data: AllImagesScreenData(
                imageViewType: ImageViewType.userFavorite,
                subjectId: '',
                title: 'My Favs',
              )));
        }),
  );
}

Future<SnackBar> buildFavPhotoDelSuccessSnackbar(
    {required List<PhotoWithSubjectId> photosToUndo,
    required BuildContext context}) async {
  var length = photosToUndo.length;
  var s = length > 1 ? 's' : '';
  return SnackBar(
    // padding: const EdgeInsets.all(8.0),
    behavior: SnackBarBehavior.floating,
    content: Text('$length photo$s removed from your favorites'),
    action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          addUserFavPhotoApi(photosToUndo)
              .then((value) => updateUserFavPhotos(context));
          // updateUserFavPhotos(context);
        }),
  );
}

SliverToBoxAdapter buildSingleChildSliverList(Widget child) {
  return SliverToBoxAdapter(
    child: child,
  );
}

void pushRoute({required BuildContext context, required Widget screen}) {
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
    transitionDuration: transitionDuration,
  ));
}

Future<Widget?> getPeopleBornOnThisDateList(
    String birthDate, BuildContext context) async {
  debugPrint('birth date tap');
  var resp = await getPeopleFromBirthDateApi(birthDate);

  return PeopleListScreen(
      data: PeopleListScreenData(
    title: 'People born on $birthDate',
    ids: resp.ids,
    count: resp.count,
    onScrollReallyEnd: (ids) async {
      var newPids =
          await getPeopleFromBirthDateApi(birthDate, start: ids.length + 1);
      ids.addAll(newPids.ids);
    },
  ));
}

void goToPeopleBornOnThisDateList(String birthDate, BuildContext context) {
  pushRoute(
    context: context,
    screen: FutureBuilder(
      future: getPeopleBornOnThisDateList(birthDate, context),
      builder: (BuildContext context, snapshot) {
        return Center(
            child: snapshot.data ?? const CircularProgressIndicator());
      },
    ),
  );
}

Future<Widget?> getPeopleBornInThisPlaceList(
    String place, BuildContext context) async {
  if (place == '') {
    EasyLoading.showError('birth place is empty');
  }
  var resp = await getPeopleFromBirthPlaceApi(place);
  return PeopleListScreen(
      data: PeopleListScreenData(
    title: 'People born in $place',
    ids: resp.ids.toList(),
    count: resp.count,
    onScrollReallyEnd: (ids) async {
      var newPids =
          await getPeopleFromBirthPlaceApi(place, start: ids.length + 1);
      ids.addAll(newPids.ids);
    },
  ));
}

void goToPeopleBornInThisPlaceList(String place, BuildContext context) {
  pushRoute(
      context: context,
      screen: FutureBuilder(
          future: getPeopleBornInThisPlaceList(place, context),
          builder: ((context, snapshot) =>
              snapshot.data ??
              const Center(
                child: CircularProgressIndicator(),
              ))));
}

Future<Widget> getListCreatedByImdbUserScreen(
    String url, BuildContext context) async {
  var page = 1;

  var resp = await getListDetailApi(url);
  if (resp.result?.isPeopleList == true) {
    return PeopleListScreen(
        data: PeopleListScreenData(
            title: resp.result?.listName ?? '',
            ids: resp.result?.mids?.toList() ?? <String>[],
            count: resp.result?.count ?? 0,
            onScrollReallyEnd: ((ids) async {
              getListDetailApi(url, page: ++page).then((value) {
                ids.addAll(value.result?.mids ?? []);
              });
            })));
  } else if (resp.result?.isPictureList == true) {
    return AllImagesScreen(
        data: AllImagesScreenData(
            pictures: resp.result?.pictures,
            subjectId: '',
            title: resp.result?.listName ?? '',
            imageViewType: ImageViewType.listPicture));
  } else {
    var value = await getNewListMoviesApi(listUrl: url, page: page);

    if (value != null) {
      return MoviesListScreen(
          data: MoviesListScreenData(
              onScrollEnd: () {
                getNewListMoviesApi(listUrl: url, page: ++page).then((value2) {
                  value.movies?.addAll((value2?.movies ?? <MovieOfList?>[])
                      .where((element) => element != null)
                      .toList()
                      .cast<MovieOfList>());
                });
              },
              title: resp.result?.listName ?? '',
              newMovieListRespResult: value));
    }
  }

  return Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
    ),
    body: const Center(
      child: Icon(Icons.error),
    ),
  );
}

void gotoListCreatedByImdbUserScreen(BuildContext context, String url) {
  pushRoute(
    context: context,
    screen: FutureBuilder(
      future: getListCreatedByImdbUserScreen(url, context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data ??
            const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
      },
    ),
  );
}

void goHome(
  BuildContext context,
) {
  Navigator.popUntil(context, (route) => route.settings.name == '/');
}
