import '../../domain/entities/post.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/post_repository.dart';
import '../sources/mock_feed_source.dart';

class PostRepositoryImpl implements PostRepository {
  @override
  Future<List<Story>> fetchStories() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    return List.generate(10, (index) {
      final image = MockFeedSource.profileImages[
      index % MockFeedSource.profileImages.length];
      final username =
      MockFeedSource.usernames[index % MockFeedSource.usernames.length];

      final user = User(
        id: 'story_user_$index',
        username: username,
        profileImageUrl: '$image?w=200',
      );

      return Story(
        id: 'story_$index',
        user: user,
        imageUrl: '$image?w=300',
        isViewed: index > 3,
      );
    });
  }

  @override
  Future<List<Post>> fetchPosts({required int page, required int limit}) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (page > 4) return [];

    final start = page * limit;

    return List.generate(limit, (index) {
      final currentIndex = start + index;

      final profile = MockFeedSource.profileImages[
      currentIndex % MockFeedSource.profileImages.length];
      final username =
      MockFeedSource.usernames[currentIndex % MockFeedSource.usernames.length];

      final user = User(
        id: 'user_$currentIndex',
        username: username,
        profileImageUrl: '$profile?w=200',
      );

      final images = [
        '${MockFeedSource.postImages[currentIndex % MockFeedSource.postImages.length]}?w=900',
        '${MockFeedSource.postImages[(currentIndex + 1) % MockFeedSource.postImages.length]}?w=900',
        '${MockFeedSource.postImages[(currentIndex + 2) % MockFeedSource.postImages.length]}?w=900',
      ];

      return Post(
        id: 'post_$currentIndex',
        user: user,
        imageUrls: images,
        caption: MockFeedSource.captions[
        currentIndex % MockFeedSource.captions.length],
        likesCount: 120 + currentIndex,
        isLiked: false,
        isSaved: false,
        timeAgo: '${(currentIndex % 12) + 1}h',
      );
    });
  }
}