
import 'package:yepp/features/home/domain/entity/location_review.dart';

class LocationReviewModel extends LocationReview {
  LocationReviewModel(
      {required super.id,
      required super.url,
      required super.text,
      required super.rating,
      required super.timeCreated,
      required super.user});

  factory LocationReviewModel.fromJson(Map<String, dynamic> json) =>
      LocationReviewModel(
        id: json['id'],
        url: json['url'],
        text: json['text'] ?? '',
        rating: json['rating'],
        timeCreated: json['time_created'],
        user: UserModel.fromJson(json['user']),
      );
}

class UserModel extends User {
  UserModel(
      {required super.id,
      required super.profileUrl,
      required super.imageUrl,
      required super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        profileUrl: json['profile_url'] ?? '',
        imageUrl: json['image_url'] ?? '',
        name: json['name'] ?? '',
      );
}
