import 'dart:convert';

import 'package:yepp/core/error/exception.dart';
import 'package:yepp/core/common/secret/secret.dart';
import 'package:http/http.dart' as http;
import 'package:yepp/features/home/data/model/location_review_model.dart';
import 'package:yepp/features/home/data/model/restaurant_detail_model.dart';
import 'package:yepp/features/home/data/model/restaurant_model.dart';

abstract interface class YeppRemoteDatasource {
  Future<List<LocalPlaceModel>> getRestaurants(
      {String term, String location, required int offset});

  Future<RestaurantDetailModel> getRestaurantDetail(String id);

  Future<List<LocationReviewModel>> getYeppReviews(String id);
}

class YeppRemoteDatasoureImpl implements YeppRemoteDatasource {
  // int offset = 0;
  // int limit = 20;
  List<LocalPlaceModel> list = [];

  @override
  Future<List<LocalPlaceModel>> getRestaurants(
      {String term = '',
      String location = 'newyork',
      required int offset}) async {
    String url =
        'https://api.yelp.com/v3/businesses/search?term=$term&location=$location&sort_by=best_match&limit=20&offset=$offset';
    print('url: $url');
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer ${Secret.apiKey}',
        'accept': 'application/json',
      });

      List businessesList = jsonDecode(response.body)['businesses'];

      final listParse = businessesList
          .map(
            (json) => LocalPlaceModel.fromJson(json),
          )
          .toList();
      list.addAll(listParse);

      return list;
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
          'Authorization': 'Bearer ${Secret.apiKey}',
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

  @override
  Future<List<LocationReviewModel>> getYeppReviews(String id) async {
    final String url = 'https://api.yelp.com/v3/businesses/$id/reviews';

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${Secret.apiKey}',
          'accept': 'application/json',
        },
      );
      final body = response.body;
      print('body: $body');
      List json = jsonDecode(body)['reviews'];

      return json
          .map((review) => LocationReviewModel.fromJson(review))
          .toList();
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
