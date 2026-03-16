import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/post_repository.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl();
});

class FeedState {
  final List<Story> stories;
  final List<Post> posts;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const FeedState({
    required this.stories,
    required this.posts,
    required this.isInitialLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.currentPage,
    this.error,
  });

  factory FeedState.initial() {
    return const FeedState(
      stories: [],
      posts: [],
      isInitialLoading: true,
      isLoadingMore: false,
      hasMore: true,
      currentPage: 0,
      error: null,
    );
  }

  FeedState copyWith({
    List<Story>? stories,
    List<Post>? posts,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return FeedState(
      stories: stories ?? this.stories,
      posts: posts ?? this.posts,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}

final feedProvider =
StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return FeedNotifier(repository)..loadInitialData();
});

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier(this._repository) : super(FeedState.initial());

  final PostRepository _repository;

  static const int _pageSize = 10;

  Future<void> loadInitialData() async {
    try {
      state = state.copyWith(isInitialLoading: true, error: null);

      final results = await Future.wait([
        _repository.fetchStories(),
        _repository.fetchPosts(page: 0, limit: _pageSize),
      ]);

      final stories = results[0] as List<Story>;
      final posts = results[1] as List<Post>;

      state = state.copyWith(
        stories: stories,
        posts: posts,
        isInitialLoading: false,
        currentPage: 0,
        hasMore: posts.length == _pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMorePosts() async {
    if (state.isLoadingMore || !state.hasMore || state.isInitialLoading) return;

    try {
      state = state.copyWith(isLoadingMore: true);

      final nextPage = state.currentPage + 1;
      final newPosts =
      await _repository.fetchPosts(page: nextPage, limit: _pageSize);

      state = state.copyWith(
        posts: [...state.posts, ...newPosts],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: newPosts.length == _pageSize,      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  void toggleLike(String postId) {
    final updatedPosts = state.posts.map((post) {
      if (post.id != postId) return post;

      final newLiked = !post.isLiked;
      return post.copyWith(
        isLiked: newLiked,
        likesCount: newLiked ? post.likesCount + 1 : post.likesCount - 1,
      );
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

  void toggleSave(String postId) {
    final updatedPosts = state.posts.map((post) {
      if (post.id != postId) return post;
      return post.copyWith(isSaved: !post.isSaved);
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }
}