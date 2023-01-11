import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../apis/poll.dart';
import '../../apis/user_voted_items_of_poll.dart';
import '../../beans/poll_resp.dart';
import '../../constants/colors_constants.dart';
import '../../constants/config_constants.dart';
import '../../utils/common.dart';
import '../../widget_methods/widget_methods.dart';
import '../../widgets/my_network_image.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({Key? key, required this.pollId}) : super(key: key);
  final String pollId;

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  PollResult? _pollResult;
  @override
  void initState() {
    super.initState();
    _getData();
    _getVotedItemId();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  List<Items> _items = [];
  List<Items> _itemsShuffled = [];

  bool _showVotes = false;
  int _userVotedItemId = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pollResult?.poll?.pollTitle ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(builder: (context) {
          try {
            return CustomScrollView(
              slivers: [
                buildSingleChildSliverList(
                  Text(
                    _pollResult?.poll?.pollTitle ?? '',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                buildSingleChildSliverList(
                  Text(
                    _pollResult?.poll?.pollDescription ?? '',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  Items p;
                  if (_showVotes) {
                    p = _items[index];
                  } else {
                    p = _itemsShuffled[index];
                  }
                  return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: MyNetworkImage(
                              url: p.subjectImage ?? defaultAvatar),
                        ),
                      ),
                      title: Text(p.subjectTitle ?? ''),
                      subtitle: _showVotes
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Colors.limeAccent,
                                  width: screenWidth(context) *
                                      0.3 *
                                      (p.votes / (_votesMax ?? 1)),
                                  height: 20,
                                ),
                                Text('${p.votes} votes')
                              ],
                            )
                          : const SizedBox(),
                      trailing: _showVotes
                          ? SizedBox(
                              child: _userVotedItemId == p.id
                                  ? Icon(
                                      Icons.thumb_up,
                                      color: imdbYellow,
                                    )
                                  : const SizedBox(),
                            )
                          : IconButton(
                              onPressed: () {
                                _handleVote(p);
                              },
                              icon: Icon(
                                Icons.thumb_up,
                                // color: imdbYellow,
                              ),
                            ));
                }, childCount: _pollResult?.items?.length ?? 0))
              ],
            );
          } catch (e) {
            return const SizedBox();
          }
        }),
      ),
    );
  }

  void _getData() async {
    EasyLoading.show();
    _pollResult = await getPollApi(widget.pollId);
    _items = _pollResult?.items ?? [];
    _items.sort(((a, b) => -a.votes + b.votes));
    _itemsShuffled = _items.toList()..shuffle();
    _votesMax ??= _pollResult?.items
        ?.reduce(
            (value, element) => Items(votes: max(value.votes, element.votes)))
        .votes;
    if (_votesMax == 0) {
      _votesMax = 1;
    }
    if (mounted) {
      setState(() {});
    }
    EasyLoading.dismiss();
  }

  int? _votesMax;
  void _handleVote(Items p) async {
    _showVotes = true;
    var success = await votePollItem(widget.pollId, p.id!);
    if (success) {
      _userVotedItemId = p.id!;
      p.votes += 1;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _getVotedItemId() async {
    var i = await getUserVotedItemsOfPollApi(widget.pollId);
    _userVotedItemId = i;
    if (_userVotedItemId != -1) {
      _showVotes = true;
    }
    if (mounted) {
      setState(() {});
    }
  }
}
