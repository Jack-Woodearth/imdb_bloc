import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:imdb_bloc/singletons/app_doc_path.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

const cropImageN = 10;

class GameTest extends StatefulWidget {
  const GameTest({super.key});

  @override
  State<GameTest> createState() => _GameTestState();
}

class _GameTestState extends State<GameTest> {
  @override
  void initState() {
    super.initState();
  }

  Uint8List? cropped;
  CropImageResult splits = CropImageResult([], 1.0);
  List<PicPartData> pics = [];
  int n = 7;
  String? path;
  bool success = false;
  pickImage() async {
    String? tmp;
    var pickFiles = await FilePicker.platform.pickFiles(type: FileType.image);
    if (pickFiles?.files.isNotEmpty == true) {
      tmp = pickFiles?.files.first.path;
    }
    if (tmp == null) {
      return;
    }
    path = tmp;
    await crop();
    setState(() {});
  }

  bool cropping = false;
  Future<void> crop() async {
    if (cropping) {
      return;
    }
    if (path == null) {
      return;
    }
    setState(() {
      cropping = true;
    });
    EasyLoading.show(status: 'Cropping image');

    splits = await compute(cropImage, [path!, n]);
    pics = splits.pics
        .asMap()
        .entries
        .map((e) => PicPartData(e.key, e.value))
        .toList()
      ..shuffle();
    // cropped = tmp;
    EasyLoading.dismiss();
    success = false;
    cropping = false;
    setState(() {});
  }

  bool isValid(int? tryParse) {
    return tryParse != null && tryParse > 0 && tryParse <= 100;
  }

  final GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextButton(
            onPressed: cropping
                ? null
                : () {
                    pickImage();
                  },
            child: Text('pick image'),
          ),
          TextButton(
              onPressed: cropping
                  ? null
                  : () {
                      setState(() {
                        pics.shuffle();
                        success = false;
                      });
                    },
              child: Text('shuffle')),
          SizedBox(
            // width: 50,
            child: Form(
              key: _key,
              child: Focus(
                onFocusChange: (value) {
                  dp('onFocusChange value=$value');
                },
                child: TextFormField(
                  decoration: InputDecoration(prefixText: 'n='),
                  enabled: !cropping,
                  controller: TextEditingController(text: '$n'),
                  onChanged: (v) {
                    var tryParse = int.tryParse(v);
                    if (isValid(tryParse)) {
                      n = tryParse!;
                    }
                    _key.currentState?.validate();
                  },
                  validator: (value) =>
                      isValid(int.tryParse(value ?? '')) && isValid(n)
                          ? null
                          : 'n must > 0 and <= 100',
                ),
              ),
            ),
          ),
          TextButton(
              onPressed: cropping
                  ? null
                  : () async {
                      if (_key.currentState?.validate() != true) {
                        return;
                      }
                      if (n != pics.length) {
                        pics.clear();
                        await crop();
                        setState(() {});
                      }
                    },
              child: Text('refresh after changing n')),
          TextButton(
              onPressed: cropping
                  ? null
                  : () async {
                      pics.sort(((a, b) => a.index.compareTo(b.index)));
                      setState(() {});
                    },
              child: Text('auto complete')),
          ReorderPicParts(
              aspectRatio: splits.aspectRatio * n,
              pics: pics,
              onSuccess: () {
                if (!success) {
                  EasyLoading.showSuccess('success');
                }
                success = true;
              })
        ],
      ),
    );
  }
}

class CropImageResult {
  final List<Uint8List> pics;
  final double aspectRatio;
  CropImageResult(this.pics, this.aspectRatio);
}

