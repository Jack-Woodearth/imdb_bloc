import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/widgets/loader.dart';

import '../cubit/loader_cubit.dart';

class ScaffoldWithLoadingMask extends StatelessWidget {
  const ScaffoldWithLoadingMask({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoaderCubit(),
      child: Stack(
        children: [child, const LoaderWidgetCoveringWholeScreen()],
      ),
    );
  }
}
