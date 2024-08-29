
import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/favorite/domain/repository/favorite_repository.dart';

class GetIsFavorite implements UseCase<bool, LocationParams> {
  final FavoriteRepository favoriteRepository;

  GetIsFavorite(this.favoriteRepository);

  @override
  Future<Either<Failure, bool>> call(LocationParams params) async{
    return favoriteRepository.isFavorite(params.restaurant);
  }



}

class LocationParams {
  final LocalPlace restaurant;

  LocationParams(this.restaurant);
}