import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryAvatar extends StatelessWidget {
  final String imageUrl;
  final String username;
  final bool viewed;

  const StoryAvatar({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.viewed,
  });

  @override
  Widget build(BuildContext context) {

    const double outerRadius = 42;
    const double gap = 3;
    const double innerRadius = 34;

    return SizedBox(
      width: 80,
      child: Column(
        children: [

          /// Gradient Ring
          Container(
            width: outerRadius * 2,
            height: outerRadius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient: viewed
                  ? null
                  : const LinearGradient(
                colors: [
                  Color(0xFFFEDA75),
                  Color(0xFFFA7E1E),
                  Color(0xFFD62976),
                  Color(0xFF962FBF),
                  Color(0xFF4F5BD5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              border: viewed
                  ? Border.all(color: Colors.grey.shade400, width: 2)
                  : null,
            ),

            /// White gap ring
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(gap),

                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),

                /// Profile image
                child: CircleAvatar(
                  radius: innerRadius,
                  backgroundImage:
                  CachedNetworkImageProvider(imageUrl),
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),

        ],
      ),
    );
  }
}