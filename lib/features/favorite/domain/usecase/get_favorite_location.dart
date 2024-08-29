
import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/favorite/domain/repository/favorite_repository.dart';

class GetFavoriteLocation
    implements UseCase<List<LocalPlace>, GetFavoriteLocationParams> {

  final FavoriteRepository favoriteRepository;

  GetFavoriteLocation(this.favoriteRepository);

  @override
  Future<Either<Failure, List<LocalPlace>>> call(
      GetFavoriteLocationParams params) async{

    return favoriteRepository.getFavoritePlaces();
  }
}

class GetFavoriteLocationParams {}
