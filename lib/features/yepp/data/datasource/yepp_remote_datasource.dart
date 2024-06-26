import 'dart:convert';

import 'package:yepp/core/error/exception.dart';
import 'package:yepp/core/network/secret.dart';
import 'package:yepp/features/yepp/data/model/restaurant_model.dart';
import 'package:yepp/features/yepp/data/model/restaurant_detail_model.dart';
import 'package:http/http.dart' as http;

abstract interface class YeppRemoteDatasource {
  Future<List<RestaurantModel>> getRestaurants({String term, String location});

  Future<RestaurantDetailModel> getRestaurantDetail(String id);
}

class YeppRemoteDatasoureImpl implements YeppRemoteDatasource {
  @override
  Future<List<RestaurantModel>> getRestaurants(
      {String term = '', String location = 'new york'}) async {
    String url =
        'https://api.yelp.com/v3/businesses/search?term=$term&location=$location&sort_by=best_match&limit=20';
    // print('url: $url');
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $apiKey',
        'accept': 'application/json',
      });

      List businessesList = jsonDecode(response.body)['businesses'];

      return businessesList
          .map(
            (json) => RestaurantModel.fromJson(json),
          )
          .toList();
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<RestaurantDetailModel> getRestaurantDetail(String id) async {
    final String url = "https://api.yelp.com/v3/businesses/$id";

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'accept': 'application/json',
        },
      );
      final body = response.body;
      // print('body: $body');
      var json = jsonDecode(body);
      return RestaurantDetailModel.fromJson(json);
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
