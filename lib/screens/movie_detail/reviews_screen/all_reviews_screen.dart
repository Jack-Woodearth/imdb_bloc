import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';
import 'package:imdb_bloc/screens/movie_detail/rate_movie_screen.dart';
import 'package:imdb_bloc/singletons/user.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../apis/apis.dart';
import '../../../beans/details.dart';
import '../../../beans/reviews.dart';
import '../../../beans/user_ratings.dart';
import '../../../constants/colors_constants.dart';
import '../../../utils/common.dart';
import '../../../utils/string/string_utils.dart';
import '../../../widget_methods/widget_methods.dart';

// import '../../componets/exopandeble_text.dart';

class AllReviewsScreen extends StatefulWidget {
  const AllReviewsScreen({Key? key, required this.movieBean}) : super(key: key);
  final MovieBean movieBean;

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controllerThumbUp = AnimationController(vsync: this);

    _getData();
  }

  @override
  void dispose() {
    _controllerThumbUp.dispose();
    _controllerScroll.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AllReviewsScreen oldWidget) {
    if (oldWidget.movieBean.id != widget.movieBean.id) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  List<Review> _reviews = [];
  UserRatingsResp? _userRatingsResp;
  List<UserReviewVote> _userReviewVotes = [];
  bool _loading = true;
  _getData() async {
    _loading = true;
    await Future.wait([getReviews(), getUserRatings()]);
    _loading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future getReviews() async {
    _reviews = await ReviewsHandler(mid: widget.movieBean.id!).list();
    _reviews.sort(((a, b) =>
        -a.createTime.toString().compareTo(b.createTime.toString())));
    await getUserVotesForeReviews();
  }

  Future getUserRatings() async {
    _userRatingsResp = await getUserRatingsApi(widget.movieBean.id!);
    if (_userRatingsResp != null && _userRatingsResp!.result != null) {
      allVotesCount = _userRatingsResp!.result!.ratings!
          .reduce((value, element) => value + element);
    }
  }

  Future getUserVotesForeReviews() async {
    _userReviewVotes = await batchGetUserVoteForReviewsApi(
        _reviews.map((e) => e.id!).toList());
  }

  UserReviewVote? getUserReviewVote(int reviewId) {
    for (var item in _userReviewVotes) {
      if (item.reviewId == reviewId) {
        return item;
      }
    }
    return null;
  }

  var allVotesCount = 1;
  late final AnimationController _controllerThumbUp;
  final ScrollController _controllerScroll = ScrollController();
  String newReview = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('User reviews'),
        actions: [
          IconButton(
              onPressed: () {
                showCupertinoModalBottomSheet(
                    context: context,
                    builder: ((context) => Material(
                          child: SizedBox(
                            height: screenHeight(context),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CupertinoButton(
                                        child: const Text('Publish'),
                                        onPressed: () async {
                                          var of = GoRouter.of(context);

                                          if (notBlank(newReview)) {
                                            var user =
                                                context.read<UserCubit>().state;
                                            EasyLoading.show();
                                            var added = await ReviewsHandler(
                                                    mid: widget.movieBean.id!)
                                                .add(Review(
                                              authorId: user.uid.toString(),
                                              authorName: user.username,
                                              content: newReview,
                                              mid: widget.movieBean.id!,
                                            ));
                                            EasyLoading.dismiss();

                                            if (added) {
                                              of.pop();
                                              EasyLoading.showSuccess(
                                                  'Your review was published.');
                                              _getData();
                                            } else {
                                              EasyLoading.showError(
                                                  'Error! Please try again.');
                                            }
                                          }
                                        }),
                                    CupertinoButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          GoRouter.of(context).pop();
                                        }),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder()),
                                    onChanged: (value) async {
                                      newReview = value;
                                    },
                                    maxLines: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )));
              },
              icon: const Icon(Icons.add_comment))
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  _controllerScroll.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    '${widget.movieBean.title} (${widget.movieBean.yearRange})',
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: _controllerScroll,
                      itemCount: _reviews.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'IMDb rating',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          StarAndRate(
                                            rate: widget.movieBean.rate!
                                                .substring(
                                                    0,
                                                    min(
                                                        3,
                                                        widget.movieBean.rate!
                                                            .length)),
                                            size: 40,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Your rating',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              context.push('/title_rate',
                                                  extra: RateMovieScreenData(
                                                      movieBean:
                                                          widget.movieBean));
                                            },
                                            child: FutureBuilder(
                                                future: getUserPersonalRateApi(
                                                    widget.movieBean.id!),
                                                builder: (context, snapshot) {
                                                  final rate = snapshot.data;
                                                  return Row(
                                                    children: [
                                                      Icon(
                                                          rate == null ||
                                                                  rate == 0
                                                              ? Icons
                                                                  .star_outline_rounded
                                                              : Icons
                                                                  .star_rounded,
                                                          color: Colors
                                                              .blue[800]!),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          rate == null ||
                                                                  rate == 0
                                                              ? 'Rate this'
                                                              : '$rate / 10',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blue[800]!),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                      '${widget.movieBean.rateCount} votes'),
                                ),
                                _loading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : const Center(child: SizedBox()),

                                // userRatings distributions graph

                                _userRatingsResp?.result?.ratings != null
                                    ? Scrollbar(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: _userRatingsResp!
                                                .result!.ratings!
                                                .map((e) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            '${(e / allVotesCount * 100).toStringAsFixed(2)}%',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13),
                                                          ),
                                                          Container(
                                                            color: Colors.grey,
                                                            height: e /
                                                                allVotesCount *
                                                                400,
                                                            width: 40,
                                                          ),
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                              '${10 - _userRatingsResp!.result!.ratings!.indexOf(e)}')
                                                        ],
                                                      ),
                                                    ))
                                                .toList()
                                                .reversed
                                                .toList(),
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                              ]);
                        }

                        return StatefulBuilder(
                          builder: (BuildContext context, setStateInner) {
                            var r = _reviews[index - 1];

                            var text = r.content ?? '';
                            return Card(
                              // color: secondaryBlackOrWhite().withOpacity(0.5),
                              color: _isAuthor(r)
                                  ? const Color.fromARGB(255, 31, 161, 217)
                                  : null,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StarAndRate(rate: '${r.rate}'),
                                      Row(
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text('${r.authorName}')),
                                          Text(
                                              "   ${r.createTime!.substring(0, 10)}"),
                                        ],
                                      ),
                                      Text(
                                        r.title ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      MyExpandableText(text: text),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${r.useful} of ${r.votes} found this review helpful',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                      getUserReviewVote(r.id!) == null
                                          ? Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    await likeOrDislikeReview(
                                                            index)
                                                        .then((value) =>
                                                            setStateInner(
                                                                () {}));

                                                    _controllerThumbUp.reset();
                                                    await _controllerThumbUp
                                                        .forward();
                                                    _controllerThumbUp.reset();
                                                  },
                                                  child: const Icon(
                                                    Icons.thumb_up,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                    onTap: () async {
                                                      await likeOrDislikeReview(
                                                          index,
                                                          like: -1);
                                                      setStateInner(() {});
                                                    },
                                                    child: const Icon(
                                                        Icons.thumb_down)),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                if (_isAuthor(r))
                                                  GestureDetector(
                                                      onTap: () async {
                                                        await _handleDelete(
                                                            context, r);
                                                      },
                                                      child: const Icon(
                                                          Icons.delete)),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                _handleTap(context, r, index,
                                                    setStateInner);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '√ You found this review ${getUserReviewVote(r.id!)!.like == true ? '' : 'not'} helpful'),
                                                    Transform.rotate(
                                                      angle: pi / 2,
                                                      child: Icon(
                                                        Icons.more_horiz,
                                                        color: Colors.grey[600],
                                                        size: 20,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ]),
                              ),
                            );
                          },
                        );
                      },
                    )),
              ),
            ],
          ),
          IgnorePointer(
            ignoring: true,
            child: Container(
              height: screenHeight(context),
              color: _bottomSheetController != null ? Colors.black38 : null,
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: Lottie.asset('assets/14595-thumbs-up.json',
                controller: _controllerThumbUp, onLoaded: (composition) {
              _controllerThumbUp.duration = composition.duration;
            }, repeat: false),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context, Review r,
      {VoidCallback? additionalFunc}) async {
    showConfirmDialog(context, 'Delete this review?', () async {
      var of = GoRouter.of(context);
      var deleted =
          await ReviewsHandler(mid: widget.movieBean.id!).delete([r.id!]);
      if (deleted) {
        of.pop();
        EasyLoading.showSuccess('Deleted');
        _getData();
        if (additionalFunc != null) {
          additionalFunc();
        }
      } else {
        EasyLoading.showError('Deletion failed');
      }
    });
  }

  bool _isAuthor(Review r) {
    return r.authorId.toString() == user.uid.toString();
  }

  PersistentBottomSheetController? _bottomSheetController;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final bool _opened = false;
  _handleTap(BuildContext context, Review r, int index,
      StateSetter setStateInner) async {
    _bottomSheetController =
        _key.currentState?.showBottomSheet(backgroundColor: Colors.transparent,
            // context: context,
            // builder:
            (context) {
      // secondaryBgColor(context);
      return Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                _bottomSheetController?.close();
                // _bottomSheetController = null;
                // setState(() {});
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          SizedBox(
            // color: Get.isDarkMode ? Colors.black : Colors.white,
            height: 280,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(children: [
                      Row(
                        children: [
                          StarAndRate(rate: '${r.rate}'),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              '${r.title}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${r.content}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _helpfulWidget('Helpful', () async {
                        var of = GoRouter.of(context);
                        await likeOrDislikeReview(index, like: 1);
                        setStateInner(() {});
                        of.pop();
                      }),
                      _helpfulWidget('Not helpful', () async {
                        var of = GoRouter.of(context);
                        await likeOrDislikeReview(index, like: -1);
                        setStateInner(() {});

                        of.pop();
                      }),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Report',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'See All Reviews By ${r.authorName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_isAuthor(r))
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: ((context) => AlertDialog(
                                      content: TextField(
                                        onChanged: (v) {
                                          r.content = v;
                                        },
                                        controller: TextEditingController(
                                            text: r.content),
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                        maxLines: 10,
                                      ),
                                      actions: [
                                        TextButton(
                                            child: const Text('Complete'),
                                            onPressed: () async {
                                              EasyLoading.show();
                                              var of = GoRouter.of(context);
                                              var updated =
                                                  await ReviewsHandler(
                                                          mid: widget
                                                              .movieBean.id!)
                                                      .update(r);
                                              EasyLoading.dismiss();

                                              if (updated) {
                                                EasyLoading.showSuccess('');
                                                of.pop();
                                                _bottomSheetController?.close();
                                                _getData();
                                              } else {
                                                EasyLoading.showError('');
                                              }
                                            }),
                                        TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {})
                                      ],
                                    )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Text(
                                  'Edit this review',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_isAuthor(r))
                        InkWell(
                          onTap: () async {
                            await _handleDelete(context, r, additionalFunc: () {
                              _bottomSheetController?.close();
                              // _bottomSheetController = null;
                              // setState(() {});
                            });
                            // await Future.delayed(transitionDuration);

                            // Scaffold.of(context).bo
                            // Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Text(
                                  'Delete this review',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
    _bottomSheetController?.closed.then((value) {
      _bottomSheetController = null;
      setState(() {});
    });
    setState(() {});
  }

  InkWell _helpfulWidget(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> likeOrDislikeReview(int index, {int like = 1}) async {
    var v = getUserReviewVote(_reviews[index - 1].id!);
    if (v != null && v.like == true && like > 0) {
      return;
    }
    if (v != null && v.like == false && like <= 0) {
      return;
    }
    var resp = await voteForReviewApi(_reviews[index - 1].id!, like: like);
    _reviews[index - 1].useful = resp[0];
    _reviews[index - 1].votes = resp[1];
    if (v != null) {
      _userReviewVotes.remove(v);
    }
    _userReviewVotes.add(UserReviewVote.fromJson(resp[2]));
  }
}

class MyExpandableText extends StatelessWidget {
  const MyExpandableText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      text,
      expandText: 'show more',
      collapseText: 'show less',
      animation: true,
      collapseOnTextTap: true,
      animationCurve: Curves.easeIn,
      linkColor: imdbYellow,
      maxLines: 5,
    );
  }
}

class StarAndRate extends StatelessWidget {
  const StarAndRate({
    Key? key,
    required this.rate,
    this.size = 20,
  }) : super(key: key);

  final String rate;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          color: imdbYellow,
          size: size + 2,
        ),
        Text(
          rate,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: size - 2),
        ),
        const Text(
          '/10',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
