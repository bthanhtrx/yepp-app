import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:yepp/core/network/connection_checker.dart';
import 'package:yepp/core/utils/loader.dart';
import 'package:yepp/features/home/data/datasource/yepp_local_datasource.dart';
import 'package:yepp/features/home/data/datasource/yepp_remote_datasource.dart';
import 'package:yepp/features/home/data/repository/yepp_repository_impl.dart';
import 'package:yepp/features/home/domain/usecase/get_restaurants.dart';
import 'package:yepp/features/home/presentation/bloc/home/yepp_bloc.dart';
import 'package:yepp/features/home/presentation/widgets/restaurant_card.dart';
import 'package:yepp/init_dependencies.dart';

class RestaurantsList extends StatefulWidget {
  final String type;

  const RestaurantsList({super.key, required this.type});

  @override
  State<RestaurantsList> createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  final scrollController = ScrollController();
  int offset = 0;
  bool isLoading = false;
final bloc = YeppBloc(
    getRestaurants: sl());
  @override
  void initState() {
    // context.read<YeppBloc>().add(YeppGetRestaurants(widget.type, ''));
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type),),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            const Gap(20),
            BlocProvider(
              create: (context) =>
                YeppBloc(getRestaurants: GetRestaurants(YeppRepositoryImpl(YeppRemoteDatasoureImpl(), YeppLocalDatasourceImpl(Hive.box()), ConnectionCheckerImpl(InternetConnection()))))..add(YeppGetRestaurants(widget.type, 'boston', offset)),
              child: BlocConsumer<YeppBloc, YeppState>(
                builder: (context, state) {
                  if (state is YeppLoading) {
                    return const Loader();
                  }
                  if (state is YeppFailure) {
                    print('Error: ${state.message}');
                    return Text(state.message);
                  }
                  if (state is! YeppNearbyListRestaurantsSuccess) {
                    return const SizedBox();
                  }


                  var list = state.listRestaurants;

                  return Scrollbar(thickness: 2,radius: Radius.circular(10), interactive: true, thumbVisibility: true,
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5),
                        itemBuilder: (context, index) {
                          final item = list[index];
                          return RestaurantCard(
                            restaurant: item,
                          );
                        },
                        itemCount: list.length),
                  );
                },
                listener: (context, state) {

                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _scrollListener() {
    if(isLoading) return;

    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {

      offset += 20;
      bloc.add(YeppGetRestaurants(widget.type, 'boston', offset));

    }
  }
}
