import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:imdb_bloc/screens/home/home_tab.dart';
import 'package:imdb_bloc/screens/home/search_tab.dart';
import 'package:imdb_bloc/screens/home/video_tab.dart';
import 'package:imdb_bloc/utils/colors.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/string/string_utils.dart';
import 'package:imdb_bloc/widgets/load_on_demand_widget.dart';

import '../../widget_methods/widget_methods.dart';
import '../user_profile/youscreen.dart';
import '../video/video_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _stackIndex = 0;
  final List<bool> _isInit = List.filled(4, true);

  @override
  Widget build(BuildContext context) {
    dp('HomeScreen build');
    return WillPopScope(
      onWillPop: (() async {
        await showConfirmDialog(context, 'Exit Imdb?', () {
          exit(0);
        });
        return false;
      }),
      child: Scaffold(
          // floatingActionButton: FloatingActionButton(onPressed: () {
          //   pushRoute(context: context, screen: const VideoTab());
          // }),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          ),
          body: IndexedStack(
            index: _stackIndex,
            children: [
              const HomeTab(),
              const SearchTab(),
              const VideoTab(),
              LoadOnDemandWidget(
                  load: _stackIndex == 3,
                  isInit: false,
                  child: const YouScreen()),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: ColorsUtils.yellowOrBlack(context),
              currentIndex: _stackIndex,
              onTap: (index) {
                setState(() {
                  _stackIndex = index;
                  _isInit[index] = false;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.play_arrow_rounded), label: 'video'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'You')
              ])),
    );
  }
}
