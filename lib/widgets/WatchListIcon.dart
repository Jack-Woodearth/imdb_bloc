import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/apis/watchlist_api.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/cubit/user_watch_list_cubit.dart';

class WatchListIcon extends StatelessWidget {
  const WatchListIcon({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        updateWatchListOrFavPeople(id, context);
      },
      child: SizedBox(
        width: 30,
        child: AspectRatio(
            aspectRatio: 3 / 4,
            child: BlocBuilder<UserWatchListCubit, UserWatchListState>(
              builder: (context, state) {
                return CustomPaint(
                  painter: BookMarkPainter(
                    strokeColor: state.ids.contains(id)
                        ? ImdbColors.themeYellow
                        : Colors.black87.withOpacity(0.5),
                    strokeWidth: 10,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  child: Center(
                    child: Icon(
                      state.ids.contains(id) ? Icons.check : Icons.add,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }
}

class BookMarkPainter extends MyAbstractCustomerPainter {
  BookMarkPainter(
      {required Color strokeColor,
      required PaintingStyle paintingStyle,
      required double strokeWidth})
      : super(
            paintingStyle: paintingStyle,
            strokeColor: strokeColor,
            strokeWidth: strokeWidth);
  @override
  Path getTrianglePath(double x, double y) {
    {
      return Path()
        ..lineTo(0, y)
        ..lineTo(x / 2, 0.8 * y)
        ..lineTo(x, y)
        ..lineTo(x, 0)
        ..lineTo(0, 0);
    }
  }
}

abstract class MyAbstractCustomerPainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  MyAbstractCustomerPainter(
      {required this.strokeColor,
      required this.paintingStyle,
      required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y);

  @override
  bool shouldRepaint(MyAbstractCustomerPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
