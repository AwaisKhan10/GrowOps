import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_state.dart';
import '../core/feedback/app_snackbar.dart';
import '../core/theme/app_text_styles.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../theme.dart';
import '../widgets.dart';

class WorkspaceRouter extends StatelessWidget {
  const WorkspaceRouter({super.key, required this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    if (route == '/profile') return const ProfileScreen();
    if (route == '/workspace/invite') return const InviteScreen();
    if (route == '/workspace/activity') return const ActivityScreen();
    if (route == '/workspace/new') return const NewWorkspaceScreen();
    return const WorkspaceScreen();
  }
}

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return GoPageScaffold(
      title: 'Workspace',
      children: [
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                app.workspace,
                style: AppTextStyles.title().copyWith(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                'Demo Farm workspace for GrowOps Go',
                style: AppTextStyles.bodySmall(),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => app.go('/workspace/invite'),
                  child: const Text('Invite growers'),
                ),
              ),
              TextButton(
                onPressed: () => app.go('/workspace/activity'),
                child: const Text('Team activity'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return GoPageScaffold(
      title: 'Invite growers',
      children: [
        const TextField(decoration: InputDecoration(hintText: 'Email address')),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              AppSnackbar.showSuccess(context, 'Invite sent (demo)');
              app.go('/workspace');
            },
            child: const Text('Send invite'),
          ),
        ),
      ],
    );
  }
}

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return GoPageScaffold(
      title: 'Team activity',
      children: [
        ...app.journal.take(8).map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.title,
                        style: AppTextStyles.body(weight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(e.subtitle, style: AppTextStyles.bodySmall()),
                      const SizedBox(height: 2),
                      Text(e.when, style: AppTextStyles.bodySmall()),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }
}

class NewWorkspaceScreen extends StatelessWidget {
  const NewWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final name = TextEditingController();
    return GoPageScaffold(
      title: 'New workspace',
      children: [
        TextField(
          controller: name,
          decoration: const InputDecoration(hintText: 'Farm name'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              app.workspace = name.text.isEmpty ? app.workspace : name.text;
              app.go('/workspace');
            },
            child: const Text('Create'),
          ),
        ),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return GoPageScaffold(
      title: 'Profile',
      children: [
        GoCard(
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: GoColors.forest,
                child: Text(
                  app.growerName.isNotEmpty
                      ? app.growerName[0].toUpperCase()
                      : 'D',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                app.growerName,
                style: AppTextStyles.title().copyWith(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(app.email, style: AppTextStyles.bodySmall()),
              const SizedBox(height: 8),
              Text(
                'Role: Cultivation operator (demo)',
                style: AppTextStyles.body(),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.apartment_outlined),
                title: const Text('Workspace'),
                subtitle: Text(app.workspace),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => app.go('/workspace'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_add_alt_outlined),
                title: const Text('Invite growers'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => app.go('/workspace/invite'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history),
                title: const Text('Team activity'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => app.go('/workspace/activity'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Material(
          color: AppColors.cardOf(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: AppColors.lineOf(context)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => context.read<AuthBloc>().add(const LogoutRequested()),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 20, color: AppColors.inkOf(context)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Sign out · ${app.email}',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(
                        weight: FontWeight.w600,
                        color: AppColors.inkOf(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
