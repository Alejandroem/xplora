import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import 'see_more_card_widget.dart';

/// Generic Carousel that can display any type of items
class CarouselWidget<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final bool hasMore;
  final VoidCallback onSeeMoreTap;

  const CarouselWidget({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.hasMore,
    required this.onSeeMoreTap,
  });

  @override
  State<CarouselWidget<T>> createState() => _CarouselWidgetState<T>();
}

class _CarouselWidgetState<T> extends State<CarouselWidget<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int index = 0; index < widget.items.length; index++) ...[
              widget.itemBuilder(widget.items[index], index),
              if (index < widget.items.length - 1 || widget.hasMore)
                const SizedBox(width: spacing8),
            ],
            if (widget.hasMore) SeeMoreCard(onTap: widget.onSeeMoreTap),
          ],
        ),
      ),
    );
  }
}
