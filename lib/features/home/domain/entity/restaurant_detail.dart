class RestaurantDetail {
  final String? id;
  final String? alias;
  final String? name;
  final String? imageUrl;
  final bool? isClaimed;
  final bool? isClosed;
  final String? url;
  final String? phone;
  final String? displayPhone;
  final int? reviewCount;
  // final List<ResCategory>? categories;
  final double? rating;
  final Location? location;
  final Coordinates? coordinates;
  final List<String>? photos;
  final String? price;
  // final Hours hours;
  // final List<String>? transactions;

  RestaurantDetail({
    required this.id,
    required this.alias,
    required this.name,
    required this.imageUrl,
    required this.isClaimed,
    required this.isClosed,
    required this.url,
    required this.phone,
    required this.displayPhone,
    required this.reviewCount,
    // required this.categories,
    required this.rating,
    required this.location,
    required this.coordinates,
    required this.photos,
    required this.price,
    // required this.hours,
    // required this.transactions,
  });
}

class Hours {
  final List<OpenHours> openHours;
  final String hoursType;
  final bool isOpenNow;

  Hours({
    required this.openHours,
    required this.hoursType,
    required this.isOpenNow,
  });
}

class OpenHours {
  final bool isOvernight;
  final String start;
  final String end;
  final int day;

  OpenHours({
    required this.isOvernight,
    required this.start,
    required this.end,
    required this.day,
  });
}

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });
}

class Location {
  final String address1;
  final String? address2;
  final String? address3;
  final String city;
  final String zipCode;
  final String country;
  final String state;
  final List<String> displayAddress;
  final String crossStreets;

  Location({
    required this.address1,
    required this.address2,
    required this.address3,
    required this.city,
    required this.zipCode,
    required this.country,
    required this.state,
    required this.displayAddress,
    required this.crossStreets,
  });
}

class ResCategory {
  final String alias;
  final String title;

  ResCategory({
    required this.alias,
    required this.title,
  });
}
