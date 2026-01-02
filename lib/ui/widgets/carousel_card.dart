import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import 'glass_container.dart';

/// Generic Carousel Card with fade-in and scale animations
class CarouselCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String? heroTag;
  final VoidCallback onTap;
  final Widget? bottomContent;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? imagePadding;
  final BoxFit? imageFit;
  final bool isSelected;

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
    this.isSelected = false,
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
    return FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: InkWell(
            onTap: widget.onTap,
            child: SizedBox(
              width: 150,
              child: GlassContainer(
                border: widget.isSelected
                    ? Border.all(
                        color: brandPrimary,
                        width: borderWidthDefault,
                      )
                    : null,
                borderRadius: widget.isSelected ? radiusLarge : null,
                padding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(radiusMedium),
                          topRight: Radius.circular(radiusMedium)),
                      child: widget.heroTag != null
                          ? Hero(
                              tag: widget.heroTag!,
                              child: _buildImage(),
                            )
                          : _buildImage(),
                    ),
                    if (widget.isSelected)
                      Positioned(
                        top: spacing8,
                        right: spacing8,
                        child: Container(
                          padding: const EdgeInsets.all(spacing4),
                          decoration: BoxDecoration(
                            color: brandPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: context.colors.textPrimary,
                            size: iconSizeSmall,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(spacing8),
                        decoration: BoxDecoration(
                          color: context.colors.bgSecondary,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(radiusMedium),
                            bottomRight: Radius.circular(radiusMedium),
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
                                  color: context.colors.textPrimary),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildImage() {
    return Container(
      color: widget.backgroundColor,
      height: 140,
      width: 160,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: widget.imageFit ?? BoxFit.cover,
        placeholder: (context, url) =>
            ShimmerWidgets.imageShimmer(width: 160, height: 140, context: context),
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
            height: 200,
            width: 160,
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
