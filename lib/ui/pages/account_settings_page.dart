import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/xplorauser_providers.dart';
import '../../domain/models/xplora_user.dart';
import '../../theme.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Account',
      ),
      body: GradientBackground(
        child: ListView(
          children: ref.watch(currentAuthUserStreamProvider).when(
                data: (user) {
                  if (user == null) {
                    return [
                      Center(
                        child: Text(
                          'User not found',
                          style: bodyTextStyle.copyWith(color: textSecondary),
                        ),
                      ),
                    ];
                  }
                  return [
                    ListTile(
                      title: Text(
                        'Email',
                        style: bodyTextStyle.copyWith(color: textPrimary),
                      ),
                      subtitle: Text(
                        user.email,
                        style: bodyTextStyle.copyWith(color: textSecondary),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditEmailPage(user: user),
                          ),
                        );
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: textSecondary,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Display Name',
                        style: bodyTextStyle.copyWith(color: textPrimary),
                      ),
                      subtitle: Text(
                        user.displayName,
                        style: bodyTextStyle.copyWith(color: textSecondary),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditDisplayNamePage(user: user),
                          ),
                        );
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: textSecondary,
                      ),
                    ),
                  ];
                },
                loading: () => [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: accentPrimary,
                      ),
                    ),
                  )
                ],
                error: (error, stackTrace) {
                  return [
                    Center(
                      child: Text(
                        'Error: $error',
                        style: bodyTextStyle.copyWith(color: feedbackAlert),
                      ),
                    ),
                  ];
                },
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
                height: 50,
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
                            'Failed to update display name: $e',
                            style: bodyTextStyle.copyWith(color: textPrimary),
                          ),
                          backgroundColor: feedbackAlert,
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
                height: 50,
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
                            'Failed to update email: $e',
                            style: bodyTextStyle.copyWith(color: textPrimary),
                          ),
                          backgroundColor: feedbackAlert,
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
