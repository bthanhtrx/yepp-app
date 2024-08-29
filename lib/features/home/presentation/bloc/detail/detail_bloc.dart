import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yepp/features/home/domain/entity/location_review.dart';
import 'package:yepp/features/home/domain/entity/restaurant_detail.dart';
import 'package:yepp/features/home/domain/usecase/get_location_reviews.dart';
import 'package:yepp/features/home/domain/usecase/get_restaurant_detail.dart';
part 'detail_event.dart';

part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetRestaurantDetail _getRestaurantDetail;
  final GetLocationReviews _getLocationReviews;

  DetailBloc({
    required GetRestaurantDetail getRestaurantDetail,
    required GetLocationReviews getLocationReviews,
  })  : _getRestaurantDetail = getRestaurantDetail,
        _getLocationReviews = getLocationReviews,
        super(DetailInitial()) {
    on<DetailEvent>((event, emit) {
      emit(DetailLoading());
    });

    on<DetailGetRestaurant>(_onGetRestaurantDetail);

    on<DetailGetLocationReviews>(_onGetLocationReviews);
  }

  void _onGetRestaurantDetail(
      DetailGetRestaurant event, Emitter<DetailState> emit) async {
    final res = await _getRestaurantDetail(RestaurantIdParams(event.id));
    res.fold(
      (l) => emit(DetailFailure(l.message)),
      (r) => emit(RestaurantDetailSuccess(r)),
    );
  }

  FutureOr<void> _onGetLocationReviews(
      DetailGetLocationReviews event, Emitter<DetailState> emit) async {
    final res = await _getLocationReviews(LocationReviewParams(event.id));
    res.fold(
      (l) => emit(DetailFailure(l.message)),
      (r) => emit(LocationReviewsSuccess(r)),
    );
  }
}
