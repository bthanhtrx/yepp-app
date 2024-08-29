part of 'favorite_bloc.dart';

sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteFailure extends FavoriteState {
  final String message;

  FavoriteFailure(this.message);
}

final class FavoriteLoadSuccess extends FavoriteState {
  final List<LocalPlace> list;

  FavoriteLoadSuccess(this.list);
}

final class FavoriteToggleSuccess extends FavoriteState {}

final class FavoriteSingleItemStatus extends FavoriteState {
  final bool isExist;

  FavoriteSingleItemStatus(this.isExist);
}
