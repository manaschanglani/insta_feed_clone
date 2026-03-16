import '../entities/post.dart';
import '../entities/story.dart';

abstract class PostRepository {
  Future<List<Story>> fetchStories();
  Future<List<Post>> fetchPosts({required int page, required int limit});
}