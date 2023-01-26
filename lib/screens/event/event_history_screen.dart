import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/cubit/loader_cubit.dart';
import 'package:imdb_bloc/screens/movie_detail/movie_details_screen_lazyload.dart';
import 'package:imdb_bloc/screens/person/person_detail_screen.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:imdb_bloc/widgets/PosterCardWrappedLazyLoadBean.dart';
import 'package:imdb_bloc/widgets/loader.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../apis/event_history_api.dart';
import '../../beans/event_history_bean.dart';
import '../../constants/colors_constants.dart';

class EventHistoryScreen extends StatefulWidget {
  const EventHistoryScreen(
      {super.key, this.historyId, this.eventId, this.year, this.number});
  final String? historyId;
  final String? eventId;
  final int? year;
  final int? number;
  @override
  State<EventHistoryScreen> createState() => _EventHistoryScreenState();
}

class _EventHistoryScreenState extends State<EventHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // print(widget.historyId);
    // _getData();
    // dp('widget.historyId=${widget.historyId}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var loaderCubit = LoaderCubit();
        loaderCubit.beginLoading();
        _getData().then((value) =>
            Future.delayed(const Duration(milliseconds: 300))
                .then((value) => loaderCubit.cancelLoading()));
        return loaderCubit;
      },
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Event History'),
          ),
          body: Stack(
            children: [
              BlocBuilder<LoaderCubit, LoaderState>(
                builder: (context, state) {
                  return state is LoaderStateLoading
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${_eventHistoryBean?.awardName} ${_eventHistoryBean?.history?.year}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith()),
                              const SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                  child: CustomScrollView(
                                slivers:
                                    (_eventHistoryBean?.history?.awards ?? [])
                                        .map(
                                            (award) => MultiSliver(
                                                    pushPinnedChildren: true,
                                                    children: [
                                                      SliverPinnedHeader(
                                                          child: Material(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: Text(
                                                            award.name
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                      )),
                                                      if (award.subs
                                                              ?.isNotEmpty ==
                                                          true)
                                                        ...(award.subs ?? [])
                                                            .map((sub) =>
                                                                MultiSliver(
                                                                    pushPinnedChildren:
                                                                        true,
                                                                    children: [
                                                                      if (sub.subAwardName !=
                                                                          null)
                                                                        SliverPinnedHeader(
                                                                            child:
                                                                                PhysicalModel(
                                                                          elevation:
                                                                              2.0,
                                                                          color:
                                                                              Colors.black38,
                                                                          child:
                                                                              Material(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                              child: Text(
                                                                                sub.subAwardName.toString(),
                                                                                style: Theme.of(context).textTheme.titleMedium,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )),
                                                                      SliverList(
                                                                          delegate:
                                                                              SliverChildBuilderDelegate(((context, index) {
                                                                        if (sub.nominations?.isNotEmpty !=
                                                                            true) {
                                                                          return SizedBox();
                                                                        }
                                                                        final nomination =
                                                                            sub.nominations![index];
                                                                        final nominees =
                                                                            nomination.nominees ??
                                                                                [];
                                                                        return Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              nomination.isWinner == true ? 'Winner' : 'Nominee',
                                                                              style: TextStyle(color: nomination.isWinner == true ? imdbYellow : null),
                                                                            ),
                                                                            // Text((nomination.nominees ?? []).map((e) => e.subjectName).join(', ')),
                                                                            Wrap(
                                                                              children: nominees.map((e) => SizedBox(height: 250, child: PosterCardWrappedLazyLoadBean(id: e.subjectId))).toList(),
                                                                            ),

                                                                            if (nomination.nominationNotes !=
                                                                                null)
                                                                              Text(
                                                                                '${nomination.nominationNotes}',
                                                                                style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                                                              ),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }), childCount: sub.nominations?.length ?? 0)),
                                                                      // ...(sub.nominations ??
                                                                      //         [])
                                                                      //     .map(
                                                                      //         (nomination) {
                                                                      //   var nominees =
                                                                      //       nomination.nominees ??
                                                                      //           [];
                                                                      //   return Column(
                                                                      //     crossAxisAlignment:
                                                                      //         CrossAxisAlignment.start,
                                                                      //     children: [
                                                                      //       Text(
                                                                      //         nomination.isWinner == true ? 'Winner' : 'Nominee',
                                                                      //         style: TextStyle(color: nomination.isWinner == true ? imdbYellow : null),
                                                                      //       ),
                                                                      //       // Text((nomination.nominees ?? []).map((e) => e.subjectName).join(', ')),
                                                                      //       Wrap(
                                                                      //         children: nominees.map((e) => SizedBox(height: 250, child: PosterCardWrappedLazyLoadBean(id: e.subjectId))).toList(),
                                                                      //       ),
                                                                      //       // Text.rich(TextSpan(
                                                                      //       //     children: (nominees)
                                                                      //       //         .map((e) => TextSpan(
                                                                      //       //             style: const TextStyle(color: Colors.blue),
                                                                      //       //             recognizer: TapGestureRecognizer()
                                                                      //       //               ..onTap = () {
                                                                      //       //                 var id = e.subjectId;
                                                                      //       //                 if (id.startsWith('nm')) {
                                                                      //       //                   pushRoute(context: context, screen: PersonDetailScreen(pid: id));
                                                                      //       //                 } else if (id.startsWith('tt')) {
                                                                      //       //                   pushRoute(context: context, screen: MovieFullDetailScreenLazyLoad(mid: id));
                                                                      //       //                 }
                                                                      //       //               },
                                                                      //       //             text: '${e.subjectName}${(nominees).indexOf(e) != (nominees).length - 1 ? ', ' : ''}'))
                                                                      //       //         .toList())),
                                                                      //       if (nomination.nominationNotes !=
                                                                      //           null)
                                                                      //         Text(
                                                                      //           '${nomination.nominationNotes}',
                                                                      //           style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                                                      //         ),
                                                                      //       const SizedBox(
                                                                      //         height: 20,
                                                                      //       ),
                                                                      //     ],
                                                                      //   );
                                                                      // }).toList()
                                                                    ]))
                                                            .toList(),
                                                    ]))
                                        .toList(),
                              ))
                            ],
                          ),
                        );
                },
              ),
              const LoaderWidget()
            ],
          ),
        );
      }),
    );
  }

  EventHistoryBean? _eventHistoryBean;
  Future _getData() async {
    _eventHistoryBean = await getEventHistoryApi(widget.historyId,
        eventId: widget.eventId, year: widget.year, number: widget.number);
  }
}
