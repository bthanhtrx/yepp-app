import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yepp/features/yepp/domain/entity/restaurant.dart';
import 'package:yepp/features/yepp/domain/entity/restaurant_detail.dart';
import 'package:yepp/features/yepp/domain/usecase/get_restaurant_detail.dart';
import 'package:yepp/features/yepp/domain/usecase/get_restaurants.dart';

part 'yepp_event.dart';

part 'yepp_state.dart';

class YeppBloc extends Bloc<YeppEvent, YeppState> {
  final GetRestaurants _getRestaurants;
  final GetRestaurantDetail _getRestaurantDetail;

  YeppBloc({
    required GetRestaurants getRestaurants,
    required GetRestaurantDetail getRestaurantDetail,
  })  : _getRestaurants = getRestaurants,
        _getRestaurantDetail = getRestaurantDetail,
        super(YeppInitial()) {
    on<YeppEvent>((event, emit) {
      emit(YeppLoading());
    });

    on<YeppGetRestaurants>(_onGetRestaurants);
    on<YeppGetRestaurantDetail>(_onGetRestaurantDetail);
  }

  @override
  void onTransition(Transition<YeppEvent, YeppState> transition) {
    super.onTransition(transition);
    print('${transition.currentState} - ${transition.nextState}');
  }

  void _onGetRestaurants(
      YeppGetRestaurants event, Emitter<YeppState> emit) async {
    // emit(YeppLoading());
    final res = await _getRestaurants(ListRestaurantsParams(event.term, event.location));

    res.fold(
      (l) {
        emit(YeppFailure(l.message));
      },
      (r) {
        emit(YeppListRestaurantsSuccess(r));
      },
    );
  }

  void _onGetRestaurantDetail(

      YeppGetRestaurantDetail event, Emitter<YeppState> emit) async {
  // emit(YeppLoading());
    final res = await _getRestaurantDetail(RestaurantIdParams(event.id));
    res.fold(
      (l) => emit(YeppFailure(l.message)),
      (r) => emit(YeppRestaurantDetailSuccess(r)),
    );
  }
}
