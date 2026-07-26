import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _loading = true;

  bool _privateAccount = false;
  bool _showLocation = true;
  bool _showActivityStatus = true;
  bool _allowTagging = true;
  bool _showInSuggestions = true;

  static const _prefsKeys = {
    'private': 'privacy_private_account',
    'location': 'privacy_show_location',
    'activity': 'privacy_show_activity',
    'tagging': 'privacy_allow_tagging',
    'suggestions': 'privacy_show_in_suggestions',
  };

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _privateAccount = prefs.getBool(_prefsKeys['private']!) ?? false;
      _showLocation = prefs.getBool(_prefsKeys['location']!) ?? true;
      _showActivityStatus = prefs.getBool(_prefsKeys['activity']!) ?? true;
      _allowTagging = prefs.getBool(_prefsKeys['tagging']!) ?? true;
      _showInSuggestions = prefs.getBool(_prefsKeys['suggestions']!) ?? true;
      _loading = false;
    });
  }

  Future<void> _setPref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Privacy'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildSectionHeader('Account Privacy'),
                _buildSwitchTile(
                  title: 'Private Account',
                  subtitle:
                      'Only approved connections can see your PUULs and photos',
                  value: _privateAccount,
                  onChanged: (v) {
                    setState(() => _privateAccount = v);
                    _setPref(_prefsKeys['private']!, v);
                  },
                ),
                _buildSwitchTile(
                  title: 'Show Activity Status',
                  subtitle: 'Let connections see when you\'re active',
                  value: _showActivityStatus,
                  onChanged: (v) {
                    setState(() => _showActivityStatus = v);
                    _setPref(_prefsKeys['activity']!, v);
                  },
                ),
                _buildSwitchTile(
                  title: 'Show in Suggestions',
                  subtitle: 'Allow your profile to appear in "People You May Know"',
                  value: _showInSuggestions,
                  onChanged: (v) {
                    setState(() => _showInSuggestions = v);
                    _setPref(_prefsKeys['suggestions']!, v);
                  },
                ),
                const Divider(height: 32),
                _buildSectionHeader('Photos & Location'),
                _buildSwitchTile(
                  title: 'Share Location on Photos',
                  subtitle:
                      'Attach location data used for PUUL Moments grouping',
                  value: _showLocation,
                  onChanged: (v) {
                    setState(() => _showLocation = v);
                    _setPref(_prefsKeys['location']!, v);
                  },
                ),
                _buildSwitchTile(
                  title: 'Allow Tagging',
                  subtitle: 'Let others tag you in shared photos',
                  value: _allowTagging,
                  onChanged: (v) {
                    setState(() => _allowTagging = v);
                    _setPref(_prefsKeys['tagging']!, v);
                  },
                ),
                const Divider(height: 32),
                _buildSectionHeader('Manage'),
                _buildNavTile(
                  icon: Icons.block,
                  title: 'Blocked Accounts',
                  subtitle: 'Manage accounts you\'ve blocked',
                  onTap: () => _showBlockedAccounts(context),
                ),
                _buildNavTile(
                  icon: Icons.download_outlined,
                  title: 'Download Your Data',
                  subtitle: 'Request a copy of your PUUL data',
                  onTap: () => _showComingSoon(context, 'Data download'),
                ),
                _buildNavTile(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account and data',
                  isDestructive: true,
                  onTap: () => _confirmDeleteAccount(context),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      value: value,
      activeThumbColor: AppColors.primaryAccent,
      onChanged: onChanged,
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primaryAccent,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature - Coming soon!')),
    );
  }

  void _showBlockedAccounts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.block, size: 40, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              const Text(
                'No Blocked Accounts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Accounts you block will appear here.',
                style: TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account, PUULs, and photos. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon(context, 'Account deletion');
            },
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
