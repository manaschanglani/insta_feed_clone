import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../domain/entities/post.dart';
import '../../providers/feed_provider.dart';

import 'dot_indicator.dart';
import 'post_header.dart';
import 'post_carousel.dart';
import 'post_actions.dart';
import 'post_caption.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {

  late PageController _controller;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = PageController();

    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;

      if (pageIndex != page) {
        setState(() {
          pageIndex = page;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Prefetch images for smoother scrolling
    for (final image in widget.post.imageUrls) {
      precacheImage(
        CachedNetworkImageProvider(image),
        context,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final post = widget.post;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// HEADER
        PostHeader(
          username: post.user.username,
          profileImage: post.user.profileImageUrl,
        ),

        /// IMAGE CAROUSEL
        PostCarousel(
          images: post.imageUrls,
          controller: _controller,

          /// DOUBLE TAP LIKE
          onDoubleTapLike: () {

            if (!post.isLiked) {
              ref.read(feedProvider.notifier).toggleLike(post.id);
            }

          },
        ),

        /// ACTION BUTTONS
        PostActions(
          postId: post.id,
          liked: post.isLiked,
          saved: post.isSaved,
        ),

        /// DOT INDICATOR
        if (post.imageUrls.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: DotIndicator(
              count: post.imageUrls.length,
              index: pageIndex,
            ),
          ),

        /// CAPTION
        PostCaption(
          username: post.user.username,
          caption: post.caption,
          likes: post.likesCount,
          timeAgo: post.timeAgo,
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}