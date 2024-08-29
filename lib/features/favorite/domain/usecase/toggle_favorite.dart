
import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/favorite/domain/repository/favorite_repository.dart';

class ToggleFavorite implements UseCase<void, ToggleFavoriteParams> {
  final FavoriteRepository favoriteRepository;

  ToggleFavorite(this.favoriteRepository);

  @override
  Future<Either<Failure, void>> call(ToggleFavoriteParams params) async {
    return favoriteRepository.toggleFavorite(params.restaurant);
  }
}

class ToggleFavoriteParams {
  final LocalPlace restaurant;

  ToggleFavoriteParams(this.restaurant);
}
