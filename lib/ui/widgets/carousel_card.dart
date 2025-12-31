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
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: 160,
                child: GlassContainer(
                  border: widget.isSelected ? Border.all(
                    color: brandPrimary,
                    width: 3,
                  ) : null,
                  borderRadius: widget.isSelected ? 14.5 : null,
                  padding: const EdgeInsets.all(0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: widget.heroTag != null
                            ? Hero(
                                tag: widget.heroTag!,
                                child: _buildImage(),
                              )
                            : _buildImage(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                      if (widget.isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: brandPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: textPrimary,
                              size: 16,
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
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
                                style: bodySmallStyle,
                                maxLines:
                                    widget.bottomContent != null ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: widget.bottomContent != null
                                    ? TextAlign.start
                                    : TextAlign.center,
                              ),
                              if (widget.bottomContent != null) ...[
                                const SizedBox(height: 4),
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
          ),
        ));
  }

  Widget _buildImage() {
    return Container(
      color: widget.backgroundColor ?? Colors.transparent,
      height: 200,
      width: 160,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        height: 200,
        width: 160,
        fit: widget.imageFit ?? BoxFit.cover,
        placeholder: (context, url) =>
            ShimmerWidgets.adventureCardShimmer(width: 160, height: 200),
        errorWidget: (context, url, error) {
          return Container(
            padding: const EdgeInsets.only(bottom: 40),
            color: widget.backgroundColor ?? bgPrimary,
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                size: 50,
                color: textSecondary,
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
