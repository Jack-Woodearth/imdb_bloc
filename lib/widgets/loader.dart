import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/cubit/loader_cubit.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoaderCubit, LoaderState>(
      builder: (context, state) {
        return state is LoaderStateLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox();
      },
    );
  }
}

class LoaderWidgetCoveringWholeScreen extends StatelessWidget {
  const LoaderWidgetCoveringWholeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoaderCubit, LoaderState>(
      builder: (context, state) {
        return state is LoaderStateLoading
            ? Container(
                color: Colors.black38,
                width: double.infinity,
                height: double.infinity,
                child: const Center(child: CircularProgressIndicator()),
              )
            : const SizedBox();
      },
    );
  }
}
