import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yepp/core/app/home_page.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/core/router/app_route_constant.dart';
import 'package:yepp/features/favorite/presentation/pages/favorite_page.dart';
import 'package:yepp/features/settings/presentation/pages/settings_screen.dart';
import 'package:yepp/features/home/presentation/pages/restaurant_page.dart';
import 'package:yepp/features/home/presentation/pages/restaurants_list.dart';
import 'package:yepp/features/home/presentation/pages/yepp_home_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

const String homePath = '/';
const String placeListings = '/listings';
const String homeNavPath = '/home';
const String favoriteNavPath = '/favorite';
const String settingsNavPath = '/settings';
const String detailPath = '/detail';

class AppRouter {
  static final router = GoRouter(
    // navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
          builder: (context, state, child) => HomePage(
                child: child,
              ),
          routes: [
            // GoRoute(
            //   path: homePath,
            //   name: AppRouteConstant.homeRoute,
            //   builder: (context, state) => HomePage(),
            // ),
            GoRoute(
              path: homeNavPath,
              name: AppRouteConstant.homeNavigationRoute,
              builder: (context, state) => YeppHomePage(),
            ),
            GoRoute(
              path: favoriteNavPath,
              name: AppRouteConstant.favoriteNavigationRoute,
              builder: (context, state) => FavoritePage(),
            ),
            GoRoute(
              path: settingsNavPath,
              name: AppRouteConstant.settingsNavigationRoute,
              builder: (context, state) => SettingsScreen(),
            ),
          ],),
          GoRoute(path: placeListings, name: AppRouteConstant.placeListingsRoute, builder: (context, state) {
            final String type = state.extra as String;
            return RestaurantsList(type: type);
          }),
          GoRoute(
            path: detailPath,
            name: AppRouteConstant.detailRoute,
            builder: (context, state) {
              final LocalPlace restaurant = state.extra as LocalPlace;
              return RestaurantPage(restaurant: restaurant);
            },
          )
    ],
    redirect: (context, state) {},
    initialLocation: homeNavPath,
    errorPageBuilder: (context, state) =>
        const MaterialPage(child: Text('No Route')),
  );
}
