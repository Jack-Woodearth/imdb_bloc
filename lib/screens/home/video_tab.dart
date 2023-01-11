import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imdb_bloc/constants/config_constants.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/widgets/StackedPictures.dart';

class VideoTab extends StatefulWidget {
  const VideoTab({super.key});

  @override
  State<VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> {
  final _streamController = StreamController<int>();
  final ScrollController scrollController = ScrollController();
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final children = Colors.accents
      .map((e) => Container(
            key: ValueKey(e.value),
            // margin: const EdgeInsets.all(8.0),
            color: e,
            height: 50,
          ))
      .toList();
  @override
  Widget build(BuildContext context) {
    dp('VideoTab rebuild');
    return Column(
      children: [
        TextButton(
            onPressed: () {
              compute((message) {
                dp(message);
              }, 'hello worker isolate from main isolated');
            },
            child: const Text('Test isolate')),
        Container(
            width: 83.34,
            height: 100,
            color: Colors.green,
            child: const StackedPictures(pictures: [
              defaultCover,
              defaultCover,
              defaultCover,
              defaultCover,
              defaultCover,
              defaultCover,
              defaultCover,
            ]))
      ],
    );

    return NotificationListener<MyNotification>(onNotification: (notification) {
      dp('NotificationListener<MyNotification>: ${notification.details}');
      return true;
    }, child: Builder(builder: (context) {
      return TextButton(
          onPressed: () {
            MyNotification('hello').dispatch(context);
            print('TextButton context ${context.hashCode}');
          },
          child: const Text('send notification'));
    }));
    // return ListView.builder(
    //     itemExtent: 60,
    //     itemBuilder: ((context, index) => Dismissible(
    //         onDismissed: (direction) {},
    //         key: UniqueKey(),
    //         child: Container(
    //             color: Colors.blueAccent, child: Text('data $index')))));
    // return GridView.builder(
    //     // itemCount: children.length,
    //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    //         childAspectRatio: 16 / 9, maxCrossAxisExtent: 300),
    //     itemBuilder: ((context, index) =>
    //         children[Random().nextInt(children.length)]));
    // return GridView.extent(
    //   maxCrossAxisExtent: 50,
    //   children: children,
    // );

    // return ReorderableList(
    //     itemBuilder: ((context, index) => ReorderableDragStartListener(
    //         key: children[index].key, index: index, child: children[index])),
    //     itemCount: children.length,
    //     onReorder: ((oldIndex, newIndex) {
    //       print('$oldIndex, $newIndex');
    //       if (newIndex > oldIndex) newIndex--;
    //       final ele = children.removeAt(oldIndex);
    //       children.insert(newIndex, ele);
    //       setState(() {});
    //     }));
    return ReorderableListView(
        itemExtent: 50,
        onReorder: ((oldIndex, newIndex) {
          print('$oldIndex, $newIndex');

          if (newIndex > oldIndex) newIndex--;
          final ele = children.removeAt(oldIndex);
          children.insert(newIndex, ele);
          setState(() {});
        }),
        children: [
          // Text(
          //   'data1',
          //   key: ValueKey(1),
          // ),
          // Text(
          //   'data2',
          //   key: ValueKey(2),
          // ),
          // Text(
          //   'data3',
          //   key: ValueKey(3),
          // ),
          // Text(
          //   'data4',
          //   key: ValueKey(4),
          // ),
          ...children
        ]);

    // return ListWheelScrollView(
    //     // offAxisFraction: -1.2,
    //     // useMagnifier: true,
    //     // magnification: 1.5,
    //     overAndUnderCenterOpacity: 0.5,
    //     itemExtent: 50,
    //     // diameterRatio: 0.5,
    //     // perspective: 0.01,
    //     // squeeze: 2.0,
    //     physics: const FixedExtentScrollPhysics(),
    //     children: List<Widget>.generate(30, (index) => Text('${index + 1} 日')));
    // return Scaffold(
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       scrollController.jumpTo(-25.0);
    //     },
    //     child: const Text('to top'),
    //   ),
    //   body: ListView.builder(
    //       controller: scrollController,
    //       itemExtent: 200,
    //       itemBuilder: ((context, index) => Container(
    //             color: Colors.accents[Random().nextInt(Colors.accents.length)],
    //             height: index.isEven ? 20 : 60,
    //             child: const Counter(),
    //           ))),
    // );

    // return SizedBox(
    //   child: Builder(builder: (context) {
    //     // print(user.token);

    //     return SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           Row(
    //             children: [
    //               TextButton(
    //                   onPressed: () {
    //                     _streamController.add(++counter);
    //                   },
    //                   child: const Text('add 1')),
    //               TextButton(
    //                   onPressed: () {
    //                     _streamController.addError('error');
    //                   },
    //                   child: const Text('add error')),
    //               TextButton(
    //                   onPressed: () {
    //                     _streamController.close();
    //                   },
    //                   child: const Text('close stream'))
    //             ],
    //           ),
    //           StreamBuilder(
    //             stream: _streamController.stream,
    //             builder: (BuildContext context, snapshot) {
    //               return snapshot.connectionState == ConnectionState.done
    //                   ? const Text('stream is close')
    //                   : Text(snapshot.hasData
    //                       ? '${snapshot.data}'
    //                       : '${snapshot.error}');
    //             },
    //           ),
    //           const Text('data'),
    //           Text(capitalizeAll('hello_world')),
    //           Align(
    //             alignment: Alignment.bottomRight,
    //             child: Text(
    //               'Hello world!',
    //               semanticsLabel: '你好世界',
    //               textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
    //               style: TextStyle(
    //                   // fontSize: 50,
    //                   background: Paint()
    //                     ..shader = ui.Gradient.linear(
    //                         const Offset(0, 0),
    //                         const Offset(180, 180),
    //                         [Colors.white, Colors.black]),
    //                   foreground: Paint()
    //                     ..shader = ui.Gradient.linear(
    //                         const Offset(0, 0),
    //                         const Offset(180, 180),
    //                         [Colors.yellow, Colors.blue])),
    //             ),
    //           ),
    //           DefaultTextStyle.merge(
    //             style: const TextStyle(fontSize: 50),
    //             child: Column(
    //               children: Colors.accents
    //                   .map((e) => Text(
    //                         'Hello World',
    //                         style: TextStyle(
    //                             color: e,
    //                             fontStyle: Random().nextInt(2).isEven
    //                                 ? FontStyle.italic
    //                                 : null),
    //                       ))
    //                   .toList(),
    //             ),
    //           ),
    //           Text.rich(
    //               TextSpan(style: const TextStyle(fontSize: 50), children: [
    //             const TextSpan(
    //               text: '落霞与孤鹜齐飞',
    //             ),
    //             TextSpan(
    //                 text: '秋水',
    //                 recognizer: TapGestureRecognizer()
    //                   ..onTap = () => print('秋水 单击'),
    //                 style: const TextStyle(
    //                     color: Colors.red,
    //                     decoration: TextDecoration.underline)),
    //             const TextSpan(text: '共长天一色')
    //           ])),

    //           // const MyNetworkImage(url: 'url')
    //           // ShaderMask(
    //           //   blendMode: BlendMode.color,
    //           //   shaderCallback: (Rect bounds) {
    //           //     return const LinearGradient(
    //           //       colors: [
    //           //         Colors.red,
    //           //         Colors.yellow,
    //           //       ],
    //           //     ).createShader(bounds);
    //           //   },
    //           //   child: const Text('ShaderMask'),
    //           // )
    //         ],
    //       ),
    //     );
    //   }),
    // );
  }
}

class Sender extends StatelessWidget {
  const Sender({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          MyNotification('hello').dispatch(context);
        },
        child: const Text('send notification'));
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> with AutomaticKeepAliveClientMixin {
  final counter = StreamController<int>();
  var count = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      children: [
        TextButton(
            onPressed: () {
              counter.add(++count);
            },
            child: const Icon(Icons.add)),
        // StreamBuilder(
        //   stream: counter.stream,
        //   initialData: count,
        //   builder: (BuildContext context, snapshot) {
        //     return Expanded(
        //       child: Text(
        //           'counter.stream count=${snapshot.data} state count=$count '),
        //     );
        //   },
        // ),
        TextButton(
          child: const Text('add 1'),
          onPressed: () {
            setState(() {
              count++;
            });
          },
        ),
        Text('count=$count')
      ],
    );
  }

  @override
  bool get wantKeepAlive => count != 0;
}

class MyNotification extends Notification {
  final dynamic details;

  MyNotification(this.details);
  @override
  void dispatch(BuildContext? target) {
    dp('MyNotification "$details" dispatched');
    super.dispatch(target);
  }
}
