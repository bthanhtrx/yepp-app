part of 'yepp_bloc.dart';

@immutable
sealed class YeppState {}

final class YeppInitial extends YeppState {}

final class YeppLoading extends YeppState {}

final class YeppFailure extends YeppState {
  final String message;

  YeppFailure(this.message);
}

final class YeppNearbyListRestaurantsSuccess extends YeppState {
  final List<LocalPlace> listRestaurants;

  YeppNearbyListRestaurantsSuccess(this.listRestaurants);
}
