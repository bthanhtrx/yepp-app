import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/core/router/app_route_constant.dart';

class FavoriteCard extends StatelessWidget {
  final LocalPlace localPlace;

  const FavoriteCard({super.key, required this.localPlace});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRouteConstant.detailRoute, extra: localPlace),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: CircleAvatar(radius: 50,
              backgroundImage: CachedNetworkImageProvider(
            localPlace.image_url,
          )),
          title: Text(localPlace.name),
        ),
      ),
    );
  }
}
