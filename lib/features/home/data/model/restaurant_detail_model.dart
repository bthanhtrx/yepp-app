
import 'package:yepp/features/home/domain/entity/restaurant_detail.dart';

class RestaurantDetailModel extends RestaurantDetail {
  RestaurantDetailModel({
    required super.id,
    required super.alias,
    required super.name,
    required super.imageUrl,
    required super.isClaimed,
    required super.isClosed,
    required super.url,
    required super.phone,
    required super.displayPhone,
    required super.reviewCount,
    // required super.categories,
    required super.rating,
    required super.location,
    required super.coordinates,
    required super.photos,
    required super.price,
    // required super.hours,
    // required super.transactions,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailModel(
        id: json['id'],
        alias: json['alias'],
        name: json['name'] ?? '',
        imageUrl: json['image_url'],
        isClaimed: json['is_claimed'],
        isClosed: json['is_closed'],
        url: json['url'],
        phone: json['phone'],
        displayPhone: json['display_phone'],
        reviewCount: json['review_count'],
        // categories: (jsonDecode(json['categories']) as List).map((e) => CategoryModel.fromJson(e),).toList(),
        rating: json['rating'],
        location: LocationModel.fromJson(json['location']),
        coordinates: CoordinatesModel.fromJson(json['coordinates']),
        photos: List<String>.from(json['photos'].map((item) => item as String)),
        price: json['price'],
        // hours: json['hours'],
        // transactions: json['transactions'] as List<String>,
      );

  Map<String, dynamic> toJson(RestaurantDetail restaurantDetail) => {
        // leave for implements
      };
}

class HoursModel extends Hours {
  HoursModel({
    required super.openHours,
    required super.hoursType,
    required super.isOpenNow,
  });

  factory HoursModel.fromJson(Map<String, dynamic> json) => HoursModel(
        openHours: json['open'],
        hoursType: json['hours_type'],
        isOpenNow: json['is_open_now'],
      );

  Map<String, dynamic> toJson(Hours hours) => {
        'open': hours.openHours,
        'hours_type': hours.hoursType,
        'is_open_now': hours.isOpenNow,
      };
}

class OpenHoursModel extends OpenHours {
  OpenHoursModel({
    required super.isOvernight,
    required super.start,
    required super.end,
    required super.day,
  });

  factory OpenHoursModel.fromJson(Map<String, dynamic> json) => OpenHoursModel(
        isOvernight: json['is_overnight'],
        start: json['start'],
        end: json['end'],
        day: json['day'],
      );

  Map<String, dynamic> toJson(OpenHours openHours) => {
        'is_overnight': openHours.isOvernight,
        'start': openHours.start,
        'end': openHours.end,
        'day': openHours.day,
      };
}

class CoordinatesModel extends Coordinates {
  CoordinatesModel({
    required super.latitude,
    required super.longitude,
  });

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) =>
      CoordinatesModel(
        latitude: json['latitude'],
        longitude: json['longitude'],
      );

  Map<String, dynamic> toJson(Coordinates coordinates) => {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      };
}

class LocationModel extends Location {
  LocationModel(
      {required super.address1,
      required super.address2,
      required super.address3,
      required super.city,
      required super.zipCode,
      required super.country,
      required super.displayAddress,
      required super.crossStreets,
      required super.state});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        address1: json['address1'],
        address2: json['address2'] ?? '',
        address3: json['address3'] ?? '',
        city: json['city'],
        zipCode: json['zip_code'],
        country: json['country'],
        state: json['state'],
        displayAddress: List<String>.from(json['display_address'].map((item) => item as String)),
        crossStreets: json['cross_streets'],
      );
}

class CategoryModel extends ResCategory {
  CategoryModel({
    required super.alias,
    required super.title,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        alias: json['alias'],
        title: json['title'],
      );

  Map<String, dynamic> toJson(ResCategory category) => {
        'alias': category.alias,
        'title': category.title,
      };
}
