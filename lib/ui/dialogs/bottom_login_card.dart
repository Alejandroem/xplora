import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import 'bottom_signup_card.dart';

void showBottomLoginCard(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: true,
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
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        onChanged: (value) {
                          ref
                              .read(loginFormNotifierProvider.notifier)
                              .setEmail(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.visibility,
                            ),
                            onPressed: () {
                              ref
                                  .read(loginFormNotifierProvider.notifier)
                                  .toggleObscureText();
                            },
                          ),
                        ),
                        obscureText:
                            ref.watch(loginFormNotifierProvider).obscureText,
                        onChanged: (value) {
                          ref
                              .read(loginFormNotifierProvider.notifier)
                              .setPassword(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: ref
                                    .watch(loginFormNotifierProvider)
                                    .errors
                                    .isEmpty &&
                                ref
                                    .watch(loginFormNotifierProvider)
                                    .touchedPassword &&
                                !ref.watch(loginFormNotifierProvider).isLoading
                            ? () async {
                                try {
                                  await ref
                                      .read(loginFormNotifierProvider.notifier)
                                      .login();
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  log(e.toString());
                                }
                              }
                            : null,
                        child: ref.watch(loginFormNotifierProvider).isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : const Text(
                                'Login',
                              ),
                      ),
                      const SizedBox(height: 16),
                      if (ref
                          .watch(loginFormNotifierProvider)
                          .errors
                          .isNotEmpty)
                        Text(
                          ref.watch(loginFormNotifierProvider).errors.first,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      TextButton(
                        onPressed: () {
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                          showBottomSignUpCard(context, modal: false);
                        },
                        child: const Text('Don\'t have an account? Sign up'),
                      ),
                    ],
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
