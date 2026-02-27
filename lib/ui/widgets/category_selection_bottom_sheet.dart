import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/shimmer_widgets.dart';

import '../../application/providers/category_providers.dart';
import '../../domain/models/category.dart';
import '../../theme.dart';

const double _radioCheckSize = 14.0;

// ── Main widget ───────────────────────────────────────────────────────────────

/// Bottom sheet for selecting categories with expandable sections.
/// Selections are stored as Map<parentId, selectedChildId>.
class CategorySelectionBottomSheet extends ConsumerStatefulWidget {
  final List<Category> categories;
  final Map<String, String?> initialSelections;
  final void Function(Map<String, String?>) onSelectionChanged;

  const CategorySelectionBottomSheet({
    super.key,
    required this.categories,
    required this.initialSelections,
    required this.onSelectionChanged,
  });

  @override
  ConsumerState<CategorySelectionBottomSheet> createState() =>
      _CategorySelectionBottomSheetState();
}

class _CategorySelectionBottomSheetState
    extends ConsumerState<CategorySelectionBottomSheet> {
  late List<Category> _visibleRoots;
  late Map<String, List<Category>> _childrenByParent;
  late Map<String, String> _idToName;

  @override
  void initState() {
    super.initState();
    _buildHierarchy();
    Future.microtask(() =>
        ref.read(categorySelectionProvider.notifier).init(widget.initialSelections));
  }

  void _buildHierarchy() {
    // Provider already sorted by placeOrder — relative order preserved per group
    final roots = widget.categories.where((c) => c.parentId == null).toList();

    _childrenByParent = {};
    for (final c in widget.categories) {
      if (c.parentId != null) {
        _childrenByParent.putIfAbsent(c.parentId!, () => []).add(c);
      }
    }

    _idToName = {for (final c in widget.categories) c.id: c.name};
    _visibleRoots = roots
        .where((r) => _childrenByParent[r.id]?.isNotEmpty ?? false)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // No ref.watch here — outer shell never rebuilds on state changes.
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: context.colors.bgPrimary,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(radiusLarge)),
        border: Border(
          top: BorderSide(
              color: context.colors.border, width: borderWidthDefault),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: spacing16),
              children: [
                const SizedBox(height: spacing16),
                ..._visibleRoots.map(
                  (root) => _CategorySectionWidget(
                    key: ValueKey(root.id),
                    parent: root,
                    children: _childrenByParent[root.id]!,
                    idToName: _idToName,
                    onSelectionChanged: widget.onSelectionChanged,
                  ),
                ),
              ],
            ),
          ),
          _SelectionActionButtons(
            onClearAll: () {
              ref.read(categorySelectionProvider.notifier).clearAll();
              widget.onSelectionChanged({});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(spacing16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: context.colors.border, width: borderWidthDefault),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Select Categories',
              style: h3Style.copyWith(color: context.colors.textPrimary),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(spacing8),
              decoration: BoxDecoration(
                color: context.colors.bgSecondary,
                borderRadius: BorderRadius.circular(radiusSmall),
                border: Border.all(
                    color: context.colors.border, width: borderWidthDefault),
              ),
              child: Icon(Icons.close,
                  size: iconSizeMedium, color: context.colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Per-section widget ────────────────────────────────────────────────────────
// Expand/collapse is local state — only this widget rebuilds when toggled.
// Watches only its own selection via select — other sections never rebuild.

class _CategorySectionWidget extends ConsumerStatefulWidget {
  final Category parent;
  final List<Category> children;
  final Map<String, String> idToName;
  final void Function(Map<String, String?>) onSelectionChanged;

  const _CategorySectionWidget({
    super.key,
    required this.parent,
    required this.children,
    required this.idToName,
    required this.onSelectionChanged,
  });

  @override
  ConsumerState<_CategorySectionWidget> createState() =>
      _CategorySectionWidgetState();
}

class _CategorySectionWidgetState
    extends ConsumerState<_CategorySectionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // print('_CategorySectionWidget ${widget.parent.id} rebuilt');
    final selectedChildId = ref.watch(
      categorySelectionProvider.select((s) => s.selections[widget.parent.id]),
    );
    final selectedChildName =
        selectedChildId != null ? widget.idToName[selectedChildId] : null;

    return Container(
      margin: const EdgeInsets.only(bottom: spacing12),
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(radiusMedium),
        border:
            Border.all(color: context.colors.border, width: borderWidthDefault),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              padding: const EdgeInsets.all(spacing16),
              decoration: BoxDecoration(
                color: _isExpanded
                    ? context.colors.bgTertiary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(radiusMedium),
              ),
              child: Row(
                children: [
                  if (widget.parent.icon.isNotEmpty) ...[
                    _buildParentIcon(context, widget.parent.icon),
                    const SizedBox(width: spacing12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.parent.name,
                          style: bodyTextStyle.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!_isExpanded) ...[
                          const SizedBox(height: spacing4),
                          Text(
                            selectedChildName != null
                                ? 'Selected: $selectedChildName'
                                : 'No selection',
                            style: captionStyle.copyWith(
                              color: selectedChildName != null
                                  ? null
                                  : context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: iconSizeMedium,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(
                  spacing16, spacing8, spacing16, spacing16),
              child: Column(
                children: widget.children
                    .map((child) => _buildChildItem(
                          context: context,
                          child: child,
                          isSelected: selectedChildId == child.id,
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParentIcon(BuildContext context, String url) {
    final placeholder = ShimmerWidgets.imageShimmer(
      context: context,
      width: iconSizeMedium,
      height: iconSizeMedium,
      borderRadius: BorderRadius.circular(radiusSmall),
    );
    final isSvg = url.toLowerCase().contains('.svg');
    if (isSvg) {
      return SvgPicture.network(
        url,
        width: iconSizeMedium,
        height: iconSizeMedium,
        colorFilter:
            ColorFilter.mode(context.colors.textSecondary, BlendMode.srcIn),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: iconSizeMedium,
      height: iconSizeMedium,
      fit: BoxFit.contain,
      placeholder: (_, __) => placeholder,
      errorWidget: (_, __, ___) => const SizedBox.shrink(),
    );
  }

  Widget _buildChildItem({
    required BuildContext context,
    required Category child,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        ref
            .read(categorySelectionProvider.notifier)
            .selectChild(widget.parent.id, child.id);
        final selections = ref.read(categorySelectionProvider).selections;
        widget.onSelectionChanged(Map.from(selections));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: spacing8),
        padding: const EdgeInsets.symmetric(
            horizontal: spacing16, vertical: spacing12),
        decoration: BoxDecoration(
          color: isSelected
              ? brandPrimary.withValues(alpha: 0.1)
              : context.colors.bgPrimary,
          borderRadius: BorderRadius.circular(radiusSmall),
          border: Border.all(
            color: isSelected ? brandPrimary : context.colors.border,
            width: isSelected ? 2 : borderWidthDefault,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: iconSizeMedium,
              height: iconSizeMedium,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? brandPrimary : context.colors.border,
                  width: 2,
                ),
                color: isSelected ? brandPrimary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: _radioCheckSize, color: whiteClr)
                  : null,
            ),
            const SizedBox(width: spacing12),
            Expanded(
              child: Text(
                child.name,
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Action buttons ────────────────────────────────────────────────────────────
// Rebuilds only when the selection count changes.

class _SelectionActionButtons extends ConsumerWidget {
  final VoidCallback onClearAll;

  const _SelectionActionButtons({required this.onClearAll});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('_SelectionActionButtons rebuilt');
    final selectionCount = ref.watch(
      categorySelectionProvider.select(
        (s) => s.selections.values.where((v) => v != null).length,
      ),
    );

    return Container(
      padding: const EdgeInsets.all(spacing16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: context.colors.border, width: borderWidthDefault),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectionCount > 0
                  ? '$selectionCount ${selectionCount == 1 ? 'category' : 'categories'} selected'
                  : 'No categories selected',
              style:
                  bodySmallStyle.copyWith(color: context.colors.textSecondary),
            ),
            const SizedBox(height: spacing12),
            SecondaryButton(
              text: 'Clear All',
              onPressed: selectionCount > 0 ? onClearAll : null,
            ),
          ],
        ),
      ),
    );
  }
}
