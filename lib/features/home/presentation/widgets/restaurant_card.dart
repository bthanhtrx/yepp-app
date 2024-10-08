import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:yepp/core/router/app_route_constant.dart';
import 'package:yepp/core/theme/app_pallete.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
class RestaurantCard extends StatelessWidget {
  final LocalPlace restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.pushNamed(AppRouteConstant.detailRoute, extra: restaurant),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: CachedNetworkImage(imageUrl:
                          restaurant.image_url,
                          fit: BoxFit.fitWidth,
                        ),
                      )),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Text('${restaurant.rating}'),
                          Icon(
                            Icons.star_outlined,
                            color: AppPallete.yellow,
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Gap(3),
            Text(
              restaurant.name,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