CropImageResult cropImage(List data) {
  String path = data[0];
  int n = cropImageN;

  if (data.length > 1) {
    n = data[1];
    assert(n > 0);
  }
  img.Image? image = img.decodeImage(File(path).readAsBytesSync());

  final List<Uint8List> images = [];
  if (image == null) {
    dp('image == null');
    return CropImageResult(images, 1.0);
  } else {
    var asp = image.width / image.height;
    var offset = 0;

    var h = image.height ~/ n;
    if (image.height % n != 0) {
      offset = image.height - h * n;
      asp = image.width / (image.height - offset);
    }
    for (var i = 0; i < n; i++) {
      img.Image trimmed = img.copyCrop(image,
          x: 0, y: h * i + offset, width: image.width, height: h);
      var tmp = img.encodeNamedImage(path, trimmed);
      if (tmp == null) {
        throw Exception('cropping image failed $path');
      }
      images.add(tmp);
    }
    return CropImageResult(images, asp);
  }
}

class PicPartData {
  final int index;
  final Uint8List pic;
  PicPartData(this.index, this.pic);
}

class ReorderPicParts extends StatefulWidget {
  final List<PicPartData> pics;
  final Function() onSuccess;
  final double aspectRatio;

  ReorderPicParts({
    required this.pics,
    required this.onSuccess,
    required this.aspectRatio,
  }) : super(key: UniqueKey());

  @override
  _ReorderPicPartsState createState() => _ReorderPicPartsState();
}

class _ReorderPicPartsState extends State<ReorderPicParts> {
  int _emptySlot = 1;
  double _tapOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    final _list = widget.pics;
    final h = PicPart.boxWidth / widget.aspectRatio;
    return Container(
      width: PicPart.boxWidth,
      height: _list.length * h,
      child: Listener(
        onPointerDown: (event) {
          final obj = context.findRenderObject() as RenderBox;
          _tapOffset = obj.globalToLocal(Offset.zero).dy;
        },
        onPointerMove: (event) {
          final y = event.position.dy + _tapOffset;
          if (y > (_emptySlot + 1) * h) {
            if (_emptySlot == _list.length - 1) return;
            var temp = _list[_emptySlot];
            _list[_emptySlot] = _list[_emptySlot + 1];
            _list[_emptySlot + 1] = temp;
            setState(() => _emptySlot++);
          } else if (y < (_emptySlot) * h - (h / 2)) {
            if (_emptySlot == 0) return;
            var temp = _list[_emptySlot];
            _list[_emptySlot] = _list[_emptySlot - 1];
            _list[_emptySlot - 1] = temp;
            setState(() => _emptySlot--);
          }
        },
        child: Stack(
          children: List.generate(
            _list.length,
            (i) => PicPart(
              aspectRatio: widget.aspectRatio,
              x: 0,
              y: i * h,
              pic: _list[i],
              onDrag: (c) => _emptySlot = _list.indexOf(c),
              onDrop: () {
                final it = _list.map((c) => c.index).iterator..moveNext();
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
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PicPart extends StatelessWidget {
  // static const boxHeight = 40.0;
  static const boxWidth = 300.0;
  static const boxPadding = 0.0;

  final double x, y; // box position
  final PicPartData pic;
  final Function(PicPartData c) onDrag;
  final Function() onDrop;
  final double aspectRatio;
  PicPart({
    required this.x,
    required this.y,
    required this.pic,
    required this.onDrag,
    required this.onDrop,
    this.aspectRatio = 2 / 1,
  }) : super(key: ValueKey(pic));

  @override
  Widget build(BuildContext context) {
    final boxHeight = boxWidth / aspectRatio;
    final box = Padding(
      padding: EdgeInsets.all(boxPadding),
      child: Container(
        width: boxWidth - boxPadding * 2,
        height: boxHeight - boxPadding * 2,
        child: Image.memory(pic.pic),
      ),
    );

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: x,
      top: y,
      child: Draggable(
        onDragStarted: () => onDrag(pic),
        onDragEnd: (_) => onDrop(),
        feedback: box,
        child: box,
        childWhenDragging: SizedBox(width: boxWidth, height: boxHeight),
      ),
    );
  }
}
