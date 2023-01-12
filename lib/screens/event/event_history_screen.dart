import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/cubit/loader_cubit.dart';
import 'package:imdb_bloc/widgets/loader.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../apis/event_history_api.dart';
import '../../beans/event_history_bean.dart';
import '../../constants/colors_constants.dart';

class EventHistoryScreen extends StatefulWidget {
  const EventHistoryScreen({super.key, required this.historyId});
  final String historyId;
  @override
  State<EventHistoryScreen> createState() => _EventHistoryScreenState();
}

class _EventHistoryScreenState extends State<EventHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // print(widget.historyId);
    // _getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var loaderCubit = LoaderCubit();
        loaderCubit.beginLoading();
        _getData().then((value) => loaderCubit.cancelLoading());
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
                                        .map((award) => MultiSliver(
                                                pushPinnedChildren: true,
                                                children: [
                                                  SliverPinnedHeader(
                                                      child: Material(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0),
                                                      child: Text(
                                                        award.name.toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  )),
                                                  if (award.subs?.isNotEmpty ==
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
                                                                      color: Colors
                                                                          .black38,
                                                                      child:
                                                                          Material(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 8.0),
                                                                          child:
                                                                              Text(
                                                                            sub.subAwardName.toString(),
                                                                            style:
                                                                                Theme.of(context).textTheme.titleMedium,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                                  ...(sub.nominations ??
                                                                          [])
                                                                      .map((nomination) =>
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                nomination.isWinner == true ? 'Winner' : 'Nominee',
                                                                                style: TextStyle(color: nomination.isWinner == true ? imdbYellow : null),
                                                                              ),
                                                                              Text((nomination.nominees ?? []).map((e) => e.subjectName).join(', ')),
                                                                              if (nomination.nominationNotes != null)
                                                                                Text(
                                                                                  '${nomination.nominationNotes}',
                                                                                  style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                                                                ),
                                                                              const SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                            ],
                                                                          ))
                                                                      .toList()
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
    _eventHistoryBean = await getEventHistoryApi(widget.historyId);
    if (mounted) {
      setState(() {});
    }
  }
}
