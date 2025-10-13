import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/xplorauser_providers.dart';
import '../../domain/models/xplora_user.dart';

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
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        children: ref.watch(currentAuthUserStreamProvider).when(
              data: (user) {
                if (user == null) {
                  return [
                    const Center(
                      child: Text('User not found'),
                    ),
                  ];
                }
                return [
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditEmailPage(user: user),
                        ),
                      );
                    },
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  // First name and last name
                  ListTile(
                    title: const Text('First Name'),
                    subtitle: Text(user.name.split(RegExp(r'\s+')).first),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditFirstNamePage(user: user),
                        ),
                      );
                    },
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    title: const Text('Last Name'),
                    subtitle:
                        Text(user.name.split(RegExp(r'\s+')).skip(1).join(' ')),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditLastNamePage(user: user),
                        ),
                      );
                    },
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ];
              },
              loading: () => [const Center(child: CircularProgressIndicator())],
              error: (error, stackTrace) {
                return [
                  Center(
                    child: Text('Error: $error'),
                  ),
                ];
              },
            ),
      ),
    );
  }
}

class EditLastNamePage extends ConsumerStatefulWidget {
  final XploraUser user;

  const EditLastNamePage({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditLastNamePageState();
}

class _EditLastNamePageState extends ConsumerState<EditLastNamePage> {
  late TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();
    lastNameController = TextEditingController(
      text: widget.user.name.split(RegExp(r'\s+')).skip(1).join(' '),
    );
  }

  @override
  void dispose() {
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Last Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final newName =
                    '${widget.user.name.split(RegExp(r'\s+')).first} ${lastNameController.text}';
                try {
                  await authService.updateName(newName);
                  ref.read(userServiceProvider).update(
                        widget.user.copyWith(name: newName),
                        widget.user.id!,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Last name updated')),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update last name: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditFirstNamePage extends ConsumerStatefulWidget {
  final XploraUser user;

  const EditFirstNamePage({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditFirstNamePageState();
}

class _EditFirstNamePageState extends ConsumerState<EditFirstNamePage> {
  late TextEditingController firstNameController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(
      text: widget.user.name.split(RegExp(r'\s+')).first,
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit First Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final newName =
                    '${firstNameController.text} ${widget.user.name.split(RegExp(r'\s+')).skip(1).join(' ')}';
                try {
                  await authService.updateName(newName);
                  ref.read(userServiceProvider).update(
                        widget.user.copyWith(name: newName),
                        widget.user.id!,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('First name updated')),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update first name: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
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
      appBar: AppBar(
        title: const Text('Edit Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  await authService.updateEmail(emailController.text);
                  ref.read(userServiceProvider).update(
                        widget.user.copyWith(email: emailController.text),
                        widget.user.id!,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email updated')),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update email: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
