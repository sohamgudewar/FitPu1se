import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/auth_provider.dart';

final class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite, size: 80, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text('FitPulse', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Your AI-powered fitness companion', style: theme.textTheme.bodyLarge),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: auth.isLoggedIn ? null : () => ref.read(authProvider).signInWithGoogle(),
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
