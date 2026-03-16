import 'user.dart';

class Post {
  final String id;
  final User user;
  final List<String> imageUrls;
  final String caption;
  final int likesCount;
  final bool isLiked;
  final bool isSaved;
  final String timeAgo;

  const Post({
    required this.id,
    required this.user,
    required this.imageUrls,
    required this.caption,
    required this.likesCount,
    required this.isLiked,
    required this.isSaved,
    required this.timeAgo,
  });

  Post copyWith({
    String? id,
    User? user,
    List<String>? imageUrls,
    String? caption,
    int? likesCount,
    bool? isLiked,
    bool? isSaved,
    String? timeAgo,
  }) {
    return Post(
      id: id ?? this.id,
      user: user ?? this.user,
      imageUrls: imageUrls ?? this.imageUrls,
      caption: caption ?? this.caption,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      timeAgo: timeAgo ?? this.timeAgo,
    );
  }
}