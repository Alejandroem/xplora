import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';

/// Bottom sheet for selecting categories with expandable sections
class CategorySelectionBottomSheet extends ConsumerStatefulWidget {
  final Map<String, List<String>> categoryData;
  final Map<String, String?> initialSelections;
  final Function(Map<String, String?>) onSelectionChanged;

  const CategorySelectionBottomSheet({
    super.key,
    required this.categoryData,
    required this.initialSelections,
    required this.onSelectionChanged,
  });

  @override
  ConsumerState<CategorySelectionBottomSheet> createState() =>
      _CategorySelectionBottomSheetState();
}

class _CategorySelectionBottomSheetState
    extends ConsumerState<CategorySelectionBottomSheet> {
  late Map<String, String?> _selections;
  final Set<String> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    _selections = Map.from(widget.initialSelections);
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Outdoors & Nature':
        return Icons.park;
      case 'Sports & Fitness':
        return Icons.fitness_center;
      case 'Art & Culture':
        return Icons.palette;
      case 'Entertainment':
        return Icons.theater_comedy;
      case 'Other':
        return Icons.category;
      case 'Group Type':
        return Icons.people;
      case 'Difficulty':
        return Icons.trending_up;
      case 'Best Time to Visit':
        return Icons.access_time;
      case 'Vibe Tag':
        return Icons.mood;
      case 'Food & Drink':
        return Icons.restaurant;
      case 'Shopping & Local':
        return Icons.shopping_bag;
      case 'Relax & Wellness':
        return Icons.spa;
      case 'Accommodations':
        return Icons.hotel;
      case 'Coworking':
        return Icons.work;
      default:
        return Icons.label;
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_expandedCategories.contains(category)) {
        _expandedCategories.remove(category);
      } else {
        _expandedCategories.add(category);
      }
    });
  }

  void _selectChild(String parent, String child) {
    setState(() {
      // If the same child is already selected, deselect it
      if (_selections[parent] == child) {
        _selections[parent] = null;
      } else {
        _selections[parent] = child;
      }
    });
    // Auto-save selection with new map instance
    widget.onSelectionChanged(Map.from(_selections));
  }

  void _clearAll() {
    setState(() {
      _selections = {
        for (var key in _selections.keys) key: null,
      };
    });
    // Auto-save after clearing with new map instance
    widget.onSelectionChanged(Map.from(_selections));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.85,
      ),
      decoration: BoxDecoration(
        color: context.colors.bgPrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(radiusLarge),
        ),
        border: Border(
          top: BorderSide(
            color: context.colors.border,
            width: borderWidthDefault,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(),

          // Scrollable category list
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: spacing16),
              children: [
                const SizedBox(height: spacing16),
                ...widget.categoryData.entries
                    .where((entry) => entry.value.isNotEmpty)
                    .map((entry) => _buildCategorySection(
                          entry.key,
                          entry.value,
                        )),
              ],
            ),
          ),

          // Action buttons
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
            color: context.colors.border,
            width: borderWidthDefault,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Select Categories',
              style: h3Style.copyWith(
                color: context.colors.textPrimary,
              ),
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
                  color: context.colors.border,
                  width: borderWidthDefault,
                ),
              ),
              child: Icon(
                Icons.close,
                size: iconSizeMedium,
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String parent, List<String> children) {
    final isExpanded = _expandedCategories.contains(parent);
    final selectedChild = _selections[parent];
    final icon = _getIconForCategory(parent);

    return Container(
      margin: const EdgeInsets.only(bottom: spacing12),
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(
          color: context.colors.border,
          width: borderWidthDefault,
        ),
      ),
      child: Column(
        children: [
          // Parent header (tappable to expand/collapse)
          GestureDetector(
            onTap: () => _toggleCategory(parent),
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
                  Icon(
                    icon,
                    size: iconSizeMedium,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(width: spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parent,
                          style: bodyTextStyle.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (selectedChild != null && !isExpanded) ...[
                          const SizedBox(height: spacing4),
                          Text(
                            'Selected: $selectedChild',
                            style: captionStyle
                          ),
                        ],
                        if (selectedChild == null && !isExpanded) ...[
                          const SizedBox(height: spacing4),
                          Text(
                            'No selection',
                            style: captionStyle.copyWith(
                              color: context.colors.textSecondary,
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

          // Children (shown when expanded)
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(
                spacing16,
                spacing8,
                spacing16,
                spacing16,
              ),
              child: Column(
                children: children.map((child) {
                  final isSelected = selectedChild == child;
                  return GestureDetector(
                    onTap: () => _selectChild(parent, child),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: spacing8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacing16,
                        vertical: spacing12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? brandPrimary.withValues(alpha: 0.1)
                            : context.colors.bgPrimary,
                        borderRadius: BorderRadius.circular(radiusSmall),
                        border: Border.all(
                          color: isSelected
                              ? brandPrimary
                              : context.colors.border,
                          width: isSelected ? 2 : borderWidthDefault,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? brandPrimary
                                    : context.colors.border,
                                width: 2,
                              ),
                              color: isSelected
                                  ? brandPrimary
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 14,
                                    color: whiteClr,
                                  )
                                : null,
                          ),
                          const SizedBox(width: spacing12),
                          Expanded(
                            child: Text(
                              child,
                              style: bodyTextStyle.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final selectionCount =
        _selections.values.where((v) => v != null).length;

    return Container(
      padding: const EdgeInsets.all(spacing16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.colors.border,
            width: borderWidthDefault,
          ),
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
              style: bodySmallStyle.copyWith(
                color: context.colors.textSecondary,
              ),
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