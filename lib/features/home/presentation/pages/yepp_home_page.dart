import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:yepp/core/router/app_route_constant.dart';
import 'package:yepp/core/utils/loader.dart';
import 'package:yepp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yepp/features/home/presentation/bloc/home/yepp_bloc.dart';
import 'package:yepp/features/home/presentation/widgets/custom_search_bar.dart';
import 'package:yepp/features/home/presentation/widgets/restaurant_card.dart';
import 'package:yepp/features/home/presentation/widgets/service_item.dart';
import 'package:yepp/init_dependencies.dart';

final popularPicksList = [
  {'Burger': const Icon(Icons.bolt)},
  {'Pizza': const Icon(Icons.local_pizza_outlined)},
  {'Drinks': const Icon(Icons.local_drink_outlined)},
  {'Dessert': const Icon(Icons.dining_outlined)},
  {'Seafood': const Icon(Icons.fitbit_sharp)},
];

class YeppHomePage extends StatefulWidget {
  const YeppHomePage({super.key});

  @override
  State<YeppHomePage> createState() => _YeppHomePageState();
}

class _YeppHomePageState extends State<YeppHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Yepp!',
                  style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                // BlocBuilder<AuthBloc, AuthState>(
                //   builder: (context, state) {
                //     if (state is AuthAuthenticated) {
                //       return Text(
                //         'Hello ${state.user.userName ?? ''}',
                //         style: Theme.of(context).textTheme.titleLarge,
                //       );
                //     }
                //
                //     if(state is AuthUnauthenticated) {
                //       return Text('Hi!');
                //     }
                //     return SizedBox.shrink();
                //   },
                // ),
                Icon(
                  Icons.notifications_outlined,
                  size: 25,
                ),
              ],
            ),
            CustomSearchBar(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              for (final item in popularPicksList)
                GestureDetector(
                    onTap: () {context.pushNamed(AppRouteConstant.placeListingsRoute, extra: item.keys.first);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             RestaurantsList(type: item.keys.first)));
                    },
                    child: ServiceItem(
                        name: item.keys.first, badge: item.values.first))
            ]),
            const Gap(20),
            Text(
              'Attractions Nearby ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 20),
            ),
            BlocProvider(
              create: (context) => YeppBloc(getRestaurants: sl())
                ..add(YeppGetRestaurants('', 'boston', 0)),
              child: BlocConsumer<YeppBloc, YeppState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    // context.read<YeppBloc>().add(YeppGetRestaurants('', ''));
                    if (state is YeppFailure) {
                      print(state.message);
                      return Center(
                        child: Text(
                          '${state.message}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      );
                    }
                    if (state is YeppLoading) {
                      return const Loader();
                    }

                    if (state is! YeppNearbyListRestaurantsSuccess) {
                      return const SizedBox();
                    }

                    final listRestaurants = state.listRestaurants;

                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5),
                        itemBuilder: (context, index) {
                          final item = listRestaurants[index];
                          return RestaurantCard(
                            restaurant: item,
                          );
                        },
                        itemCount: listRestaurants.length);
                  }),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
