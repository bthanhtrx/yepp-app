part of 'favorite_bloc.dart';

sealed class FavoriteEvent {}

class FavoriteGetAll extends FavoriteEvent {}

class FavoriteToggle extends FavoriteEvent {
  final LocalPlace location;

  FavoriteToggle(this.location);
}

class FavoriteGetIsFavoriteEvent extends FavoriteEvent {
  final LocalPlace location;

  FavoriteGetIsFavoriteEvent(this.location);
}