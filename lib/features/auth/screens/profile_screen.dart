import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'login_screen.dart';
import '../../creator/screens/creator_dashboard_screen.dart';
import '../../connections/screens/connections_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildStatsCard(),
            const SizedBox(height: 16),
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryAccent,
          child: const Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Demo User',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'demo@puul.app',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit),
          label: const Text('Edit Profile'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('4', 'PUULs'),
              _buildStatItem('42', 'Connections'),
              _buildStatItem('156', 'Photos'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryAccent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          Icons.person_add,
          'Connections',
          'Manage your connections',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConnectionsScreen(),
              ),
            );
          },
        ),
        _buildMenuItem(
          context,
          Icons.notifications,
          'Notifications',
          'Manage notification settings',
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications - Coming soon!')),
            );
          },
        ),
        _buildMenuItem(
          context,
          Icons.lock,
          'Privacy',
          'Privacy and security settings',
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Privacy - Coming soon!')),
            );
          },
        ),
        _buildMenuItem(
          context,
          Icons.star,
          'Creator Dashboard',
          'View your creator stats',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatorDashboardScreen(),
              ),
            );
          },
          badge: 'NEW',
        ),
        _buildMenuItem(
          context,
          Icons.help,
          'Help & Support',
          'Get help and contact support',
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help - Coming soon!')),
            );
          },
        ),
        _buildMenuItem(
          context,
          Icons.info,
          'About',
          'App version and information',
          () {
            _showAboutDialog(context);
          },
        ),
        const Divider(height: 32),
        _buildMenuItem(
          context,
          Icons.logout,
          'Logout',
          'Sign out of your account',
          () {
            _confirmLogout(context);
          },
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    String? badge,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.primaryAccent,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: badge != null
          ? Chip(
              label: Text(
                badge,
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: AppColors.secondaryAccent,
              padding: EdgeInsets.zero,
            )
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About PUUL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PUUL - Contextual Photo Sharing',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0'),
            const SizedBox(height: 16),
            Text(
              'Stop Oversharing. Start PUULing.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
