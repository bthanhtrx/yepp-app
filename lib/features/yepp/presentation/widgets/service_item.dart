import 'package:flutter/material.dart';
import 'package:yepp/core/theme/app_pallete.dart';

class ServiceItem extends StatelessWidget {
  final Widget badge;
  final String name;

  const ServiceItem({super.key, required this.badge, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppPallete.greyColor,
          ),
          child: badge,
        ),
        Text(name, style: Theme.of(context).textTheme.titleSmall,)

      ],
    );
  }
}
