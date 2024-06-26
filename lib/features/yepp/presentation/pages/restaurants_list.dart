import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:yepp/core/utils/loader.dart';
import 'package:yepp/features/yepp/presentation/bloc/yepp_bloc.dart';
import 'package:yepp/features/yepp/presentation/widgets/restaurant_card.dart';

class RestaurantsList extends StatefulWidget {
  final String type;
  const RestaurantsList({super.key, required this.type});

  @override
  State<RestaurantsList> createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  @override
  void initState() {
    context.read<YeppBloc>().add(YeppGetRestaurants(widget.type, ''));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(20),
            BlocConsumer<YeppBloc, YeppState>(
              builder: (context, state) {
                if(state is YeppLoading) {
                  return const Loader();
                }
                if(state is YeppFailure) {
                  return Text(state.message);
                }
                if(state is! YeppListRestaurantsSuccess) {
                  return const SizedBox();
                }

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
                      final item =state.listRestaurants[index];
                      return RestaurantCard(
                        restaurant: item,
                      );
                    },
                    itemCount: state.listRestaurants.length);
              },
              listener: (context, state) {},
            )
          ],
        ),
      ),
    );
  }
}
