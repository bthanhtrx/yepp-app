part of 'yepp_bloc.dart';

@immutable
sealed class YeppEvent {}

final class YeppGetRestaurants extends YeppEvent {
  final String term;
  final String location;

  YeppGetRestaurants(this.term, this.location);
}

final class YeppGetRestaurantDetail extends YeppEvent {
  final String id;

  YeppGetRestaurantDetail(this.id);
}