import 'dart:async';

import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final counter = StreamController<int>();
  var count = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              counter.add(++count);
            },
            child: const Icon(Icons.add)),
        StreamBuilder(
          stream: counter.stream,
          builder: (BuildContext context, snapshot) {
            return Text('count=${snapshot.data}');
          },
        ),
      ],
    );
  }
}
