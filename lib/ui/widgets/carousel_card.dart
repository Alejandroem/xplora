import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';

/// Generic Carousel Card with fade-in and scale animations
/// Uses Column layout for clean, predictable structure
class CarouselCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String? heroTag;
  final VoidCallback onTap;
  final Widget? bottomContent;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? imagePadding;
  final BoxFit? imageFit;
  final double? width;
  final double? imageHeight;

  const CarouselCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.heroTag,
    required this.onTap,
    this.bottomContent,
    this.backgroundColor,
    this.imagePadding,
    this.imageFit,
    this.width,
    this.imageHeight,
  });

  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutBack,
    ));

    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardChild = GlassContainer(
      borderRadius: radiusCard,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(radiusCard),
              topRight: Radius.circular(radiusCard),
            ),
            child: widget.heroTag != null
                ? Hero(
                    tag: widget.heroTag!,
                    child: _buildImage(),
                  )
                : _buildImage(),
          ),

          // Bottom content section
          Container(
            padding: const EdgeInsets.all(spacing8),
            decoration: BoxDecoration(
              color: context.colors.bgSecondary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(radiusCard),
                bottomRight: Radius.circular(radiusCard),
              ),
              boxShadow: const [elevation1],
            ),
            child: Column(
              crossAxisAlignment: widget.bottomContent != null
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  maxLines: widget.bottomContent != null ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: widget.bottomContent != null
                      ? TextAlign.start
                      : TextAlign.center,
                ),
                if (widget.bottomContent != null) ...[
                  const SizedBox(height: spacing4),
                  widget.bottomContent!,
                ],
              ],
            ),
          ),
        ],
      ),
    );

    final wrappedCard = widget.width != null
        ? SizedBox(width: widget.width, child: cardChild)
        : cardChild;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: InkWell(
          onTap: widget.onTap,
          child: wrappedCard,
        ),
      ),
    );
  }

  Widget _buildImage() {
    final height = widget.imageHeight ?? 140;

    return Container(
      color: widget.backgroundColor,
      height: height,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: widget.imageFit ?? BoxFit.cover,
        placeholder: (context, url) =>
            ShimmerWidgets.imageShimmer(height: height, context: context),
        errorWidget: (context, url, error) {
          return Container(
            color: widget.backgroundColor ?? context.colors.bgPrimary,
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                size: iconSizeLarge,
                color: context.colors.textSecondary,
              ),
            ),
          );
        },
        imageBuilder: (context, imageProvider) {
          final image = Image(
            image: imageProvider,
            fit: widget.imageFit ?? BoxFit.cover,
            width: double.infinity,
          );

          return widget.imagePadding != null
              ? Padding(
                  padding: widget.imagePadding!,
                  child: image,
                )
              : image;
        },
      ),
    );
  }
}
