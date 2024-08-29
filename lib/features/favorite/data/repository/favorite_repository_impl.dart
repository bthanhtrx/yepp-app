import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/core/error/failure.dart';
import 'package:yepp/features/favorite/data/datasource/favorite_local_datasource.dart';
import 'package:yepp/features/favorite/data/datasource/favorite_remote_datasource.dart';
import 'package:yepp/features/favorite/domain/repository/favorite_repository.dart';
import 'package:yepp/features/home/data/model/restaurant_model.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDatasource favoriteRemoteDatasource;
  final FavoriteLocalDatasource favoriteLocalDatasource;
  final FirebaseAuth firebaseAuth;

  FavoriteRepositoryImpl(
      {required this.favoriteRemoteDatasource,
      required this.favoriteLocalDatasource,
      required this.firebaseAuth});

  @override
  Future<Either<Failure, List<LocalPlace>>> getFavoritePlaces() async {
    try {
      List<LocalPlace> result = [];

      if (firebaseAuth.currentUser != null) {
        result = await favoriteRemoteDatasource.getAllFavoritesRemote();
      } else {
        result = favoriteLocalDatasource.getFavoriteLocal();
      }


      return Either.right(result);
    } catch (e) {
      return Either.left(Failure(e.toString()));
    }
  }

  @override
  Either<Failure, void> toggleFavorite(LocalPlace restaurant) {
    try {
      if (firebaseAuth.currentUser != null) {
        favoriteRemoteDatasource
            .addFavoriteRemote(LocalPlaceModel.fromEntity(restaurant));

      } else {
        favoriteLocalDatasource.addOrRemoveToDb(
            yepp: LocalPlaceModel.fromEntity(restaurant));
      }
      return Either.right('ok');
    } catch (e) {
      return Either.left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(LocalPlace location) async{
    try {
      if(firebaseAuth.currentUser != null) {
        final isFav = await favoriteRemoteDatasource.isFavoriteRemote(LocalPlaceModel.fromEntity(location));
        return Either.right(isFav);
      } else {

      final isFav = favoriteLocalDatasource.isFavoriteLocal(
          location: LocalPlaceModel.fromEntity(location));
      return Either.right(isFav);
      }
    } catch (e) {
      return Either.left(Failure(e.toString()));
    }
  }
}
