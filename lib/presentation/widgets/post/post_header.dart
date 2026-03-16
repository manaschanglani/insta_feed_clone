import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final String username;
  final String profileImage;

  const PostHeader({
    super.key,
    required this.username,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: CachedNetworkImageProvider(profileImage),
          ),
          const SizedBox(width: 10),
          Text(
            username,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          const Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}