import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 1) // Ensure each model has a unique typeId
class Post extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  final int likes;

  @HiveField(4)
  final String userFirstName;

  @HiveField(5)
  final String userLastName;

  @HiveField(6)
  final String? userProfilePhoto;

  Post({
    required this.id,
    required this.text,
    this.imageUrl,
    this.likes = 0,
    required this.userFirstName,
    required this.userLastName,
    this.userProfilePhoto,
  });
}
