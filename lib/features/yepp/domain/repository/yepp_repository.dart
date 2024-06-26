import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/yepp/domain/entity/restaurant.dart';
import 'package:fpdart/fpdart.dart';
import 'package:yepp/features/yepp/domain/entity/restaurant_detail.dart';

abstract interface class YeppRepository {
  Future<Either<Failure, List<Restaurant>>> getRestaurants(String term);
  Future<Either<Failure, RestaurantDetail>> getRestaurantDetail(String id);
}