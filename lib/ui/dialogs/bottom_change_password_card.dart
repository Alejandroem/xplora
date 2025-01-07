import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';

class BottomChangePasswordCard extends ConsumerStatefulWidget {
  BottomChangePasswordCard({super.key});

  @override
  _BottomChangePasswordCardState createState() =>
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
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: oldPasswordController,
            decoration: InputDecoration(
              labelText: 'Old Password',
              suffixIcon: IconButton(
                icon: Icon(obscureOldPassword
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    obscureOldPassword = !obscureOldPassword;
                  });
                },
              ),
            ),
            obscureText: obscureOldPassword,
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: newPasswordController,
            decoration: InputDecoration(
              labelText: 'New Password',
              suffixIcon: IconButton(
                icon: Icon(obscureNewPassword
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    obscureNewPassword = !obscureNewPassword;
                  });
                },
              ),
            ),
            obscureText: obscureNewPassword,
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              suffixIcon: IconButton(
                icon: Icon(obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    obscureConfirmPassword = !obscureConfirmPassword;
                  });
                },
              ),
            ),
            obscureText: obscureConfirmPassword,
          ),
          const SizedBox(height: 16.0),
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    if (newPasswordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('New passwords do not match')),
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
                          const SnackBar(
                              content: Text('Password changed successfully')),
                        );
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed to change password: $e')),
                        );
                      }
                    } finally {
                      if (context.mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                  child: const Text('Change Password'),
                ),
        ],
      ),
    );
  }
}

void showBottomChangePasswordCard(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BottomChangePasswordCard(),
      );
    },
  );
}
