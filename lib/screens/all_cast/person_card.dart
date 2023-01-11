import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/config_constants.dart';
import '../../utils/common.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/my_network_image.dart';
import 'all_cast.dart';
import 'cast_episodes_credits_screen.dart';

class PersonCardOfFullCastScreenMainChild extends StatelessWidget {
  const PersonCardOfFullCastScreenMainChild({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ancestor = PersonCardOfFullCastScreen.of(context)!;
    final String? name = ancestor.name;
    final String? avatar = ancestor.avatar;
    final String? playAs = ancestor.playAs;
    final String? info = ancestor.info;
    final String personId = ancestor.personId;
    final String? type = ancestor.type;
    final String movieId = ancestor.movieId;
    final bool isTv = ancestor.isTvSeries;

    // print('PersonCard build');
    return InkWell(
      onTap: () {
        GoRouter.of(context).push('/person/$personId');
      },
      child: Card(
        child: SizedBox(
          height: 150,
          // width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Row(children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: SizedBox(
                        width: screenWidth(context) * 0.2,
                        child:

                            //  Image.file(File(
                            //     '/data/user/0/com.example.imdb/app_flutter/' +
                            //         getFilename(smallPic((avatar != null && avatar != ''
                            //             ? avatar!
                            //             : defaultAvatar))))),

                            Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyNetworkImage(
                            url: smallPic((avatar != null && avatar != ''
                                ? avatar
                                : defaultAvatar)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 3,
                    // width: screenWidth(context) * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (name ?? 'no name').trim(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text((playAs ?? '').trim()),
                          const SizedBox(
                            height: 5,
                          ),
                          info != null && info.isNotEmpty
                              ? Column(
                                  children: [
                                    SizedBox(child: Text((info).trim())),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          Text(capInitial('$type'))
                        ],
                      ),
                    ),
                  ),
                  const CastEpisodesInfoIcon(
                      // isTv: isTv,
                      // mid: movieId,
                      // pid: personId,
                      )
                ]),
              ),
              // const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonCardOfFullCastScreen extends InheritedWidget {
  const PersonCardOfFullCastScreen({
    Key? key,
    required this.child,
    this.name,
    this.avatar,
    this.playAs,
    this.info,
    required this.personId,
    required this.type,
    required this.movieId,
    required this.isTvSeries,
    // required this.contentType,
  }) : super(key: key, child: child);

  @override
  final Widget child;
  final String? name;
  final String? avatar;
  final String? playAs;
  final String? info;
  final String personId;
  final String? type;
  final String movieId;
  final bool isTvSeries;
  // final String? contentType;
  static PersonCardOfFullCastScreen? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PersonCardOfFullCastScreen>();
  }

  @override
  bool updateShouldNotify(PersonCardOfFullCastScreen oldWidget) {
    return oldWidget.personId != personId;
  }
}

class CastEpisodesInfoIcon extends StatelessWidget {
  const CastEpisodesInfoIcon({
    Key? key,
    // required this.isTv,
    // required this.pid,
    // required this.mid,
  }) : super(key: key);

  // final bool isTv;
  // final String pid;
  // final String mid;
  @override
  Widget build(BuildContext context) {
    final ancestor = PersonCardOfFullCastScreen.of(context)!;
    const size = 30.0;
    return Builder(builder: (context) {
      if (!ancestor.isTvSeries) {
        return const SizedBox(
          width: 0,
        );
      }

      return InkWell(
        onTap: () {
          context.push('/cast_episodes_credits',
              extra: CastEpisodesCreditsScreenData(
                mid: ancestor.movieId,
                pid: ancestor.personId,
                avatar: ancestor.avatar!,
                personName: ancestor.name!,
                movieTitle: AllCastScreenIW.of(context)!.title,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: size,
              width: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size / 2),
                  border: Border.all(width: 2)),
              child: const Icon(
                Icons.info,
                size: 17.5,
              )),
        ),
      );
    });
  }

  void _handleTap() {}
}
