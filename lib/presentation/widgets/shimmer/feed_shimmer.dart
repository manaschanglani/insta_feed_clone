import 'package:flutter/material.dart';
import 'post_card_shimmer.dart';
import 'story_tray_shimmer.dart';

class FeedShimmer extends StatelessWidget {
  const FeedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        StoryTrayShimmer(),
        Divider(height: 1),
        PostCardShimmer(),
        PostCardShimmer(),
      ],
    );
  }
}