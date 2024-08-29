part of 'yepp_bloc.dart';

@immutable
sealed class YeppEvent extends Equatable {
  const YeppEvent();

  @override
  List<Object> get props => [];
}

final class YeppGetRestaurants extends YeppEvent {
  final String term;
  final String location;
  final int offset;

  YeppGetRestaurants(this.term, this.location, this.offset);
}

final class YeppAddToFavorite extends YeppEvent {}
final class YeppRemoveFavorite extends YeppEvent {}
final class YeppGetFavorites extends YeppEvent {}
