import 'package:yepp/features/yepp/domain/entity/restaurant.dart';

class RestaurantModel extends Restaurant {
  RestaurantModel({
    required super.id,
    required super.alias,
    required super.name,
    required super.imageUrl,
    required super.isClosed,
    required super.url,
    required super.reviewCount,
    required super.rating,
    required super.phone,
    required super.displayPhone,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json["id"]?? '',
      alias: json["alias"] ?? '',
      name: json["name"] ??'',
      imageUrl: json["image_url"]??'',
      isClosed: json["is_closed"]?? false,
      url: json["url"]??'',
      reviewCount: json["review_count"] ??0,
      rating: json["rating"],
      phone: json["phone"]??'',
      displayPhone: json["display_phone"]??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "alias": alias,
      "name": name,
      "imageUrl": imageUrl,
      "isClosed": isClosed,
      "url": url,
      "reviewCount": reviewCount,
      "rating": rating,
      "phone": phone,
      "displayPhone": displayPhone,
    };
  }

}
