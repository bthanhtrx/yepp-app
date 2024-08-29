part of 'detail_bloc.dart';

@immutable
sealed class DetailState {}

final class DetailInitial extends DetailState {}

final class DetailLoading extends DetailState {}

final class DetailFailure extends DetailState {
  final String message;

  DetailFailure(this.message);

}

final class RestaurantDetailSuccess extends DetailState {
  final RestaurantDetail restaurantDetail;

  RestaurantDetailSuccess(this.restaurantDetail);
}

final class LocationReviewsSuccess extends DetailState {
  final List<LocationReview> listReviews;

  LocationReviewsSuccess(this.listReviews);
}