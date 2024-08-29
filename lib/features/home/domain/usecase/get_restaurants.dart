import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/features/home/domain/repository/yepp_repository.dart';
class GetRestaurants
    implements UseCase<List<LocalPlace>, ListRestaurantsParams> {
  final YeppRepository yeppRepository;

  GetRestaurants(this.yeppRepository);

  @override
  Future<Either<Failure, List<LocalPlace>>> call(
      ListRestaurantsParams params) async {
    return await yeppRepository.getRestaurants(
        term: params.term, location: params.location, offset: params.offset);
  }
}

class ListRestaurantsParams {
  final String term;
  final String location;
  final int offset;

  ListRestaurantsParams(this.term, this.location, this.offset);
}
