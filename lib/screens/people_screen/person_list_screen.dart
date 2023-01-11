import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../apis/person_info_of_person_list_api.dart';
import '../../apis/user_lists.dart';
import '../../beans/list_resp.dart';
import '../../beans/person_info_of_person_list_resp.dart';
import '../../constants/config_constants.dart';
import '../../utils/platform.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/my_network_image.dart';

class PeopleListScreenLazyData {
  final String listUrl;
  final String title;

  PeopleListScreenLazyData({required this.listUrl, required this.title});
}

class PeopleListScreenLazy extends StatelessWidget {
  const PeopleListScreenLazy({
    Key? key,
    required this.data,
  }) : super(key: key);
  final PeopleListScreenLazyData data;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ListResp>(
      future: getListDetailApi(
        data.listUrl,
        isPeopleList: true,
      ),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<ListResp> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return PeopleListScreen(
          data: PeopleListScreenData(
              listResult: snapshot.data!.result!,
              listUrl: data.listUrl,
              count: snapshot.data!.result?.count ??
                  snapshot.data!.result!.mids!.length,
              title: data.title,
              ids: snapshot.data!.result!.mids!),
        );
      },
    );
  }
}

class PeopleListScreenData {
  final String title;

  final List<String> ids;
  final String? listUrl;
  final Function(List<String>)? onScrollReallyEnd;
  final int count;
  final ListResult? listResult;

  PeopleListScreenData({
    required this.title,
    required this.ids,
    this.onScrollReallyEnd,
    this.listUrl,
    required this.count,
    this.listResult,
  });
}

class PeopleListScreen extends StatefulWidget {
  const PeopleListScreen({
    Key? key,
    required this.data,
  }) : super(key: key);
  final PeopleListScreenData data;
  @override
  State<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends State<PeopleListScreen> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  bool _loading = false;
  final int _batchSize = 10;
  // 加入tag，防止不同页面共用_LoadingIndicatorController()导致的loading始终为true的问题
  // final _controller = Get.put(_LoadingIndicatorController(),
  //     tag: '${DateTime.now()} ${Random().nextInt(100000)}');

  @override
  void didUpdateWidget(covariant PeopleListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.ids != widget.data.ids) {
      _getData();
    }
  }

  final RefreshController refreshController = RefreshController();
  bool _allowPullUp = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data.title)),
      // body: NotificationListener<OverscrollNotification>(
      //   onNotification: (notification) {
      //     if (notification.metrics.pixels >=
      //         notification.metrics.maxScrollExtent) {
      //       // print(_people.length);
      //       _getData();
      //     }
      //     return false;
      //   },
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: false,
        enablePullUp: _allowPullUp,
        onLoading: () async {
          var peopleCountBak = _people.length;
          await _getData();
          refreshController.loadComplete();
          var newCount = _people.length;
          if (newCount == peopleCountBak) {
            _allowPullUp = false;
            if (mounted) {
              setState(() {});
            }
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              collapsedHeight: 70,
              // expandedHeight: 100,
              leading: const SizedBox(),
              floating: true,
              flexibleSpace: Container(
                height: 200,
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        widget.data.title,
                        maxLines: 2,
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: '${widget.data.count} people ',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        if (notBlank(widget.data.listResult?.authorName))
                          const TextSpan(text: 'by '),
                        TextSpan(
                          text: widget.data.listResult?.authorName,
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (widget.data.listResult?.authorId != null) {
                                //todo
                                // Get.to(() => ImdbUserInfoScreen(
                                //     uid: widget.data.listResult!.authorId!));
                              }
                            },
                        )
                      ])),
                    ],
                  ),
                ),
              ),
            ),
            if (PlatformUtils.screenAspectRatio(context) > 1)
              SliverGrid(
                delegate: _delegate(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: PlatformUtils.gridCrossAxisCount(context)),
              )
            else
              SliverList(delegate: _delegate()),
            // buildSingleChildSliverList(SizedBox(
            //   height: 30,
            //   child: Obx(() {
            //     if (_controller.loading.value) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     return const SizedBox();
            //   }),
            // ))
          ],
        ),
      ),
    );
  }

  SliverChildBuilderDelegate _delegate() {
    return SliverChildBuilderDelegate((context, index) {
      var p = _people[index];
      if (p == null) {
        return const SizedBox();
      }
      return GestureDetector(
        onTap: () {
          GoRouter.of(context).push('/person/${widget.data.ids[index]}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${index + 1}'),
                  if (widget.data.listResult?.authorId.toString() ==
                      context.read<UserCubit>().state.username)
                    InkWell(
                        onTap: () async {
                          var id = widget.data.ids[index];

                          var listUrl = widget.data.listUrl;

                          await deleteIdFromList(id, listUrl, context, () {
                            _people[index] = null;
                            if (mounted) {
                              setState(() {});
                            }
                          }, authorId: widget.data.listResult?.authorId ?? '');
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.more_horiz
                              // size: 10,
                              ),
                        ))
                ],
              ),
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: SizedBox(
                    width: 100.0,
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: MyNetworkImage(
                          url: smallPic(p.avatar ?? defaultAvatar)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${p.name}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: p.jobs!
                            .map(
                              (e) => Text(
                                '$e ${p.jobs!.indexOf(e) < p.jobs!.length - 1 ? '/' : ''} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    _buildKnownForMoviesWidget(p),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${p.intro}',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                      ),
                    )
                  ],
                ),
              )
            ]),
            if (!PlatformUtils.isDesktop) const Divider()
          ],
        ),
      );
    }, childCount: _people.length);
  }

  Widget _buildKnownForMoviesWidget(PersonInfoOfPersonList p) {
    const height = 50.0;
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: p.knownForIdsTitles?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var knownForIdsTitle = p.knownForIdsTitles![index];
          var split = knownForIdsTitle.split('*');
          if (split.length < 2) {
            return const SizedBox();
          }
          return Row(
            children: [
              const Text('Known for '),
              InkWell(
                  onTap: () {
                    context.push('/title/${split[0]}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      split[1].trim(),
                      style: const TextStyle(color: Colors.blue),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  final List<PersonInfoOfPersonList?> _people = [];
  int _page = 1;
  bool _listEnd = false;

  Future _getData() async {
    if (_loading) {
      debugPrint('$PeopleListScreen loading is busy');
      return;
    }
    _loading = true;

    // 获取列表的更多ids
    if (_people.length == widget.data.ids.length &&
        !_listEnd &&
        widget.data.listUrl != null) {
      var listResp = await getListDetailApi(widget.data.listUrl, page: ++_page);
      if (listResp.result?.mids?.isNotEmpty == true) {
        widget.data.ids.addAll(listResp.result?.mids ?? []);
      } else {
        _listEnd = true;
      }
    }

    var sublist = _idsBatch();
    if (sublist.isEmpty) {
      if (widget.data.onScrollReallyEnd != null) {
        _loading = true;
        await widget.data.onScrollReallyEnd!(widget.data.ids);
        _loading = false;
      }
      _loading = false;
      sublist = _idsBatch();
    }
    // EasyLoading.show();

    // 获取更多info
    try {
      _people.addAll(await getPersonInfoOfPersonListApi(sublist));
    } finally {
      _loading = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  List<String> _idsBatch() {
    return widget.data.ids.sublist(_people.length,
        min(_people.length + _batchSize, widget.data.ids.length));
  }
}
