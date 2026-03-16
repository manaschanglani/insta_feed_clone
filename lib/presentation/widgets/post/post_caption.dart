import 'package:flutter/material.dart';

class PostCaption extends StatelessWidget {
  final String username;
  final String caption;
  final int likes;
  final String timeAgo;

  const PostCaption({
    super.key,
    required this.username,
    required this.caption,
    required this.likes,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "$likes likes",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 4),

          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: "  "),
                TextSpan(text: caption),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Text(
            timeAgo,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}