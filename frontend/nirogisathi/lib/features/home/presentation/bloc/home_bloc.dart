import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


import '../../domain/usecases/get_home_usecase.dart';
import '../../domain/entities/home_entity.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeBloc(this.getHomeDataUseCase) : super(HomeInitial()) {
    on<GetHomeDataEvent>((event, emit) async {
      emit(HomeLoading());

      final result = await getHomeDataUseCase();

      result.fold(
            (failure) => emit(HomeError(message: failure.message)),
            (data) => emit(HomeLoaded(data: data)),
      );
    });
  }
}