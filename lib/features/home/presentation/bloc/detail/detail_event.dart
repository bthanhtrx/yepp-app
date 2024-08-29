part of 'detail_bloc.dart';

@immutable
sealed class DetailEvent {}

final class DetailGetRestaurant extends DetailEvent {
  final String id;

  DetailGetRestaurant(this.id);
}

final class DetailGetLocationReviews extends DetailEvent {
  final String id;

  DetailGetLocationReviews(this.id);


}