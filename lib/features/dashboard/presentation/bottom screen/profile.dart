import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bodh_flutter/features/dashboard/presentation/edit_profile.dart';
import 'package:bodh_flutter/features/dashboard/presentation/settings_screen.dart';
import 'package:bodh_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';
import 'package:bodh_flutter/core/api/api_endpoints.dart';

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
          final media = MediaQuery.of(context);
          final screenWidth = media.size.width;
          final isTablet = screenWidth >= 700;
          final maxContentWidth = isTablet ? 700.0 : 520.0;
          final horizontalPadding = isTablet ? 24.0 : 16.0;

          final avatarUrl = session?.avatarUrl;
          final fullName = session?.fullName ?? 'User';
          final email = session?.email ?? '';

          ImageProvider avatarProvider;
          if (avatarUrl != null && avatarUrl.isNotEmpty) {
            avatarProvider = NetworkImage('${ApiEndpoints.baseUrl}$avatarUrl');
          } else {
            avatarProvider = const AssetImage('assets/images/profile.jpg');
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 16,
                        vertical: isTablet ? 28 : 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: isTablet ? 58 : 50,
                            backgroundImage: avatarProvider,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            fullName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            email,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
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
                              ref.invalidate(userSessionFutureProvider);
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading:
                                const Icon(Icons.settings, color: Colors.blue),
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
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: const Text('Logout'),
                            onTap: handleLogout,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}