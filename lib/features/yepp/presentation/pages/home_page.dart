import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:yepp/core/utils/loader.dart';
import 'package:yepp/features/yepp/presentation/bloc/yepp_bloc.dart';
import 'package:yepp/features/yepp/presentation/pages/favorite_page.dart';
import 'package:yepp/features/yepp/presentation/pages/restaurants_list.dart';
import 'package:yepp/features/yepp/presentation/widgets/bottom_nav_bar.dart';
import 'package:yepp/features/yepp/presentation/widgets/custom_search_bar.dart';
import 'package:yepp/features/yepp/presentation/widgets/restaurant_card.dart';
import 'package:yepp/features/yepp/presentation/widgets/service_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final popularPicksList = [
    {'Burger': Icon(Icons.bolt)},
    {'Pizza': Icon(Icons.local_pizza_outlined)},
    {'Drinks': Icon(Icons.local_drink_outlined)},
    {'Dessert': Icon(Icons.dining_outlined)},
    {'Seafood': Icon(Icons.fitbit_sharp)},
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    context.read<YeppBloc>().add(YeppGetRestaurants('', ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: _selectedIndex == 0 ? Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 100),
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome User',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Icon(
                        Icons.notifications_outlined,
                        size: 25,
                      ),
                    ],
                  ),
                  CustomSearchBar(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final item in popularPicksList)
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RestaurantsList(
                                            type: item.keys.first)));
                              },
                              child: ServiceItem(
                                  name: item.keys.first,
                                  badge: item.values.first))
                      ]),
                  const Gap(20),
                  Text(
                    'Restaurants Nearby ',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.black, fontSize: 20),
                  ),
                  BlocConsumer<YeppBloc, YeppState>(
                      listener: (context, state) {},
                      builder: (context, state) {
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

                        if (state is! YeppListRestaurantsSuccess) {
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
                      })
                ],
              ),
            ),
          ),
          // Positioned(
          //     bottom: 10,
          //     left: 10,
          //     right: 10,
          //     child: BottomNavBar(
          //       navigateToScreen: (index) {
          //         Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => index == 0
          //               ? HomePage()
          //               : index == 2
          //                   ? FavoritePage()
          //                   : Container(),
          //         ));
          //       },
          //     )),
        ],
      ): FavoritePage(),
      bottomNavigationBar: BottomNavigationBar(

        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Favorite',
            icon: Icon(Icons.favorite),
          )
        ],
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        currentIndex: _selectedIndex,
        elevation: 0,

      ),
    );
  }
}
