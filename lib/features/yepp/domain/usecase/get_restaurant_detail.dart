import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/core/use_case.dart';
import 'package:yepp/features/yepp/domain/entity/restaurant_detail.dart';
import 'package:yepp/features/yepp/domain/repository/yepp_repository.dart';

class GetRestaurantDetail
    implements UseCase<RestaurantDetail, RestaurantIdParams> {
  final YeppRepository yeppRepository;

  GetRestaurantDetail(this.yeppRepository);

  @override
  Future<Either<Failure, RestaurantDetail>> call(
      RestaurantIdParams params) async {
    return await yeppRepository.getRestaurantDetail(params.id);
  }
}

class RestaurantIdParams {
  final String id;

  RestaurantIdParams(this.id);
}
