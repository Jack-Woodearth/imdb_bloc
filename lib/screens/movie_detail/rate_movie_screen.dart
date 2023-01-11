import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/apis/watchlist_api.dart';
import 'package:imdb_bloc/cubit/user_watch_list_cubit.dart';
import 'package:imdb_bloc/utils/colors.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';

import '../../apis/apis.dart';
import '../../beans/details.dart';
import '../../cubit/user_rated_cubit.dart';
import '../../utils/dio/dio.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/blured.dart';
import '../../widgets/blured_background.dart';
import '../../widgets/imdb_button.dart';
import '../../widgets/my_network_image.dart';

class RateMovieScreenData {
  final MovieBean movieBean;
  final int? userRate;

  RateMovieScreenData({required this.movieBean, this.userRate});
}

class RateMovieScreen extends StatefulWidget {
  const RateMovieScreen({Key? key, required this.data}) : super(key: key);
  final RateMovieScreenData data;

  @override
  State<RateMovieScreen> createState() => _RateMovieScreenState();
}

class _RateMovieScreenState extends State<RateMovieScreen> {
  bool? _removeFromWatchListCheck = false;
  @override
  void initState() {
    super.initState();
    // getRate();
  }

  @override
  void didUpdateWidget(covariant RateMovieScreen oldWidget) {
    if (oldWidget.data.movieBean.id != widget.data.movieBean.id) {
      // getRate();
    }
    super.didUpdateWidget(oldWidget);
  }

  late int _rate = widget.data.userRate ?? 0;

  final bool _userRated = false;
  late final int _originRateBak = widget.data.userRate ?? 0;
  // _getRate() async {
  //   int? tmp;

