import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/feed_provider.dart';

class PostActions extends ConsumerWidget {
  final String postId;
  final bool liked;
  final bool saved;

  const PostActions({
    super.key,
    required this.postId,
    required this.liked,
    required this.saved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [

          IconButton(
            iconSize: 28,
            onPressed: () {
              ref.read(feedProvider.notifier).toggleLike(postId);
            },
            icon: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              color: liked ? Colors.red : Colors.black,
            ),
          ),

          IconButton(
            iconSize: 28,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Comments coming soon")),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
          ),

          IconButton(
            iconSize: 28,
            onPressed: () {},
            icon: const Icon(Icons.send_outlined),
          ),

          const Spacer(),

          IconButton(
            iconSize: 28,
            onPressed: () {
              ref.read(feedProvider.notifier).toggleSave(postId);
            },
            icon: Icon(
              saved ? Icons.bookmark : Icons.bookmark_border,
            ),
          ),
        ],
      ),
    );
  }
}