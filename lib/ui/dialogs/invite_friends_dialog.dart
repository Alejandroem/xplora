import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../theme.dart';
import '../widgets/total_xp_badge.dart';
import 'base_dialog.dart';

/// Invite Friends Dialog - Shows QR code and sharing options
class InviteFriendsDialog extends ConsumerStatefulWidget {
  const InviteFriendsDialog({super.key});

  @override
  ConsumerState<InviteFriendsDialog> createState() =>
      _InviteFriendsDialogState();
}

class _InviteFriendsDialogState extends ConsumerState<InviteFriendsDialog> {
  // Static placeholder data (will be replaced with real data later)
  final String _inviteLink = 'https://xplora.app/invite/ABC123';
  final String _shareMessage =
      'Join me on XPLORA and explore amazing places together! Use my invite link to earn bonus XP: https://xplora.app/invite/ABC123';
  bool _linkCopied = false;

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: _inviteLink));
    setState(() {
      _linkCopied = true;
    });

    // Reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _linkCopied = false;
        });
      }
    });
  }

  void _shareLink() async {
    try {
      await Share.share(
        _shareMessage,
        subject: 'Join me on XPLORA!',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to share',
              style: bodyTextStyle.copyWith(color: context.colors.textPrimary),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return BaseDialog(
      showCloseButton: true,
      icon: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: context.colors.iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: context.colors.iconColor.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.card_giftcard,
          color: context.colors.iconColor,
          size: 40,
        ),
      ),
      title: 'Invite friends and earn XP together',
      description: '',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // QR Code placeholder
          Container(
            width: width * 0.55,
            height: height * 0.26,
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.qr_code_2,
                size: width * 0.55,
                color: Colors.black.withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Invite link section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.bgTertiary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.colors.border,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your invite link',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _inviteLink,
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textPrimary,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _copyLink,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.colors.iconColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _linkCopied ? Icons.check : Icons.copy,
                          size: 18,
                          color: context.colors.iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Column(
          spacing: 26,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: SecondaryButton(
                      text: 'Done',
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    onPressed: _shareLink,
                    text: 'Share Link',
                  ),
                ),
              ],
            ),
            TotalXpBadge(xp: 50),
          ],
        ),
      ],
    );
  }
}

/// Helper function to show the invite friends dialog
Future<void> showInviteFriendsDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return const InviteFriendsDialog();
    },
  );
}
