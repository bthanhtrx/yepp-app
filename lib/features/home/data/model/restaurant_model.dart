import 'package:yepp/core/common/entity/restaurant.dart';

class LocalPlaceModel extends LocalPlace {
  LocalPlaceModel({
    required super.id,
    required super.alias,
    required super.name,
    required super.image_url,
    required super.isClosed,
    required super.url,
    required super.reviewCount,
    required super.rating,
    required super.phone,
    required super.displayPhone,
  });

  factory LocalPlaceModel.fromJson(Map<String, dynamic> json) {
    return LocalPlaceModel(
      id: json["id"] ?? '',
      alias: json["alias"] ?? '',
      name: json["name"] ?? '',
      image_url: json["image_url"] ?? '',
      isClosed: json["is_closed"] ?? false,
      url: json["url"] ?? '',
      reviewCount: json["review_count"] ?? 0,
      rating: json["rating"],
      phone: json["phone"] ?? '',
      displayPhone: json["display_phone"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "alias": alias,
      "name": name,
      "image_url": image_url,
      "isClosed": isClosed,
      "url": url,
      "reviewCount": reviewCount,
      "rating": rating,
      "phone": phone,
      "displayPhone": displayPhone,
    };
  }

  factory LocalPlaceModel.fromEntity(LocalPlace restaurant) =>
      LocalPlaceModel(id: restaurant.id,
          alias: restaurant.alias,
          name: restaurant.name,
          image_url: restaurant.image_url,
          isClosed: restaurant.isClosed,
          url: restaurant.url,
          reviewCount: restaurant.reviewCount,
          rating: restaurant.rating,
          phone: restaurant.phone,
          displayPhone: restaurant.displayPhone);



  @override
  String toString() {
    return 'RestaurantModel{id: $id - name: $name - imageUrl: $image_url}';
  }
}
