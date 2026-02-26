import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/models/category.dart';
import '../../theme.dart';

const double _radioCheckSize = 14.0;

/// Bottom sheet for selecting categories with expandable sections.
/// Selections are stored as Map<parentId, selectedChildId>.
class CategorySelectionBottomSheet extends StatefulWidget {
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
  State<CategorySelectionBottomSheet> createState() =>
      _CategorySelectionBottomSheetState();
}

class _CategorySelectionBottomSheetState
    extends State<CategorySelectionBottomSheet> {
  late Map<String, String?> _selections;
  final Set<String> _expandedCategories = {};

  late List<Category> _visibleRoots;
  late Map<String, List<Category>> _childrenByParent;
  late Map<String, String> _idToName;

  @override
  void initState() {
    super.initState();
    _selections = Map.from(widget.initialSelections);
    _buildHierarchy();
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

  Widget _buildParentIcon(String url) {
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
      errorWidget: (_, __, ___) => const SizedBox.shrink(),
    );
  }

  void _toggleCategory(String parentId) {
    setState(() {
      if (_expandedCategories.contains(parentId)) {
        _expandedCategories.remove(parentId);
      } else {
        _expandedCategories.add(parentId);
      }
    });
  }

  void _selectChild(String parentId, String childId) {
    setState(() {
      _selections[parentId] =
          _selections[parentId] == childId ? null : childId;
    });
    widget.onSelectionChanged(Map.from(_selections));
  }

  void _clearAll() {
    setState(() {
      _selections = {};
    });
    widget.onSelectionChanged({});
  }

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: spacing16),
              children: [
                const SizedBox(height: spacing16),
                ..._visibleRoots.map(
                  (root) => _buildCategorySection(
                    root,
                    _childrenByParent[root.id]!,
                  ),
                ),
              ],
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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

  Widget _buildCategorySection(Category parent, List<Category> children) {
    final isExpanded = _expandedCategories.contains(parent.id);
    final selectedChildId = _selections[parent.id];
    final selectedChildName =
        selectedChildId != null ? _idToName[selectedChildId] : null;

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
            onTap: () => _toggleCategory(parent.id),
            child: Container(
              padding: const EdgeInsets.all(spacing16),
              decoration: BoxDecoration(
                color: isExpanded
                    ? context.colors.bgTertiary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(radiusMedium),
              ),
              child: Row(
                children: [
                  if (parent.icon.isNotEmpty) ...[
                    _buildParentIcon(parent.icon),
                    const SizedBox(width: spacing12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parent.name,
                          style: bodyTextStyle.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isExpanded) ...[
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
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: iconSizeMedium,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(
                  spacing16, spacing8, spacing16, spacing16),
              child: Column(
                children: children
                    .map((child) => _buildChildItem(
                          child: child,
                          parentId: parent.id,
                          isSelected: selectedChildId == child.id,
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChildItem({
    required Category child,
    required String parentId,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _selectChild(parentId, child.id),
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

  Widget _buildActionButtons() {
    final selectionCount = _selections.values.where((v) => v != null).length;

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
              onPressed: selectionCount > 0 ? _clearAll : null,
            ),
          ],
        ),
      ),
    );
  }
}
