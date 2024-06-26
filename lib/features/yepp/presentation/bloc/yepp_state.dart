part of 'yepp_bloc.dart';

@immutable
sealed class YeppState {}

final class YeppInitial extends YeppState {}

final class YeppLoading extends YeppState {}

final class YeppFailure extends YeppState {
  final String message;

  YeppFailure(this.message);
}

final class YeppListRestaurantsSuccess extends YeppState {
  final List<Restaurant> listRestaurants;

  YeppListRestaurantsSuccess(this.listRestaurants);
}

final class YeppRestaurantDetailSuccess extends YeppState {
  final RestaurantDetail restaurantDetail;

  YeppRestaurantDetailSuccess(this.restaurantDetail);
}