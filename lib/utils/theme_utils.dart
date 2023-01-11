import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/cubit/theme_mode_cubit_cubit.dart';

void toggleTheme(BuildContext context) {
  final cubit = context.read<ThemeModeCubit>();
  cubit.toggle();
}
