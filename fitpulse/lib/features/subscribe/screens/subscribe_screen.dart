import 'package:flutter/material.dart';

final class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Subscribe')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.stars, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text('FitPulse Premium', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Unlock your full potential', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          _feature(theme, Icons.auto_awesome, 'AI-Powered Meal Analysis', 'Unlimited food photo scans with detailed nutrition breakdown'),
          _feature(theme, Icons.bar_chart, 'Advanced Analytics', 'Weekly trends, macro distribution, and personalized insights'),
          _feature(theme, Icons.fitness_center, 'Custom Workout Plans', 'Personalized routines based on your goals and progress'),
          _feature(theme, Icons.cloud_upload, 'Unlimited Photo Storage', 'Track your transformation with unlimited progress photos'),
          _feature(theme, Icons.rocket_launch, 'Priority Support', 'Get help faster with priority email and chat support'),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            child: const Text('Coming Soon'),
          ),
          const SizedBox(height: 8),
          Text('Stay tuned — premium features are on the way!', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _feature(ThemeData theme, IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(desc, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
