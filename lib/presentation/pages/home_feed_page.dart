import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feed_provider.dart';
import '../pages/app_bar.dart';
import '../widgets/post/post_card.dart';
import '../widgets/shimmer/feed_shimmer.dart';
import '../widgets/shimmer/post_card_shimmer.dart';
import '../widgets/shimmer/story_tray_shimmer.dart';
import '../widgets/stories/story_tray.dart';

class HomeFeedPage extends ConsumerStatefulWidget {
  const HomeFeedPage({super.key});

  @override
  ConsumerState<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends ConsumerState<HomeFeedPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final state = ref.read(feedProvider);

    if (!_scrollController.hasClients) return;
    if (state.isInitialLoading || state.isLoadingMore || !state.hasMore) return;

    final position = _scrollController.position;
    final trigger = position.maxScrollExtent - 800;

    if (position.pixels >= trigger) {
      ref.read(feedProvider.notifier).loadMorePosts();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedProvider);

    return Scaffold(
      appBar: const InstagramAppBar(),
      body: Builder(
        builder: (_) {
          if (state.isInitialLoading) {
            return ListView(
              children: const [
                StoryTrayShimmer(),
                PostCardShimmer(),
                PostCardShimmer(),
              ],
            );
          }

          if (state.error != null && state.posts.isEmpty) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: state.posts.length + 3,
            itemBuilder: (context, index) {
              if (index == 0) return const StoryTray();
              // SizedBox(height: 8,);
              // if (index == 1) return const Divider(height: 1);

              final postIndex = index - 1;

              if (postIndex < state.posts.length) {
                return PostCard(post: state.posts[postIndex]);
              }

              if (state.isLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              return const SizedBox(height: 20);
            },
          );
        },
      ),
    );
  }
}