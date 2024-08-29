import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/features/home/domain/usecase/get_restaurants.dart';
part 'yepp_event.dart';

part 'yepp_state.dart';

class YeppBloc extends Bloc<YeppEvent, YeppState> {
  final GetRestaurants _getRestaurants;

  YeppBloc({
    required GetRestaurants getRestaurants,
  })  : _getRestaurants = getRestaurants,
        super(YeppInitial()) {
    on<YeppEvent>((event, emit) {
      emit(YeppLoading());
    });

    on<YeppGetRestaurants>(_onGetRestaurants);
  }

  @override
  void onTransition(Transition<YeppEvent, YeppState> transition) {
    super.onTransition(transition);
    print('${transition.currentState} - ${transition.nextState}');
  }

  void _onGetRestaurants(
      YeppGetRestaurants event, Emitter<YeppState> emit) async {
    // emit(YeppLoading());
    final res = await _getRestaurants(
        ListRestaurantsParams(event.term, event.location, event.offset));

    res.fold(
      (l) {
        emit(YeppFailure(l.message));
      },
      (r) {
        emit(YeppNearbyListRestaurantsSuccess(r));
      },
    );
  }
}
