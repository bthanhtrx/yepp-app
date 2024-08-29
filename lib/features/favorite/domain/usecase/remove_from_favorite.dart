import 'package:fpdart/src/either.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/favorite/domain/repository/favorite_repository.dart';


class RemoveFromFavorite implements UseCase<void, RemoveFavoriteParams> {
  final FavoriteRepository favoriteRepository;

  RemoveFromFavorite(this.favoriteRepository);

  @override
  Future<Either<Failure, void>> call(RemoveFavoriteParams params) async {
    return favoriteRepository.toggleFavorite(params.restaurant);
  }
}

class RemoveFavoriteParams {
  final LocalPlace restaurant;

  RemoveFavoriteParams(this.restaurant);
}
