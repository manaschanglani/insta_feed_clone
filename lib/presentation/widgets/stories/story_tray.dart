import 'package:flutter/material.dart';
import '../../providers/feed_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'story_avatar.dart';

class StoryTray extends ConsumerWidget {
  const StoryTray({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(feedProvider).stories;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: SizedBox(
        height: 110,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          itemCount: stories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final story = stories[index];

            return StoryAvatar(
              imageUrl: story.user.profileImageUrl,
              username: story.user.username,
              viewed: story.isViewed,
            );
          },
        ),
      ),
    );
  }
}