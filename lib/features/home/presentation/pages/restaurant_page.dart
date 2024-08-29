import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yepp/core/utils/loader.dart';
import 'package:yepp/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/features/home/domain/entity/location_review.dart';
import 'package:yepp/features/home/presentation/bloc/detail/detail_bloc.dart';
import 'package:yepp/features/home/presentation/widgets/service_item.dart';
import 'package:yepp/init_dependencies.dart';

class RestaurantPage extends StatefulWidget {
  final LocalPlace restaurant;

  const RestaurantPage({super.key, required this.restaurant});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final detailBloc =
      DetailBloc(getLocationReviews: sl(), getRestaurantDetail: sl());

  final favoriteBloc = FavoriteBloc(
      addToFavorite: sl(), getFavoriteLocation: sl(), getIsFavorite: sl());

  @override
  void initState() {
    // context.read<DetailBloc>().add(DetailGetRestaurant(widget.restaurant.id));
    // context
    //     .read<FavoriteBloc>()
    //     .add(FavoriteGetIsFavoriteEvent(widget.restaurant));
    super.initState();
  }

  List<LocationReview> listReviews = [];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: BlocProvider(
        create: (context) =>
            favoriteBloc..add(FavoriteGetIsFavoriteEvent(widget.restaurant)),
        child: FloatingActionButton(
          onPressed: () {
            favoriteBloc.add(FavoriteToggle(widget.restaurant));
          },

          child: BlocConsumer<FavoriteBloc, FavoriteState>(
            buildWhen: (previous, current) =>
                current is FavoriteSingleItemStatus,
            builder: (context, state) {
              if (state is! FavoriteSingleItemStatus) return const SizedBox.shrink();
              // context.read<FavoriteBloc>().add(FavoriteGetAll());
              return state.isExist
                  ? const Icon(
                      Icons.favorite_outlined,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_outline,
                      color: Colors.greenAccent,
                    );
            },
            listener: (context, state) {
              // if (state is FavoriteSingleItemStatus) {
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //       content: Text(state.isExist
              //           ? 'Added To Favorites'
              //           : 'Removed From Favorites')));
              // }
            },
          ),
        ),
      ),
      // appBar: AppBar(title: Text("name"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(20),
              Center(
                child: BlocProvider(
                  create: (context) => detailBloc
                    ..add(DetailGetRestaurant(widget.restaurant.id))
                    ..add(DetailGetLocationReviews(widget.restaurant.id)),
                  child: BlocBuilder<DetailBloc, DetailState>(
                    builder: (context, state) {
                      if (state is DetailLoading) {
                        return const Loader();
                      }

                      if (state is DetailFailure) {
                        return Text(
                          state.message,
                          style: Theme.of(context).textTheme.titleLarge,
                        );
                      }

                      if (state is LocationReviewsSuccess) {
                        listReviews.addAll(state.listReviews);
                      }

                      if (state is! RestaurantDetailSuccess) {
                        return const SizedBox();
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: const Icon(Icons.arrow_back),
                                onTap: () {
                                  // context
                                  //     .read<DetailBloc>()
                                  //     .add(DetailGetRestaurant(''));
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                'Location Details',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox.shrink()
                            ],
                          ),
                          const Gap(20),
                          GestureDetector(
                            onTap: () {
                              final multiImageProvider = MultiImageProvider(
                                  state.restaurantDetail.photos!
                                      .map(
                                        (e) => NetworkImage(e),
                                      )
                                      .toList());
                              showImageViewerPager(context, multiImageProvider,
                                  onPageChanged: (page) {

                              }, onViewerDismissed: (page) {
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.warning);
                                },
                                state.restaurantDetail.imageUrl!,
                                width: screenWidth,
                                height: screenHeight * 0.4,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  state.restaurantDetail.name!,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => showModalBottomSheet(
                                  enableDrag: true,
                                  backgroundColor: Colors.greenAccent.shade200,
                                  showDragHandle: true,
                                  builder: (context) {
                                    return SizedBox.fromSize(
                                      size: Size(screenWidth, screenHeight / 2),
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          height: 10,
                                        ),
                                        itemBuilder: (context, index) => Card(
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.all(10),
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  listReviews[index]
                                                      .user
                                                      .imageUrl),
                                            ),
                                            title: Text(
                                              listReviews[index].user.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            subtitle: Column(
                                              children: [
                                                Text(listReviews[index].text),
                                                RatingBar(
                                                  onRatingUpdate: (_) {},
                                                  ratingWidget: RatingWidget(
                                                      full: const Icon(
                                                        Icons.star_outlined,
                                                        color: Colors.yellow,
                                                      ),
                                                      half: const Icon(
                                                          Icons
                                                              .star_half_outlined,
                                                          color: Colors.yellow),
                                                      empty: const Icon(
                                                          Icons
                                                              .star_border_outlined,
                                                          color:
                                                              Colors.yellow)),
                                                  initialRating:
                                                      listReviews[index]
                                                          .rating
                                                          .toDouble(),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        itemCount: listReviews.length,
                                      ),
                                    );
                                  },
                                  context: context,
                                ),
                                child: Row(
                                  children: [
                                    RatingBar(
                                      itemSize: 20,
                                      glowColor: Colors.yellow,
                                      initialRating:
                                          state.restaurantDetail.rating!,
                                      ratingWidget: RatingWidget(
                                          full: const Icon(
                                            Icons.star_outlined,
                                            color: Colors.yellow,
                                          ),
                                          half: const Icon(
                                              Icons.star_half_outlined,
                                              color: Colors.yellow),
                                          empty: const Icon(
                                              Icons.star_border_outlined,
                                              color: Colors.yellow)),
                                      onRatingUpdate: (value) {},
                                      allowHalfRating: true,
                                      maxRating: 5.0,
                                      minRating: 0.0,
                                      itemCount: 5,
                                      ignoreGestures: true,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        '${state.restaurantDetail.rating}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Gap(20),
                          Text(
                              '${state.restaurantDetail.location?.displayAddress.join(' ')}',
                              style: Theme.of(context).textTheme.titleSmall),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ServiceItem(
                                  badge: const Icon(
                                      Icons.door_front_door_outlined),
                                  name: state.restaurantDetail.isClosed!
                                      ? 'Closed'
                                      : 'Open Now'),
                              ServiceItem(
                                  badge: Text(
                                    '${state.restaurantDetail.reviewCount}',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  name: 'Reviews'),
                              ServiceItem(
                                  badge: Text('${state.restaurantDetail.price}',
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  name: 'Price'),
                              ServiceItem(
                                  badge: const Icon(Icons.verified_outlined),
                                  name: state.restaurantDetail.isClaimed!
                                      ? 'Claimed'
                                      : 'Unclaimed'),
                            ],
                          ),
                          const Gap(20),
                          Container(
                            width: 300,
                            height: 300,
                            child: FlutterMap(
                              options: MapOptions(
                                  interactionOptions: const InteractionOptions(
                                      flags: InteractiveFlag.doubleTapZoom |
                                          InteractiveFlag.drag),
                                  cameraConstraint:
                                      CameraConstraint.containCenter(
                                          bounds: LatLngBounds(
                                    LatLng(
                                        state.restaurantDetail.coordinates!
                                                .latitude -
                                            0.01,
                                        state.restaurantDetail.coordinates!
                                                .longitude -
                                            0.01),
                                    LatLng(
                                        state.restaurantDetail.coordinates!
                                                .latitude +
                                            0.01,
                                        state.restaurantDetail.coordinates!
                                                .longitude +
                                            0.01),
                                  )),
                                  initialCenter: LatLng(
                                      state.restaurantDetail.coordinates!
                                          .latitude,
                                      state.restaurantDetail.coordinates!
                                          .longitude),
                                  initialZoom: 15,
                                  maxZoom: 20,
                                  minZoom: 5),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.yepp',
                                ),
                                MarkerLayer(markers: [
                                  Marker(
                                    point: LatLng(
                                        state.restaurantDetail.coordinates!
                                            .latitude,
                                        state.restaurantDetail.coordinates!
                                            .longitude),
                                    child: const Icon(
                                      Icons.pin_drop,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  )
                                ]),
                              ],
                            ),
                          ),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              actionTile(
                                  const Icon(Icons.phone_outlined), 'Order Now',
                                  () async {
                                await launchUrl(Uri(
                                    scheme: 'tel',
                                    path: state.restaurantDetail.phone));
                              }),
                              actionTile(
                                  const Icon(Icons.circle_outlined), 'Visit ',
                                  () async {
                                await launchUrl(
                                    Uri.parse(state.restaurantDetail.url!));
                              }),
                              actionTile(const Icon(Icons.map_outlined),
                                  'Show on map', () {}),
                            ],
                          ),
                          // Text('${state.restaurantDetail.coordinates}',
                          //     style: Theme.of(context).textTheme.titleSmall),
                          // Text('${state.restaurantDetail.displayPhone}',
                          //     style: Theme.of(context).textTheme.titleSmall),
                          // Text('${state.restaurantDetail.url}',
                          //     style: Theme.of(context).textTheme.titleSmall),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget actionTile(Widget widgetType, String typeName, VoidCallback callback) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.greenAccent),
      child: Row(
        children: [
          widgetType,
          const Gap(10),
          Text(typeName,
              style: const TextStyle(fontSize: 12, color: Colors.black54))
        ],
      ),
    ),
  );
}