  //   tmp = await getUserPersonalRateApi(widget.data.movieBean.id!);
  //   // var tmp = userPersonalRateController.map[widget.movieBean.id!];//todo
  //   if (tmp != null && tmp != 0) {
  //     _rate = tmp;
  //     _userRated = true;
  //     originRateBak = tmp;
  //   }

  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_originRateBak == _rate) {
          return true;
        }
        _showWarnDialog(context);
        return false;
      },
      child: BlurredBackground(
        backgroundImageUrl: smallPic(widget.data.movieBean.cover),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          if (_originRateBak == _rate) {
                            // Get.back();
                            GoRouter.of(context).pop();
                            return;
                          }
                          _showWarnDialog(context);
                          // Get.back();
                        },
                        child: const Icon(Icons.close)),
                    Blurred(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: ColorsUtils.secondaryBlackOrWhite(context)
                            .withOpacity(0.15),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                    color: Colors.white,
                                    width: 30,
                                    height: 30,
                                    child: const Center(
                                        child: Icon(Icons.share)))),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('share'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: MyNetworkImage(
                            url: bigPic(widget.data.movieBean.cover)),
                      ),
                    ),
                    Opacity(
                      opacity: _rate == 0 ? 0 : 0.8,
                      child: Container(
                        width: 200,
                        height: 300,
                        color: Colors.black,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                      child: Text(
                        '$_rate',
                        key: ValueKey(_rate),
                        style:
                            const TextStyle(fontSize: 150, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                          text: 'How would you rate ',
                        ),
                        TextSpan(
                            text: "${widget.data.movieBean.title}",
                            style:
                                const TextStyle(fontStyle: FontStyle.italic)),
                        const TextSpan(
                          text: '?',
                        )
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildRateWidget(),
              const SizedBox(
                height: 20,
              ),
              Blurred(
                sigmaX: 100,
                sigmaY: 100,
                child: ImdbButton(
                  onTap: () async {
                    if (_rate <= 0) {
                      return;
                    }
                    if (_removeFromWatchListCheck == true) {
                      if (context
                          .read<UserWatchListCubit>()
                          .state
                          .ids
                          .contains(widget.data.movieBean.id!)) {
                        updateWatchListOrFavPeople(
                            widget.data.movieBean.id!, context);
                      }
                    }
                    EasyLoading.show();
                    var rated =
                        await rateMovieApi(widget.data.movieBean.id!, _rate);

                    if (rated != null) {
                      context.read<UserRatedCubit>().add(rated);
                      context.pop();

                      EasyLoading.showSuccess(
                        'Rating saved',
                      );
                    } else {
                      EasyLoading.showInfo('Rate movie failed');
                    }
                    EasyLoading.dismiss();
                  },
                  text: 'Rate',
                  color: _rate > 0
                      ? Colors.blue[400]
                      : ColorsUtils.secondaryBlackOrWhite(context)
                          .withOpacity(0.2),
                ),
              ),
              BlocBuilder<UserWatchListCubit, UserWatchListState>(
                builder: (context, state) {
                  return _userRated ||
                          !state.ids.contains(widget.data.movieBean.id!)
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StatefulBuilder(
                              builder: (BuildContext context, setStateInner) {
                                return Checkbox(
                                    activeColor: Colors.blue[400],
                                    value: _removeFromWatchListCheck,
                                    onChanged: (v) {
                                      _removeFromWatchListCheck = v;
                                      setStateInner(() {});
                                    });
                              },
                            ),
                            const Text('Remove from watch list')
                          ],
                        );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<UserRatedCubit, UserRatedState>(
                builder: (context, state) {
                  return isRated(widget.data.movieBean.id!, context)
                      ? ImdbButton(
                          onTap: () async {
                            showConfirmDialog(context, 'Remove rate?',
                                () async {
                              var resp = await removeRateApi(
                                  widget.data.movieBean.id!);
                              if (reqSuccess(resp)) {
                                context
                                    .read<UserRatedCubit>()
                                    .remove(widget.data.movieBean.id!);
                                context.pop();
                                EasyLoading.showSuccess(
                                  'Rating removed',
                                );
                                context.pop();
                              } else {
                                EasyLoading.showInfo('${resp.data}');
                              }
                            });
                            // showCupertinoDialog(
                            //     context: context,
                            //     builder: (_) {
                            //       return CupertinoAlertDialog(
                            //         title: const Text('Alert'),
                            //         content: const Text('Remove rate?'),
                            //         actions: [
                            //           CupertinoDialogAction(
                            //             isDestructiveAction: true,
                            //             onPressed: () {
                            //               // Get.back();
                            //               context.pop();
                            //             },
                            //             child: const Text('No'),
                            //           ),
                            //           CupertinoDialogAction(
                            //             isDestructiveAction: false,
                            //             onPressed: () async {
                            //               var resp = await removeRateApi(
                            //                   widget.data.movieBean.id!);
                            //               if (reqSuccess(resp)) {
                            //                 // userPersonalRateController
                            //                 //     .map[widget.movieBean.id!] = 0;
                            //                 //todo
                            //                 context.pop();
                            //                 EasyLoading.showSuccess(
                            //                   'Rating removed',
                            //                 );
                            //                 context.pop();
                            //               } else {
                            //                 EasyLoading.showInfo(
                            //                     '${resp.data}');
                            //               }
                            //             },
                            //             child: const Text('Yes'),
                            //           ),
                            //         ],
                            //       );
                            //     });
                          },
                          text: 'Remove rate',
                          color: Colors.redAccent,
                        )
                      : const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showWarnDialog(BuildContext context) {
    showConfirmDialog(context,
        'Your rate has been changed but not saved. Do you want to discard it?',
        () {
      context.pop();
      context.pop();
    });
    // showCupertinoDialog(
    //     context: context,
    //     builder: (context) => Center(
    //           child: Blurred(
    //             borderRadius: BorderRadius.circular(10),
    //             child: Container(
    //               color: ColorsUtils.secondaryBlackOrWhite(context)
    //                   .withOpacity(0.2),
    //               height: 150,
    //               width: 300,
    //               child: Column(
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: SizedBox(
    //                         height: 100,
    //                         child: Center(
    //                             child: Text(
    //                                 'Your rate has been changed but not saved. Do you want to discard it?',
    //                                 style: Theme.of(context)
    //                                     .textTheme
    //                                     .titleMedium))),
    //                   ),
    //                   const Divider(
    //                     thickness: 1,
    //                     height: 1,
    //                   ),
    //                   Expanded(
    //                     child: SizedBox(
    //                       height: 30,
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           Expanded(
    //                             child: InkWell(
    //                               onTap: () {
    //                                 context.pop();
    //                               },
    //                               child: Center(
    //                                   child: Text('Cancel',
    //                                       style: Theme.of(context)
    //                                           .textTheme
    //                                           .titleMedium)),
    //                             ),
    //                           ),
    //                           const VerticalDivider(
    //                             thickness: 1,
    //                           ),
    //                           Expanded(
    //                             child: InkWell(
    //                               onTap: () {
    //                                 context.pop();
    //                                 context.pop();
    //                               },
    //                               child: Center(
    //                                   child: Text('Discard',
    //                                       style: TextStyle(
    //                                           fontSize: Theme.of(context)
    //                                               .textTheme
    //                                               .titleMedium!
    //                                               .fontSize,
    //                                           fontWeight: Theme.of(context)
    //                                               .textTheme
    //                                               .titleMedium!
    //                                               .fontWeight,
    //                                           color: const Color.fromARGB(
    //                                               255, 240, 59, 59)))),
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ));
  }

  List<Widget> _buildStars() {
    List<Widget> stars = [];
    for (var i = 0; i < 10; i++) {
      stars.add(GestureDetector(
        onTap: () {
          setState(() {
            _rate = i + 1;
          });
        },
        child: i + 1 > _rate
            ? Icon(
                Icons.star_outline_rounded,
                size: 35,
                color: Colors.grey[800],
              )
            : Icon(
                Icons.star_rounded,
                size: 35,
                color: Colors.blue[400],
              ),
      ));
    }

    return stars;
  }

  Widget _buildRateWidget() {
    return RatingBar(
      initialRating: _rate.toDouble(),
      itemSize: 35,
      itemCount: 10,
      allowHalfRating: false,
      updateOnDrag: true,
      onRatingUpdate: (double value) {
        setState(() {
          _rate = value.floor();
        });
      },
      ratingWidget: RatingWidget(
          empty: Icon(
            Icons.star_outline_rounded,
            color: Colors.grey[800],
          ),
          full: Icon(
            Icons.star_rounded,
            color: Colors.blue[400],
          ),
          half: Icon(
            Icons.star_rounded,
            color: Colors.blue[400],
          )),
    );
  }
}
