import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/profile_providers.dart' as profile_providers;
import '../../application/providers/xplorauser_providers.dart';
import '../../domain/models/xplora_user.dart';
import '../../theme.dart';
import '../dialogs/delete_account_confirmation_dialog.dart';
import '../widgets/settings_tile.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage> {
  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return XploraTextField(
      controller: TextEditingController(text: value),
      labelText: label,
      readOnly: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentAuthUserStreamProvider);

    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Account',
                style: h2Style.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                'Settings',
                style: bodySmallStyle.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          centerTitle: true,
          height: 94,
        ),
        body: userAsync.when(
          data: (user) {
            if (user == null) {
              return Center(
                child: Text(
                  'User not found',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: spacing16,
                children: [
                  // Profile Information Section
                  Text(
                    'Profile Information',
                    style: h3Style.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  _buildInfoItem(
                    context,
                    'Username',
                    user.username.isNotEmpty
                        ? '@${user.username}'
                        : 'Not set',
                  ),
                  _buildInfoItem(
                    context,
                    'Display Name',
                    user.displayName.isNotEmpty
                        ? user.displayName
                        : 'Not set',
                  ),
                  _buildInfoItem(
                    context,
                    'Email',
                    user.email,
                  ),
                  _buildInfoItem(
                    context,
                    'Date of Birth',
                    '12-1-2000', // Dummy for now
                  ),
                  _buildInfoItem(
                    context,
                    'Account Type',
                    'Free', // Dummy for now Account type will be- Free or the subscription plan name
                  ),
                  // Account Management Section
                  Padding(
                    padding: const EdgeInsets.only(top: spacing8),
                    child: Text(
                      'Account Management',
                      style: h3Style.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                  PrimaryButton(
                    text: 'Delete Account',
                    onPressed: () async {
                      // Show confirmation dialog
                      final confirmed = await showDeleteAccountConfirmationDialog(context);

                      if (confirmed == true && context.mounted) {
                        final xploraProfileProvider = ref.read(profile_providers.profileServiceProvider);
                        final authProvider = ref.read(authServiceProvider);
                        await xploraProfileProvider.delete(user.id!);
                        await authProvider.deleteAccount();
                        if (context.mounted) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: brandPrimary,
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Error: $error',
              style: bodyTextStyle.copyWith(color: errorColor),
            ),
          ),
        ),
      ),
    );
  }
}

class EditDisplayNamePage extends ConsumerStatefulWidget {
  final XploraUser user;

  const EditDisplayNamePage({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditDisplayNamePageState();
}

class _EditDisplayNamePageState extends ConsumerState<EditDisplayNamePage> {
  late TextEditingController displayNameController;

  @override
  void initState() {
    super.initState();
    displayNameController = TextEditingController(
      text: widget.user.displayName,
    );
  }

  @override
  void dispose() {
    displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Edit Display Name',
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              XploraTextField(
                controller: displayNameController,
                labelText: 'Display Name',
              ),
              const SizedBox(height: 24.0),
              PrimaryButton(
                text: 'Save',
                onPressed: () async {
                  final newDisplayName = displayNameController.text.trim();
                  try {
                    await authService.updateName(newDisplayName);
                    ref.read(userServiceProvider).update(
                          widget.user.copyWith(displayName: newDisplayName),
                          widget.user.id!,
                        );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Display name updated',
                            style: bodyTextStyle.copyWith(color: context.colors.textPrimary),
                          ),
                          backgroundColor: brandPrimary,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to update display name: $e',
                            style: bodyTextStyle.copyWith(color: context.colors.textPrimary),
                          ),
                          backgroundColor: errorColor,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class EditEmailPage extends ConsumerStatefulWidget {
  final XploraUser user;

  const EditEmailPage({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends ConsumerState<EditEmailPage> {
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(
      text: widget.user.email,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Edit Email',
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              XploraTextField(
                controller: emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24.0),
              PrimaryButton(
                text: 'Save',
                onPressed: () async {
                  try {
                    await authService.updateEmail(emailController.text);
                    ref.read(userServiceProvider).update(
                          widget.user.copyWith(email: emailController.text),
                          widget.user.id!,
                        );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Email updated',
                            style: bodyTextStyle.copyWith(color: context.colors.textPrimary),
                          ),
                          backgroundColor: brandPrimary,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to update email: $e',
                            style: bodyTextStyle.copyWith(color: context.colors.textPrimary),
                          ),
                          backgroundColor: errorColor,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
