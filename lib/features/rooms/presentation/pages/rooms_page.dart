import 'package:flutter/material.dart';
import 'package:malaz/core/di/providers.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/features/auth/presentation/cubit/auth_cubit.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              getIt<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surfaceColor,
              AppColors.surfaceColor.withValues(alpha: 0.8),
              AppColors.surfaceColor.withValues(alpha: 0.6),
              AppColors.surfaceColor.withValues(alpha: 0.4),
              AppColors.surfaceColor.withValues(alpha: 0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _HeroCard(),
              const SizedBox(height: 20),
              Text(
                'Architecture scaffold',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              const _StructureCard(
                title: 'data/',
                body:
                    'datasources/, models/, mappers/, and repositories/ are present as placeholders.',
              ),
              const SizedBox(height: 12),
              const _StructureCard(
                title: 'domain/',
                body:
                    'entities/ and repositories/ define feature boundaries without behavior yet.',
              ),
              const SizedBox(height: 12),
              const _StructureCard(
                title: 'presentation/',
                body:
                    'cubit/ and pages/ are scaffolded so the feature can be wired in later.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: AppColors.primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Malaz architecture',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.onPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This app currently exposes only the clean folder structure so feature logic can be added intentionally later.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onPrimaryColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _StructureCard extends StatelessWidget {
  const _StructureCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(body),
        ],
      ),
    );
  }
}
