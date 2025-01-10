import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/local_storage_providers.dart';

class EmailVerificationBanner extends ConsumerStatefulWidget {
  const EmailVerificationBanner({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerificationBannerState();
}

class _EmailVerificationBannerState
    extends ConsumerState<EmailVerificationBanner> {
  bool _isButtonDisabled = false;
  Timer? _timer;
  int _remainingSeconds = 0;

  void _startTimer() {
    setState(() {
      _isButtonDisabled = true;
      _remainingSeconds = 120; // 2 minutes
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _isButtonDisabled = false;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localStorage = ref.watch(localStorageProvider);
    return FutureBuilder<String?>(
      future: localStorage.read('lastDateEmailSent'),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        final lastSentStr = snapshot.data;
        bool isWithin2Hours = false;
        if (lastSentStr != null) {
          final lastSentDate = DateTime.parse(lastSentStr);
          if (DateTime.now().difference(lastSentDate).inHours < 2) {
            isWithin2Hours = true;
          }
        }
        if (isWithin2Hours) {
          return const SizedBox();
        }
        return ref.watch(currentAuthUserStreamProvider).when(
              data: (user) {
                if (user == null || user.isEmailVerified) {
                  return const SizedBox();
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 54,
                  color: Colors.amber,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Icon(Icons.warning),
                      const SizedBox(width: 8),
                      const Text('Please verify your email'),
                      const Spacer(),
                      _isButtonDisabled
                          ? OutlinedButton(
                              onPressed: null,
                              child: Text('Retry in $_remainingSeconds s'),
                            )
                          : OutlinedButton(
                              onPressed: () async {
                                ref
                                    .read(authServiceProvider)
                                    .sendEmailVerification();
                                await localStorage.save(
                                  'lastDateEmailSent',
                                  DateTime.now().toIso8601String(),
                                );
                                _startTimer();
                              },
                              child: const Text('Resend'),
                            ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(),
              error: (error, stackTrace) {
                return Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(8),
                  child: const Row(
                    children: [
                      Icon(Icons.error),
                      SizedBox(width: 8),
                      Text('An error occurred'),
                    ],
                  ),
                );
              },
            );
      },
    );
  }
}
