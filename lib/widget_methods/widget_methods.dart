import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../apis/user_fav_photos_api.dart';
import '../beans/user_fav_photos.dart';
import 'dart:io';

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
