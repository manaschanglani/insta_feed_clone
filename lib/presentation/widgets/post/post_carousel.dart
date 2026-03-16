import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../zoom/zoomable_image.dart';
import 'dot_indicator.dart';

class PostCarousel extends StatefulWidget {
  final List<String> images;
  final PageController controller;
  final VoidCallback onDoubleTapLike;

  const PostCarousel({
    super.key,
    required this.images,
    required this.controller,
    required this.onDoubleTapLike,
  });

  @override
  State<PostCarousel> createState() => _PostCarouselState();
}

class _PostCarouselState extends State<PostCarousel>
    with SingleTickerProviderStateMixin {

  late AnimationController _heartController;
  bool showHeart = false;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _handleDoubleTap() {
    widget.onDoubleTapLike();

    setState(() {
      showHeart = true;
    });

    _heartController.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          showHeart = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool isZooming = false;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [

          PageView.builder(
            controller: widget.controller,
            itemCount: widget.images.length,
            physics: isZooming
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTap: _handleDoubleTap,
                child: ZoomableImage(
                  imageUrl: widget.images[index],
                ),
              );
            },
          ),

          if (showHeart)
            ScaleTransition(
              scale: Tween(begin: 0.8, end: 1.2).animate(
                CurvedAnimation(
                  parent: _heartController,
                  curve: Curves.easeOut,
                ),
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 100,
              ),
            ),
        ],
      ),
    );
  }
}