
import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/core/common/usecase/use_case.dart';
import 'package:yepp/features/home/domain/entity/location_review.dart';
import 'package:yepp/features/home/domain/repository/yepp_repository.dart';
class GetLocationReviews
    implements UseCase<List<LocationReview>, LocationReviewParams> {
  final YeppRepository repository;

  GetLocationReviews(this.repository);

  @override
  Future<Either<Failure, List<LocationReview>>> call(
      LocationReviewParams params) async {
    return await repository.getLocationReviews(params.id);
  }
}

class LocationReviewParams {
  final String id;

  LocationReviewParams(this.id);
}
