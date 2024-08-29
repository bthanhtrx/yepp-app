import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/home/data/model/restaurant_model.dart';

abstract interface class FavoriteRepository {
  Future<Either<Failure, List<LocalPlace>>> getFavoritePlaces();

  Either<Failure, void> toggleFavorite(LocalPlace restaurant);

  Future<Either<Failure, bool>> isFavorite(LocalPlace location);
}
