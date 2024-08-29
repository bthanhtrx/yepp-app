import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yepp/core/network/connection_checker.dart';
import 'package:yepp/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:yepp/features/auth/data/repository/auth_repository_impl.dart';
import 'package:yepp/features/auth/domain/repository/auth_repository.dart';
import 'package:yepp/features/auth/domain/usecase/get_current_user.dart';
import 'package:yepp/features/auth/domain/usecase/yepp_login.dart';
import 'package:yepp/features/auth/domain/usecase/yepp_signout.dart';
import 'package:yepp/features/auth/domain/usecase/yepp_signup.dart';
import 'package:yepp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yepp/features/favorite/data/datasource/favorite_local_datasource.dart';
import 'package:yepp/features/favorite/data/datasource/favorite_remote_datasource.dart';
import 'package:yepp/features/favorite/data/repository/favorite_repository_impl.dart';
import 'package:yepp/features/favorite/domain/repository/favorite_repository.dart';
import 'package:yepp/features/favorite/domain/usecase/get_favorite_location.dart';
import 'package:yepp/features/favorite/domain/usecase/get_is_favorite.dart';
import 'package:yepp/features/favorite/domain/usecase/remove_from_favorite.dart';
import 'package:yepp/features/favorite/domain/usecase/toggle_favorite.dart';
import 'package:yepp/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:yepp/features/home/data/datasource/yepp_local_datasource.dart';
import 'package:yepp/features/home/data/datasource/yepp_remote_datasource.dart';
import 'package:yepp/features/home/data/repository/yepp_repository_impl.dart';
import 'package:yepp/features/home/domain/repository/yepp_repository.dart';
import 'package:yepp/features/home/domain/usecase/get_location_reviews.dart';
import 'package:yepp/features/home/domain/usecase/get_restaurant_detail.dart';
import 'package:yepp/features/home/domain/usecase/get_restaurants.dart';
import 'package:yepp/features/home/presentation/bloc/detail/detail_bloc.dart';
import 'package:yepp/features/home/presentation/bloc/home/yepp_bloc.dart';

final sl = GetIt.instance;

class InitDependencies {
  static Future<void> init() async {
    // core
    Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

    sl.registerLazySingleton<Box>(() => Hive.box(name: 'favorites'),
        instanceName: 'favorites');

    sl.registerFactory<Box>(() => Hive.box(name: 'yepp'), instanceName: 'yepp');
    sl.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(sl()),
    );

    sl.registerFactory(
      () => InternetConnection(),
    );

    sl.registerLazySingleton(
      () => FirebaseAuth.instance,
    );

    sl.registerLazySingleton(
      () => FirebaseFirestore.instance,
    );
    // datasource
    // sl..registerFactory<AuthRemoteDataSource>(
    //     () => AuthRemoteDataSourceImpl(sl<FirebaseAuth>(), sl<FirebaseFirestore>()))..
    // registerFactory<AuthRepository>(
    //       () => AuthRepositoryImpl(sl()),
    // )..registerLazySingleton(
    //       () => YeppLogin(sl()),
    // )..registerLazySingleton(() => YeppSignup(sl()))
    // ..registerLazySingleton(
    //       () => YeppSignout(sl()),
    // )..
    // registerLazySingleton(() => GetCurrentUser(sl()))..
    // registerFactory(
    //       () => AuthBloc(
    //     yeppLogin: sl(),
    //     yeppSignUp: sl(),
    //     yeppSignout: sl(),
    //     getCurrentUser: sl(),
    //   ),
    // );

    sl.registerLazySingleton<YeppRemoteDatasource>(
      () => YeppRemoteDatasoureImpl(),
    );
    sl.registerLazySingleton<YeppLocalDatasource>(
      () => YeppLocalDatasourceImpl(sl(instanceName: 'yepp')),
    );
    sl.registerLazySingleton<FavoriteRemoteDatasource>(() =>
        FavoriteRemoteDatasourceImpl(firestore: sl(), firebaseAuth: sl()));

    sl.registerLazySingleton<FavoriteLocalDatasource>(
      () => FavoriteLocalDatasourceImpl(sl(instanceName: 'favorites')),
    );

    // repository


    sl.registerLazySingleton<YeppRepository>(
      () => YeppRepositoryImpl(sl(), sl(), sl()),
    );
    sl.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(
          favoriteRemoteDatasource: sl(),
          favoriteLocalDatasource: sl(),
          firebaseAuth: sl()),
    );

    // usecases

    sl.registerLazySingleton(
      () => GetRestaurants(sl()),
    );
    sl.registerLazySingleton(
      () => GetRestaurantDetail(sl()),
    );
    sl.registerLazySingleton(
      () => GetLocationReviews(sl()),
    );
    sl.registerLazySingleton(
      () => GetFavoriteLocation(sl()),
    );
    sl.registerLazySingleton(
      () => GetIsFavorite(sl()),
    );
    sl.registerLazySingleton(
      () => RemoveFromFavorite(sl()),
    );
    sl.registerLazySingleton(
      () => ToggleFavorite(sl()),
    );

    // bloc
    sl.registerFactory(
      () => YeppBloc(getRestaurants: sl()),
    );

    sl.registerFactory(
      () => DetailBloc(getRestaurantDetail: sl(), getLocationReviews: sl()),
    );

    sl.registerFactory(() => FavoriteBloc(
        getFavoriteLocation: sl(), addToFavorite: sl(), getIsFavorite: sl()));


  }
}
