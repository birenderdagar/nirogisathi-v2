part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeEntity data;

  HomeLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}