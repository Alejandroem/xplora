import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../theme.dart';

class BottomChangePasswordCard extends ConsumerStatefulWidget {
  const BottomChangePasswordCard({super.key});

  @override
  ConsumerState<BottomChangePasswordCard> createState() =>
      _BottomChangePasswordCardState();
}

class _BottomChangePasswordCardState
    extends ConsumerState<BottomChangePasswordCard> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff121212), /// Solid background to prevent text interference
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: accentPrimary.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            'Change Password',
            style: h3Style.copyWith(color: textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          // Old Password Field
          XploraTextField(
            controller: oldPasswordController,
            labelText: 'Old Password',
            obscureText: obscureOldPassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscureOldPassword ? Icons.visibility : Icons.visibility_off,
                color: textSecondary,
              ),
              onPressed: () {
                setState(() {
                  obscureOldPassword = !obscureOldPassword;
                });
              },
            ),
          ),
          const SizedBox(height: 16.0),
          // New Password Field
          XploraTextField(
            controller: newPasswordController,
            labelText: 'New Password',
            obscureText: obscureNewPassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                color: textSecondary,
              ),
              onPressed: () {
                setState(() {
                  obscureNewPassword = !obscureNewPassword;
                });
              },
            ),
          ),
          const SizedBox(height: 16.0),
          // Confirm Password Field
          XploraTextField(
            controller: confirmPasswordController,
            labelText: 'Confirm New Password',
            obscureText: obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                color: textSecondary,
              ),
              onPressed: () {
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
            ),
          ),
          const SizedBox(height: 24.0),
          // Submit Button
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: accentPrimary,
                  ),
                )
              : PrimaryButton(
                  height: 50,
                  text: 'Change Password',
                  onPressed: () async {
                    if (newPasswordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'New passwords do not match',
                            style: bodyTextStyle.copyWith(color: textPrimary),
                          ),
                          backgroundColor: feedbackAlert,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final user = await authService.getAuthUser();
                      await authService.signInWithEmailAndPassword(
                        user!.email,
                        oldPasswordController.text,
                      );
                      await authService
                          .changePassword(newPasswordController.text);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Password changed successfully',
                              style: bodyTextStyle.copyWith(color: textPrimary),
                            ),
                            backgroundColor: accentPrimary,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to change password: $e',
                              style: bodyTextStyle.copyWith(color: textPrimary),
                            ),
                            backgroundColor: feedbackAlert,
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                ),
        ],
      ),
    );
  }
}

void showBottomChangePasswordCard(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    context: context,
    backgroundColor: Colors.transparent, /// Transparent to show custom background
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const BottomChangePasswordCard(),
      );
    },
  );
}
