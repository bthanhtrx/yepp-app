import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yepp/core/theme/theme.dart';
import 'package:yepp/core/utils/loader.dart';
import 'package:yepp/features/yepp/domain/entity/restaurant.dart';
import 'package:yepp/features/yepp/presentation/bloc/yepp_bloc.dart';
import 'package:yepp/features/yepp/presentation/widgets/service_item.dart';

class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantPage({super.key, required this.restaurant});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  @override
  void initState() {
    context.read<YeppBloc>().add(YeppGetRestaurantDetail(widget.restaurant.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.favorite_outline),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(20),
              Center(
                child: BlocBuilder<YeppBloc, YeppState>(
                  builder: (context, state) {
                    if (state is YeppLoading) {
                      return const Loader();
                    }

                    if (state is YeppFailure) {
                      return Text(state.message, style: Theme.of(context).textTheme.titleLarge,);
                    }

                    if (state is! YeppRestaurantDetailSuccess) {
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
                                context.read<YeppBloc>().add(YeppGetRestaurants('',''));
                                Navigator.pop(context);
                              },
                            ),
                            Text(
                              'Restaurant Details',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox.shrink()
                          ],
                        ),
                        const Gap(20),
                        GestureDetector(
                          onTap: () {
                            final  multiImageProvider = MultiImageProvider(state.restaurantDetail.photos!.map((e) => NetworkImage(e),).toList());
                            showImageViewerPager(context, multiImageProvider, onPageChanged: (page) {
                              print("page changed to $page");
                            }, onViewerDismissed: (page) {
                              print("dismissed while on page $page");
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.warning);
                              },

                              state.restaurantDetail.imageUrl!,
                              width: screenWidth,
                              height: screenHeight * 0.4,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.restaurantDetail.name!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Row(
                              children: [
                                RatingBar(
                                  itemSize: 20,
                                  glowColor: Colors.yellow,
                                  initialRating: state.restaurantDetail.rating!,
                                  ratingWidget: RatingWidget(
                                      full: const Icon(
                                        Icons.star_outlined,
                                        color: Colors.yellow,
                                      ),
                                      half: const Icon(Icons.star_half_outlined,
                                          color: Colors.yellow),
                                      empty: const Icon(Icons.star_border_outlined,
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
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    '${state.restaurantDetail.rating}',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                )
                              ],
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
                                badge: const Icon(Icons.door_front_door_outlined),
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
                                    style: const TextStyle(color: Colors.black)),
                                name: 'Price'),
                            ServiceItem(
                                badge: const Icon(Icons.verified_outlined),
                                name: state.restaurantDetail.isClaimed!
                                    ? 'Claimed'
                                    : 'Unclaimed'),
                          ],
                        ),
                        const Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            actionTile(const Icon(Icons.phone_outlined), 'Order Now', ()async{
                              await launchUrl(Uri(scheme: 'tel', path: state.restaurantDetail.phone));
                            }),
                            actionTile(const Icon(Icons.circle_outlined), 'Visit ', () async{
                              await launchUrl(Uri.parse(state.restaurantDetail.url!));
                            }),
                            actionTile(const Icon(Icons.map_outlined), 'Show on map', (){

                            }),
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
          Text(typeName, style: const TextStyle(fontSize: 12, color: Colors.black54))
        ],
      ),
    ),
  );
}
