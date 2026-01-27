import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';

/// Generic Carousel Card (no entrance animations)
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

  /// When true, image expands to fill available space (use in grid/constrained layouts)
  final bool expandImage;

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
    this.expandImage = false,
  });

  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {
  @override
  Widget build(BuildContext context) {
    // Build the image section
    Widget imageSection = ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(radiusLarge),
        topRight: Radius.circular(radiusLarge),
      ),
      child: widget.heroTag != null
          ? Hero(
              tag: widget.heroTag!,
              child: _buildImage(),
            )
          : _buildImage(),
    );

    // Wrap in Expanded if expandImage is true
    if (widget.expandImage) {
      imageSection = Expanded(child: imageSection);
    }

    final cardChild = GlassContainer(
      border: Border.all(width: 0),
      boxShadow: const [elevation1],
      borderRadius: radiusLarge,
      padding: EdgeInsets.zero,
      child: Column(
        // Use max size when expanding image, min otherwise
        mainAxisSize: widget.expandImage ? MainAxisSize.max : MainAxisSize.min,
        children: [
          // Image section
          imageSection,

          // Bottom content section
          Container(
            padding: const EdgeInsets.all(spacing12),
            decoration: BoxDecoration(
              color: context.colors.bgSecondary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(radiusLarge),
                bottomRight: Radius.circular(radiusLarge),
              ),
            ),
            child: Column(
              crossAxisAlignment: widget.bottomContent != null
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: bodySmallStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.bold
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

    return InkWell(
      onTap: widget.onTap,
      child: wrappedCard,
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
            color: widget.backgroundColor ?? context.colors.bgSecondary,
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
