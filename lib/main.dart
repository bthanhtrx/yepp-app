import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yepp/core/common/cubit/theme_cubit.dart';
import 'package:yepp/core/router/app_route_config.dart';
import 'package:yepp/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:yepp/features/auth/data/repository/auth_repository_impl.dart';
import 'package:yepp/features/auth/domain/usecase/get_current_user.dart';
import 'package:yepp/features/auth/domain/usecase/yepp_login.dart';
import 'package:yepp/features/auth/domain/usecase/yepp_signout.dart';
import 'package:yepp/features/auth/domain/usecase/yepp_signup.dart';
import 'package:yepp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yepp/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:yepp/features/home/presentation/bloc/home/yepp_bloc.dart';
import 'package:yepp/firebase_options.dart';
import 'package:yepp/init_dependencies.dart';

import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await InitDependencies.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          AuthBloc(
            yeppSignUp: YeppSignup(
                AuthRepositoryImpl(AuthRemoteDataSourceImpl(sl(), sl()))),
            yeppLogin: YeppLogin(
                AuthRepositoryImpl(AuthRemoteDataSourceImpl(sl(), sl()))),
            yeppSignout: YeppSignout(
                AuthRepositoryImpl(AuthRemoteDataSourceImpl(sl(), sl()))),
            getCurrentUser: GetCurrentUser(
                AuthRepositoryImpl(AuthRemoteDataSourceImpl(sl(), sl()))),
          )
            ..add(GetCurrentUserEvent()),
        ),
        BlocProvider(create: (context) => sl<YeppBloc>()),
        BlocProvider(create: (context) => sl<FavoriteBloc>()),
        BlocProvider(create: (context) => ThemeCubit(),),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Yepp App',
            theme: state,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
