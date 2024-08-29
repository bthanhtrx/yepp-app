import 'dart:core';

import 'package:hive/hive.dart';
import 'package:yepp/features/home/data/model/restaurant_model.dart';

abstract interface class YeppLocalDatasource {
  void saveToLocal({required List<LocalPlaceModel> yepp});

  List<LocalPlaceModel> loadYepp();
}

class YeppLocalDatasourceImpl implements YeppLocalDatasource {
  final Box box;

  YeppLocalDatasourceImpl(this.box);

  @override
  void saveToLocal({required List<LocalPlaceModel> yepp}) {
    box.clear();

    box.write(() {
      for (int i = 0; i < yepp.length; i++) {
        box.put('$i', yepp[i].toJson());
      }
    });
  }

  @override
  List<LocalPlaceModel> loadYepp() {
    List<LocalPlaceModel> list = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        list.add(LocalPlaceModel.fromJson(box.get(i.toString())));
      }
    });

    return list;
  }
}
