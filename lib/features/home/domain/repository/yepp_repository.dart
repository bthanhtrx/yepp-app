import 'package:yepp/core/error/failure.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:fpdart/fpdart.dart';
import 'package:yepp/features/home/domain/entity/location_review.dart';
import 'package:yepp/features/home/domain/entity/restaurant_detail.dart';
abstract interface class YeppRepository {
  Future<Either<Failure, List<LocalPlace>>> getRestaurants(
      {required String term, required String location, required int offset});

  Future<Either<Failure, RestaurantDetail>> getRestaurantDetail(String id);

  Future<Either<Failure, List<LocationReview>>> getLocationReviews(String id);
}
