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
  State<CarouselWidget<T>> createState() =>
      _CarouselWidgetState<T>();
}

class _CarouselWidgetState<T>
    extends State<CarouselWidget<T>> {
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
    final itemCount = widget.items.length + (widget.hasMore ? 1 : 0);

    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(width: spacing8),
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == widget.items.length && widget.hasMore) {
          return SeeMoreCard(onTap: widget.onSeeMoreTap);
        }

        return widget.itemBuilder(widget.items[index], index);
      },
    );
  }
}