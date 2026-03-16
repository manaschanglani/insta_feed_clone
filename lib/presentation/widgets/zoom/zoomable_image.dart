import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ZoomableImage extends StatefulWidget {
  final String imageUrl;

  const ZoomableImage({
    super.key,
    required this.imageUrl,
  });

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;

  late AnimationController _animationController;

  Rect? _initialRect;

  double _scale = 1.0;
  Offset _offset = Offset.zero;
  double _backgroundOpacity = 0.0;

  bool _isZooming = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  void _startZoom() {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final topLeft = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _initialRect = topLeft & size;
    _scale = 1.0;
    _offset = Offset.zero;
    _backgroundOpacity = 0.0;
    _isZooming = true;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, overlaySetState) {
            return Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Colors.black.withOpacity(_backgroundOpacity),
                    ),
                  ),
                ),

                if (_initialRect != null)
                  Positioned.fromRect(
                    rect: _initialRect!,
                    child: IgnorePointer(
                      ignoring: false,
                      child: Transform.translate(
                        offset: _offset,
                        child: Transform.scale(
                          scale: _scale,
                          alignment: Alignment.center,
                          child: Material(
                            color: Colors.transparent,
                            elevation: 18,
                            borderRadius: BorderRadius.circular(0),
                            clipBehavior: Clip.none,
                            child: CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _updateZoom(ScaleUpdateDetails details) {
    if (_overlayEntry == null) return;

    final newScale = details.scale.clamp(1.0, 4.0);

    // Small panning while zoomed
    final newOffset = details.focalPointDelta;

    _scale = newScale;
    _offset += newOffset;

    // Background becomes more dim as zoom increases
    _backgroundOpacity = ((_scale - 1.0) / 3.0).clamp(0.0, 1.0) * 0.45;

    _overlayEntry?.markNeedsBuild();
  }

  Future<void> _endZoom() async {
    if (_overlayEntry == null) return;

    final scaleTween = Tween<double>(begin: _scale, end: 1.0);
    final offsetTween = Tween<Offset>(begin: _offset, end: Offset.zero);
    final opacityTween = Tween<double>(begin: _backgroundOpacity, end: 0.0);

    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    void listener() {
      _scale = scaleTween.evaluate(animation);
      _offset = offsetTween.evaluate(animation);
      _backgroundOpacity = opacityTween.evaluate(animation);
      _overlayEntry?.markNeedsBuild();
    }

    _animationController
      ..removeListener(listener)
      ..reset()
      ..addListener(listener);

    await _animationController.forward();

    _animationController.removeListener(listener);

    _overlayEntry?.remove();
    _overlayEntry = null;

    _scale = 1.0;
    _offset = Offset.zero;
    _backgroundOpacity = 0.0;
    _isZooming = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: (_) {
          _startZoom();
        },
        onScaleUpdate: _updateZoom,
        onScaleEnd: (_) {
          _endZoom();
        },
        child: Opacity(
          opacity: _isZooming ? 0.15 : 1.0,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}