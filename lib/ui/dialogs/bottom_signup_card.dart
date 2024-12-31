import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/profile_providers.dart';
import 'bottom_login_card.dart';

void showBottomSignUpCard(BuildContext context, {bool modal = true}) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: !modal,
    context: context,
    builder: (_) {
      return Builder(builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Consumer(
              builder: (context, ref, child) {
                final signUpState = ref.watch(signupFormNotifierProvider);
                final signUpNotifier =
                    ref.read(signupFormNotifierProvider.notifier);
                return PopScope(
                  canPop: !modal,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                          onChanged: (value) async {
                            signUpNotifier.setUsername(value);

                            if (value.isNotEmpty) {
                              final profileService =
                                  ref.read(profileServiceProvider);

                              // Check if the username is unique
                              final existingUsers =
                                  await profileService.readByFilters([
                                {
                                  'field': 'username',
                                  'operator': '==',
                                  'value': value,
                                }
                              ]);

                              final isUnique = existingUsers?.isEmpty ?? true;
                              signUpNotifier.setUsernameUnique(isUnique);
                            } else {
                              signUpNotifier.setUsernameUnique(false);
                            }
                          },
                        ),
                        if (!signUpState.isUsernameUnique &&
                            signUpState.touchedUsername)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Username is already taken',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'First Name',
                                ),
                                onChanged: (value) {
                                  ref
                                      .read(signupFormNotifierProvider.notifier)
                                      .setFirstName(value);
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Last Name',
                                ),
                                onChanged: (value) {
                                  ref
                                      .read(signupFormNotifierProvider.notifier)
                                      .setLastName(value);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                          onChanged: (value) {
                            ref
                                .read(signupFormNotifierProvider.notifier)
                                .setEmail(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: false,
                          onChanged: (value) {
                            ref
                                .read(signupFormNotifierProvider.notifier)
                                .setPassword(value);
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                          ),
                          obscureText: false,
                          onChanged: (value) {
                            ref
                                .read(signupFormNotifierProvider.notifier)
                                .setConfirmPassword(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        if (ref
                            .watch(signupFormNotifierProvider)
                            .errors
                            .isNotEmpty)
                          Text(
                            ref.watch(signupFormNotifierProvider).errors.first,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ElevatedButton(
                          onPressed: ref
                                      .watch(signupFormNotifierProvider)
                                      .errors
                                      .isEmpty &&
                                  ref
                                      .watch(signupFormNotifierProvider)
                                      .touchedPassword &&
                                  !ref
                                      .watch(signupFormNotifierProvider)
                                      .isLoading
                              ? () async {
                                  await ref
                                      .read(signupFormNotifierProvider.notifier)
                                      .signUp();

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              : null,
                          child: ref.watch(signupFormNotifierProvider).isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('Sign Up'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                            showBottomLoginCard(context);
                          },
                          child: const Text('Already have an account? Login'),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      });
    },
  );
}
