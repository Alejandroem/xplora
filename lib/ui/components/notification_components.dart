import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Commented for future use when real data is available
// import '../../application/providers/notifications_providers.dart';
// import '../../domain/models/adventure.dart';
// import '../../domain/models/quest.dart';
import '../../theme.dart';
import '../widgets/notifications_page/notification_item_tile.dart';

class NotificationComponents extends ConsumerStatefulWidget {
  const NotificationComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationComponentsState();
}

class _NotificationComponentsState
    extends ConsumerState<NotificationComponents> {
  // ============================================================================
  // COMMENTED OUT: Previous provider-based logic (for future use with real data)
  // ============================================================================

  // /// Helper method to get SVG icon path for notification type
  // String _getNotificationSvgIcon(dynamic item) {
  //   if (item is Quest) {
  //     return 'assets/svg/compass.svg';
  //   } else if (item is Adventure) {
  //     return 'assets/svg/location-pin.svg';
  //   }
  //   return 'assets/svg/compass.svg'; // Default
  // }

  // /// Helper method to get color for notification icon
  // /// Alternates between purple and teal colors
  // Color _getNotificationColor(int index) {
  //   if (index % 2 == 0) {
  //     // Purple color
  //     return brandPrimary;
  //   } else {
  //     // Teal color
  //     return brandSecondary;
  //   }
  // }

  // /// Helper method to format time ago
  // String _timeAgo(DateTime? dateTime) {
  //   if (dateTime == null) return 'Just now';
  //   final now = DateTime.now();
  //   final difference = now.difference(dateTime);

  //   if (difference.inDays > 365) {
  //     final years = (difference.inDays / 365).floor();
  //     return '${years}y ago';
  //   } else if (difference.inDays > 30) {
  //     final months = (difference.inDays / 30).floor();
  //     return '${months}mo ago';
  //   } else if (difference.inDays > 0) {
  //     return difference.inDays == 1 ? 'Yesterday' : '${difference.inDays}d ago';
  //   } else if (difference.inHours > 0) {
  //     return '${difference.inHours}h ago';
  //   } else if (difference.inMinutes > 0) {
  //     return '${difference.inMinutes}m ago';
  //   } else {
  //     return 'Just now';
  //   }
  // }

  /// Helper method to get color for notification icon
  /// Alternates between purple and teal colors
  Color _getNotificationColor(int index) {
    if (index % 2 == 0) {
      return brandPrimary; // Purple
    } else {
      return brandSecondary; // Teal
    }
  }

  @override
  Widget build(BuildContext context) {
    // ============================================================================
    // TEMPORARY: Dummy notifications matching the design
    // To use real data:
    // 1. Uncomment the imports at the top
    // 2. Uncomment the helper methods above
    // 3. Replace this dummy data section with the commented provider-based body below
    // ============================================================================
    final dummyNotifications = [
      {
        'svgIcon': 'assets/svg/compass-purple.svg',
        'title': 'Quest Available: Sunset Walk',
        'description': 'A new quest has been unlocked near you.',
        'timeAgo': '2h ago',
      },
      {
        'svgIcon': 'assets/svg/badge.svg',
        'title': 'Level Up!',
        'description': 'You reached Level 6.',
        'timeAgo': '3h ago',
      },
      {
        'svgIcon': 'assets/svg/stats-arrow-up.svg',
        'title': 'New Place Nearby',
        'description': 'Ocean Park Boardwalk is trending.',
        'timeAgo': '3h ago',
      },
      {
        'svgIcon': 'assets/svg/user-add.svg',
        'title': 'New Friend Request',
        'description': '@emilia_explorer wants to be friends.',
        'timeAgo': 'Yesterday',
      },
      {
        'svgIcon': 'assets/svg/download.svg',
        'title': 'Update Complete',
        'description': 'The Explore Map has been updated',
        'timeAgo': '3d ago',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: dummyNotifications.length,
      itemBuilder: (context, index) {
        final notification = dummyNotifications[index];
        final isLastItem = index == dummyNotifications.length - 1;
        return NotificationItemTile(
          svgIconPath: notification['svgIcon'] as String,
          iconBackgroundColor: _getNotificationColor(index),
          title: notification['title'] as String,
          description: notification['description'] as String,
          timeAgo: notification['timeAgo'] as String,
          isLast: isLastItem,
          onTap: () {
            // Handle notification tap
          },
        );
      },
    );

    // ============================================================================
    // COMMENTED OUT: Previous provider-based body (for future use with real data)
    // ============================================================================
    // body: ref.watch(userPreviousActivitiesProviderStream).when(
    //       data: (items) {
    //         if (items.isEmpty) {
    //           return SizedBox(
    //             height: MediaQuery.of(context).size.height * 0.8,
    //             child: Center(
    //               child: Text(
    //                 'No notifications found',
    //                 style: bodyTextStyle.copyWith(
    //                   color: context.colors.textSecondary,
    //                 ),
    //               ),
    //             ),
    //           );
    //         }
    //         return ListView.builder(
    //           itemCount: items.length,
    //           itemBuilder: (context, index) {
    //             final item = items[index];
    //             final isLastItem = index == items.length - 1;
    //             String title = '';
    //             String description = '';
    //             DateTime? timestamp;

    //             if (item is Quest) {
    //               title = 'Quest Available: ${item.title}';
    //               description = item.shortDescription;
    //               timestamp = item.completedAt;
    //             } else if (item is Adventure) {
    //               title = 'Adventure Completed: ${item.title}';
    //               description = item.shortDescription;
    //               timestamp = item.completedAt;
    //             }

    //             return NotificationItemTile(
    //               svgIconPath: _getNotificationSvgIcon(item),
    //               iconBackgroundColor: _getNotificationColor(index),
    //               title: title,
    //               description: description,
    //               timeAgo: _timeAgo(timestamp),
    //               isLast: isLastItem,
    //               onTap: () {
    //                 // Handle notification tap
    //               },
    //             );
    //           },
    //         );
    //       },
    //       loading: () => SizedBox(
    //         height: MediaQuery.of(context).size.height * 0.8,
    //         child: const Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       ),
    //       error: (err, stack) => Center(
    //         child: Text(
    //           'Error loading notifications',
    //           style: bodyTextStyle.copyWith(
    //             color: context.colors.textSecondary,
    //           ),
    //         ),
    //       ),
    //     ),
  }
}

// AdventureCard widget to display each adventure
