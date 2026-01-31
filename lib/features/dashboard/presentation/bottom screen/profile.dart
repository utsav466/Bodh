import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bodh_flutter/features/dashboard/presentation/edit_profile.dart';
import 'package:bodh_flutter/features/dashboard/presentation/settings_screen.dart';
import 'package:bodh_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';
import 'package:bodh_flutter/core/api/api_endpoints.dart';

/// ✅ THIS is what we refresh after avatar update
final userSessionFutureProvider = FutureProvider<UserSession?>((ref) async {
  final service = ref.read(userSessionServiceProvider);
  return service.getUserSession();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSessionService = ref.watch(userSessionServiceProvider);
    final sessionAsync = ref.watch(userSessionFutureProvider);

    Future<void> handleLogout() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );

      try {
        await userSessionService.clearUserSession();
        if (context.mounted) Navigator.of(context).pop();

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during logout: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load profile: $e')),
        data: (session) {
          final avatarUrl = session?.avatarUrl;
          final fullName = session?.fullName ?? 'User';
          final email = session?.email ?? '';

          ImageProvider avatarProvider;

          if (avatarUrl != null && avatarUrl.isNotEmpty) {
            // ✅ If backend returns "/uploads/...."
            avatarProvider = NetworkImage('${ApiEndpoints.baseUrl}$avatarUrl');
          } else {
            avatarProvider = const AssetImage('assets/images/profile.jpg');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: avatarProvider,
                ),
                const SizedBox(height: 16),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('Edit Profile'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );

                    // ✅ Refresh session so avatar/name updates instantly
                    ref.invalidate(userSessionFutureProvider);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blue),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout'),
                  onTap: handleLogout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
