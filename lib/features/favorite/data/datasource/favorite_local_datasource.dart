import 'dart:core';

import 'package:hive/hive.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/features/home/data/model/restaurant_model.dart';

abstract interface class FavoriteLocalDatasource {
  void addOrRemoveToDb({required LocalPlaceModel yepp});

  List<LocalPlaceModel> getFavoriteLocal();

  bool isFavoriteLocal({required LocalPlaceModel location});
}

class FavoriteLocalDatasourceImpl implements FavoriteLocalDatasource {
  final Box box;

  FavoriteLocalDatasourceImpl(this.box);

  @override
  void addOrRemoveToDb({required LocalPlaceModel yepp}) {
    if (box.containsKey(yepp.id)) {
      box.delete(yepp.id);
    } else {
      box.put(yepp.id, yepp.toJson());
    }
  }

  @override
  List<LocalPlaceModel> getFavoriteLocal() {
    List<LocalPlaceModel> list = [];

    box.read(() {
      for (int i = 0; i < box.length; i++) {
        list.add(LocalPlaceModel.fromJson(box.getAt(i)));
      }
    });
    return list;
  }

  @override
  bool isFavoriteLocal({required LocalPlaceModel location}) {
    return box.containsKey(location.id);
  }
}
