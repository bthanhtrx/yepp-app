class LocationReview {
  final String id;
  final String url;
  final String text;
  final num rating;
  final String timeCreated;
  final User user;

  LocationReview(
      {required this.id,
      required this.url,
      required this.text,
      required this.rating,
      required this.timeCreated,
      required this.user});


}

class User {
  final String id;
  final String profileUrl;
  final String imageUrl;
  final String name;

  User(
      {required this.id,
      required this.profileUrl,
      required this.imageUrl,
      required this.name});


}
