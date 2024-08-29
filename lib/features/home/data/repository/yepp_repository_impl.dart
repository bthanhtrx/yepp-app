import 'package:fpdart/src/either.dart';
import 'package:yepp/core/error/exception.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/core/network/connection_checker.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/features/home/data/datasource/yepp_local_datasource.dart';
import 'package:yepp/features/home/data/datasource/yepp_remote_datasource.dart';
import 'package:yepp/features/home/domain/entity/location_review.dart';
import 'package:yepp/features/home/domain/entity/restaurant_detail.dart';
import 'package:yepp/features/home/domain/repository/yepp_repository.dart';
class YeppRepositoryImpl implements YeppRepository {
  final YeppRemoteDatasource yeppRemoteDatasource;
  final YeppLocalDatasource yeppLocalDatasource;
  final ConnectionChecker connectionChecker;

  YeppRepositoryImpl(this.yeppRemoteDatasource, this.yeppLocalDatasource,
      this.connectionChecker);

  @override
  Future<Either<Failure, List<LocalPlace>>> getRestaurants(
      {required String term,
      required String location,
      required int offset}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final list = yeppLocalDatasource.loadYepp();
        return Either.right(list);
      } else {
        var list = await yeppRemoteDatasource.getRestaurants(
            term: term, location: location, offset: offset);
        yeppLocalDatasource.saveToLocal(yepp: list);

        return Either.right(list);
      }
    } on NetworkException catch (e) {
      return Either.left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, RestaurantDetail>> getRestaurantDetail(
      String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Either.left(Failure('No Internet Connection'));
      }
      var restaurantDetail = await yeppRemoteDatasource.getRestaurantDetail(id);
      return Either.right(restaurantDetail);
    } on NetworkException catch (e) {
      return Either.left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<LocationReview>>> getLocationReviews(String id) async{
    try {
      var yeppReviews =await yeppRemoteDatasource.getYeppReviews(id);
      return Either.right(yeppReviews);
    } on NetworkException catch(e) {
      return Either.left(Failure(e.message));
    }
  }
}
