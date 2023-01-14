import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imdb_bloc/constants/config_constants.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/widgets/StackedPictures.dart';

import 'game.dart';

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
    return GameTest();
    return ColorsGame();
    return SingleChildScrollView(
      child: SizedBox(
        height: 2000,
        child: Column(
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
                ])),
            Draggable(
                // affinity: Axis.horizontal,
                maxSimultaneousDrags: 1,
                // axis: Axis.vertical,
                child: Container(
                  color: Colors.amber,
                  height: 50,
                  width: 50,
                ),
                childWhenDragging: SizedBox(),
                feedback: Container(
                  color: Colors.amber.withOpacity(0.2),
                  height: 50,
                  width: 50,
                )),
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      dp('GestureDetector tapped');
                    },
                  ),
                  AbsorbPointer(
                    child: TextButton(
                      child: const Text(
                        'buttton on top of GestureDetector',
                        style: TextStyle(fontSize: 50),
                      ),
                      onPressed: () {
                        dp('buttton on top of GestureDetector pressed');
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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

class ColorsGame extends StatefulWidget {
  @override
  _ColorsGameState createState() => _ColorsGameState();
}

class _ColorsGameState extends State<ColorsGame> {
  late MaterialColor _color;
  late List<Color> _list;

  @override
  void initState() {
    _generatePuzzle();
    super.initState();
  }

  _generatePuzzle() {
    setState(() {
      final _rnd = Random();
      const allowedColors = Colors.primaries;
      _color = allowedColors[_rnd.nextInt(allowedColors.length)];
      final l1 = [100, 200]..shuffle(_rnd);
      final l2 = [300, 400, 600, 800]..shuffle(_rnd);
      _list = [...l1, ...l2].map((i) => _color[i]!).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draggable Game Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Drag and drop to rearrange",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            IconButton(
              onPressed: _generatePuzzle,
              icon: Icon(Icons.shuffle),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Container(
                width: ColorBox.boxWidth - ColorBox.boxPadding * 2,
                height: ColorBox.boxHeight - ColorBox.boxPadding * 2,
                decoration: BoxDecoration(
                  color: _color[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lock_outline,
                  color: Colors.white,
                ),
              ),
            ),
            ReorderColors(
              color: _color,
              colorList: _list,
              onSuccess: () => showDialog(
                  context: context,
                  builder: ((context) => AlertDialog(
                        title: Text('success'),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}

class ReorderColors extends StatefulWidget {
  final MaterialColor color;
  final List<Color> colorList;
  final Function() onSuccess;

  ReorderColors({
    required this.color,
    required this.colorList,
    required this.onSuccess,
  }) : super(key: UniqueKey());

  @override
  _ReorderColorsState createState() => _ReorderColorsState();
}

class _ReorderColorsState extends State<ReorderColors> {
  int _emptySlot = 1;
  double _tapOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    final _list = widget.colorList;
    final h = ColorBox.boxHeight;
    return Container(
      width: ColorBox.boxWidth,
      height: _list.length * h,
      child: Listener(
        onPointerDown: (event) {
          /**
           * 这段代码的作用是计算出一个物体在屏幕上的垂直偏移量（即相对于它自己的局部坐标系的y轴）。
              第一行，定义了一个变量 obj，该变量获取到了当前界面上的渲染对象，并将其转换为一个 RenderBox 类型。
              第二行，计算出了 obj 在屏幕上的垂直偏移量。
              通过调用 obj.globalToLocal(Offset.zero) 方法将全局坐标系（屏幕坐标系）中坐标（0,0） 转换为局部坐标系，
              并返回一个 Offset 类型的值，该值表示了相对于 obj 的局部坐标系的坐标。最后通过.dy 取出y轴偏移量。
           */
          final obj = context.findRenderObject() as RenderBox;
          _tapOffset =
              obj.globalToLocal(Offset.zero).dy; //该值表示了相对于 obj 的局部坐标系的坐标。
        },
        onPointerMove: (event) {
          final y = event.position.dy + _tapOffset;
          if (y > (_emptySlot + 1) * h) {
            if (_emptySlot == _list.length - 1) return;
            Color temp = _list[_emptySlot];
            _list[_emptySlot] = _list[_emptySlot + 1];
            _list[_emptySlot + 1] = temp;
            setState(() => _emptySlot++);
          } else if (y < (_emptySlot) * h - (h / 2)) {
            if (_emptySlot == 0) return;
            Color temp = _list[_emptySlot];
            _list[_emptySlot] = _list[_emptySlot - 1];
            _list[_emptySlot - 1] = temp;
            setState(() => _emptySlot--);
          }
        },
        child: Stack(
          children: List.generate(
            _list.length,
            (i) => ColorBox(
              x: 0,
              y: i * h,
              color: _list[i],
              onDrag: (c) => _emptySlot = _list.indexOf(c),
              onDrop: () {
                final it = _list.map((c) => c.computeLuminance()).iterator
                  ..moveNext(); //移动到第一个元素。
                var prev = it.current;
                var sorted = true;
                while (it.moveNext()) {
                  if (it.current < prev) {
                    sorted = false;
                    break;
                  }
                  prev = it.current;
                }
                if (sorted) widget.onSuccess();

                // var list = _list.map((c) => c.computeLuminance()).toList();
                // var sorted = true;
                // for (int i = 0; i < list.length - 1; i++) {
                //   if (list[i] > list[i + 1]) {
                //     sorted = false;
                //     break;
                //   }
                // }
                // if (sorted) widget.onSuccess();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ColorBox extends StatelessWidget {
  static const boxHeight = 40.0;
  static const boxWidth = 180.0;
  static const boxPadding = 1.0;

  final double x, y; // box position
  final Color color;
  final Function(Color c) onDrag;
  final Function() onDrop;

  ColorBox({
    required this.x,
    required this.y,
    required this.color,
    required this.onDrag,
    required this.onDrop,
  }) : super(key: ValueKey(color));

  @override
  Widget build(BuildContext context) {
    final box = Padding(
      padding: EdgeInsets.all(boxPadding),
      child: Container(
        width: boxWidth - boxPadding * 2,
        height: boxHeight - boxPadding * 2,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(boxHeight / 5),
        ),
      ),
    );

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: x,
      top: y,
      child: Draggable(
        onDragStarted: () => onDrag(color),
        onDragEnd: (_) => onDrop(),
        feedback: box,
        childWhenDragging: SizedBox(width: boxWidth, height: boxHeight),
        child: box,
      ),
    );
  }
}
