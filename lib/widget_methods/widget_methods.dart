import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import '../apis/apis.dart';
import '../apis/birth_date.dart';
import '../apis/user_fav_photos_api.dart';
import '../apis/user_lists.dart';
import '../beans/new_list_result_resp.dart';
import '../beans/user_fav_photos.dart';
import 'dart:io';

import '../screens/movies_list/movies_list.dart';
import '../screens/people_screen/person_list_screen.dart';
import '../utils/list_utils.dart';

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

SnackBar buildFavPhotoAddSuccessSnackBar(
    {bool preventDuplicates = false, int length = 1}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content:
        Text('$length photo${length > 1 ? "s" : ""} added to your favorites'),
    action: SnackBarAction(
        label: 'See detail',
        onPressed: () {
          //todo
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
          await addUserFavPhotoApi(photosToUndo);
          updateUserFavPhotos(context);
        }),
  );
}

SliverToBoxAdapter buildSingleChildSliverList(Widget child) {
  return SliverToBoxAdapter(
    child: child,
  );
}

void pushRoute({required BuildContext context, required Widget screen}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

Future<void> gotoMoviesListScreenLazyWithIds(
    List<String> movieIds, String name, BuildContext context) async {
  final count = movieIds.length;
  final idsCopy = movieIds.toList();
  var batch = firstNOfList(idsCopy, 20);
  if (batch.isEmpty) {
    return;
  }
  EasyLoading.show(maskType: EasyLoadingMaskType.clear);

  getNewListMoviesApi(mids: batch).then((value) {
    if (value != null) {
      extractFirstNOfList(idsCopy, batch.length);
      context.push('/movies_list',
          extra: MoviesListScreenData(
              title: name,
              newMovieListRespResult: value..count = count,
              onScrollEnd: () async {
                var batch2 = firstNOfList(idsCopy, 20);
                var newMovieListRespResult =
                    await getNewListMoviesApi(mids: batch2);
                extractFirstNOfList(idsCopy, batch2.length);
                if (newMovieListRespResult != null) {
                  value.movies?.addAll(
                      newMovieListRespResult.movies ?? <MovieOfList?>[]);
                }
              }));
    } else {
      EasyLoading.showError('get Filmography movies failed');
    }
    EasyLoading.dismiss();
  });
}

Future<void> goToPeopleBornOnThisDateList(
    String birthDate, BuildContext context) async {
  EasyLoading.show();
  debugPrint('birth date tap');
  getPeopleFromBirthDateApi(birthDate).then((resp) {
    EasyLoading.dismiss();

    context.push('/people_list',
        extra: PeopleListScreenData(
          title: 'People born on $birthDate',
          ids: resp.ids,
          count: resp.count,
          onScrollReallyEnd: (ids) async {
            var newPids = await getPeopleFromBirthDateApi(birthDate,
                start: ids.length + 1);
            ids.addAll(newPids.ids);
          },
        ));
  }).onError((error, stackTrace) {
    EasyLoading.showError('$error');
  });
}

Future<void> goToPeopleBornInThisYearList(
    String place, BuildContext context) async {
  if (place == '') {
    EasyLoading.showError('birth place is empty');
  }
  EasyLoading.show();
  debugPrint('birth place tap');
  getPeopleFromBirthPlaceApi('${place}').then((resp) {
    context.push('/people_list',
        extra: PeopleListScreenData(
          title: 'People born in ${place}',
          ids: resp.ids.toList(),
          count: resp.count,
          onScrollReallyEnd: (ids) async {
            var newPids = await getPeopleFromBirthPlaceApi('${place}',
                start: ids.length + 1);
            ids.addAll(newPids.ids);
          },
        ));
  }).onError((error, stackTrace) {
    EasyLoading.showError('$error');
  });
}

void goToListCreatedByImdbUser(String url, BuildContext context) {
  var page = 1;
  getListDetailApi(url).then((resp) {
    if (resp.result?.isPeopleList == true) {
      context.push('/people_list',
          extra: PeopleListScreenData(
              title: resp.result?.listName ?? '',
              ids: resp.result?.mids?.toList() ?? <String>[],
              count: resp.result?.count ?? 0,
              onScrollReallyEnd: ((ids) async {
                getListDetailApi(url, page: ++page).then((value) {
                  ids.addAll(value.result?.mids ?? []);
                });
              })));
    } else if (resp.result?.isPictureList == true) {
      //todo goto pictures list screen
    } else {
      getNewListMoviesApi(listUrl: url, page: page).then((value) {
        if (value != null) {
          context.push('/movies_list',
              extra: MoviesListScreenData(
                  onScrollEnd: () {
                    getNewListMoviesApi(listUrl: url, page: ++page)
                        .then((value2) {
                      value.movies?.addAll((value2?.movies ?? <MovieOfList?>[])
                          .where((element) => element != null)
                          .toList()
                          .cast<MovieOfList>());
                    });
                  },
                  title: resp.result?.listName ?? '',
                  newMovieListRespResult: value));
        }
      });
    }
  });
}
