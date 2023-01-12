part of 'loader_cubit.dart';

@immutable
abstract class LoaderState {}

class LoaderStateLoading extends LoaderState {}

class LoaderStateLoaded extends LoaderState {}
