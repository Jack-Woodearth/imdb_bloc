import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imdb_bloc/cubit/user_fav_photos_cubit.dart';

import '../beans/user_fav_photos.dart';
import '../constants/config_constants.dart';
import '../enums/enums.dart';
import '../utils/dio/mydio.dart';
import '../widget_methods/widget_methods.dart';

Future<bool> addUserFavPhotoApi(List<PhotoWithSubjectId> photos) async {
  try {
    var path = '$baseUrl/user_fav_photos';
    var response = await MyDio()
        .dio
        .post(path, data: photos.map((e) => e.toJson()).toList());
    return response.data['code'] == 200;
  } catch (e) {
    return false;
  } finally {}
}

Future<bool> deleteUserFavPhotoApi(List<PhotoWithSubjectId> photos) async {
  EasyLoading.show();
  try {
    var path = '$baseUrl/user_fav_photos';
    var response = await MyDio()
        .dio
        .delete(path, data: photos.map((e) => e.toJson()).toList());
    return response.data['code'] == 200;
  } catch (e) {
    return false;
  } finally {
    EasyLoading.dismiss();
  }
}

Future<List<PhotoWithSubjectId>> listUserFavPhotoApi() async {
  try {
    var path = '$baseUrl/user_fav_photos';
    var response = await MyDio().dio.get(path);
    return UserFavPhotoResp.fromJson(response.data).result ?? [];
  } catch (e) {
    return [];
  }
}

Future<void> updateUserFavPhotos(BuildContext context) async {
  var read = context.read<UserFavPhotosCubit>();
  var photos = await listUserFavPhotoApi();
  read.set(photos);
}

bool isFavPhoto(PhotoWithSubjectId userFavPhoto, BuildContext context) {
  return context.read<UserFavPhotosCubit>().contains(userFavPhoto);
}

Future<void> toggleFavPhoto(
    PhotoWithSubjectId image, ImageViewType imageViewType,
    {GlobalKey<ScaffoldMessengerState>? key,
    ScaffoldMessengerState? scaffoldState,
    required BuildContext context}) async {
  var state = key?.currentState;
  state ??= scaffoldState;
  debugPrint('state :  $state');
  var of = Navigator.of(context);

  if (!isFavPhoto(image, context)) {
    var success = await addUserFavPhotoApi([image]);
    if (success) {
      try {
        state?.removeCurrentSnackBar();
        state?.showSnackBar(buildFavPhotoAddSuccessSnackBar(context));
      } catch (e) {
        EasyLoading.showSuccess('Photo added to your favorites');
      }
    }
  } else {
    var success = await deleteUserFavPhotoApi([image]);
    if (success) {
      if (imageViewType == ImageViewType.userFavorite) {
        of.pop();
      }
      try {
        state?.removeCurrentSnackBar();
        state?.showSnackBar(await buildFavPhotoDelSuccessSnackbar(
            photosToUndo: [image], context: context));
      } catch (e) {
        debugPrint('448888 e');
        EasyLoading.showSuccess('Photo deleted from your favorites');
      }
    }
  }

  await updateUserFavPhotos(context);
}
