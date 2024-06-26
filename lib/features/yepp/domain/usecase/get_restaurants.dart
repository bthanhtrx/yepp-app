
import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/core/use_case.dart';
import 'package:yepp/features/yepp/domain/entity/restaurant.dart';
import 'package:yepp/features/yepp/domain/repository/yepp_repository.dart';

class GetRestaurants implements UseCase<List<Restaurant>, ListRestaurantsParams> {
  final YeppRepository yeppRepository;

  GetRestaurants(this.yeppRepository);

  @override
  Future<Either<Failure, List<Restaurant>>> call(ListRestaurantsParams params) async {
    return await yeppRepository.getRestaurants(params.term);
  }
}

class ListRestaurantsParams{
  final String term;
  final String location;

  ListRestaurantsParams(this.term, this.location);
}