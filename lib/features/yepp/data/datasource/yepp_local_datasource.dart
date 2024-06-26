import 'dart:core';

import 'package:hive/hive.dart';
import 'package:yepp/features/yepp/data/model/restaurant_model.dart';

abstract interface class YeppLocalDatasource {
  void getLocalYepp({required List<RestaurantModel> yepp});

  List<RestaurantModel> loadYepp();
}

class YeppLocalDatasourceImpl implements YeppLocalDatasource {
  final Box box;

  YeppLocalDatasourceImpl(this.box);

  @override
  void getLocalYepp({required List<RestaurantModel> yepp}) {
    box.clear();

    box.write(() {
      for (int i = 0; i < yepp.length; i++) {
        box.put('$i', yepp[i].toJson());
      }
    });
  }

  @override
  List<RestaurantModel> loadYepp() {
    List<RestaurantModel> list = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        list.add(RestaurantModel.fromJson(box.get(i.toString())));
      }
    });

    return list;
  }
}
