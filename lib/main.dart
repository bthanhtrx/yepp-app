import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:yepp/core/network/connection_checker.dart';
import 'package:yepp/features/yepp/data/datasource/yepp_local_datasource.dart';
import 'package:yepp/features/yepp/data/datasource/yepp_remote_datasource.dart';
import 'package:yepp/features/yepp/data/repository/yepp_repository_impl.dart';
import 'package:yepp/features/yepp/domain/usecase/get_restaurant_detail.dart';
import 'package:yepp/features/yepp/domain/usecase/get_restaurants.dart';
import 'package:yepp/features/yepp/presentation/bloc/yepp_bloc.dart';
import 'package:yepp/features/yepp/presentation/pages/home_page.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => YeppBloc(
                  getRestaurants: GetRestaurants(YeppRepositoryImpl(
                      YeppRemoteDatasoureImpl(),
                      YeppLocalDatasourceImpl(Hive.box(name: 'yepp')),
                      ConnectionCheckerImpl(InternetConnection()))),
                  getRestaurantDetail: GetRestaurantDetail(YeppRepositoryImpl(
                      YeppRemoteDatasoureImpl(),
                      YeppLocalDatasourceImpl(Hive.box(name: 'yepp')),
                      ConnectionCheckerImpl(InternetConnection()))),
                ))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yepp App',
        // theme: AppTheme.lightThemeMode,
        theme: ThemeData.light().copyWith(
            textTheme: TextTheme(
                titleSmall: TextStyle(color: Colors.black38),
                titleMedium: TextStyle(color: Colors.black87),
                titleLarge: TextStyle(color: Colors.greenAccent))),
        home: const HomePage(),
      ),
    );
  }
}
