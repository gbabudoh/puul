import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _loading = true;

  bool _pushEnabled = true;
  bool _newConnections = true;
  bool _likesAndComments = true;
  bool _puulInvites = true;
  bool _moments = true;
  bool _emailNotifications = false;
  bool _productUpdates = false;

  static const _prefsKeys = {
    'push': 'notif_push_enabled',
    'connections': 'notif_new_connections',
    'likes': 'notif_likes_comments',
    'invites': 'notif_puul_invites',
    'moments': 'notif_moments',
    'email': 'notif_email',
    'updates': 'notif_product_updates',
  };

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushEnabled = prefs.getBool(_prefsKeys['push']!) ?? true;
      _newConnections = prefs.getBool(_prefsKeys['connections']!) ?? true;
      _likesAndComments = prefs.getBool(_prefsKeys['likes']!) ?? true;
      _puulInvites = prefs.getBool(_prefsKeys['invites']!) ?? true;
      _moments = prefs.getBool(_prefsKeys['moments']!) ?? true;
      _emailNotifications = prefs.getBool(_prefsKeys['email']!) ?? false;
      _productUpdates = prefs.getBool(_prefsKeys['updates']!) ?? false;
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
        title: const Text('Notifications'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildSectionHeader('Push Notifications'),
                _buildSwitchTile(
                  title: 'Allow Push Notifications',
                  subtitle: 'Turn off to disable all push notifications',
                  value: _pushEnabled,
                  onChanged: (v) {
                    setState(() => _pushEnabled = v);
                    _setPref(_prefsKeys['push']!, v);
                  },
                ),
                AnimatedOpacity(
                  opacity: _pushEnabled ? 1 : 0.4,
                  duration: const Duration(milliseconds: 200),
                  child: AbsorbPointer(
                    absorbing: !_pushEnabled,
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          title: 'New Connections',
                          subtitle: 'When someone follows or connects with you',
                          value: _newConnections,
                          onChanged: (v) {
                            setState(() => _newConnections = v);
                            _setPref(_prefsKeys['connections']!, v);
                          },
                        ),
                        _buildSwitchTile(
                          title: 'Likes & Comments',
                          subtitle: 'When someone interacts with your photos',
                          value: _likesAndComments,
                          onChanged: (v) {
                            setState(() => _likesAndComments = v);
                            _setPref(_prefsKeys['likes']!, v);
                          },
                        ),
                        _buildSwitchTile(
                          title: 'PUUL Invites',
                          subtitle: 'When you\'re invited to join a PUUL',
                          value: _puulInvites,
                          onChanged: (v) {
                            setState(() => _puulInvites = v);
                            _setPref(_prefsKeys['invites']!, v);
                          },
                        ),
                        _buildSwitchTile(
                          title: 'Moments',
                          subtitle: 'When a new PUUL Moment is created',
                          value: _moments,
                          onChanged: (v) {
                            setState(() => _moments = v);
                            _setPref(_prefsKeys['moments']!, v);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 32),
                _buildSectionHeader('Email'),
                _buildSwitchTile(
                  title: 'Email Notifications',
                  subtitle: 'Important account activity by email',
                  value: _emailNotifications,
                  onChanged: (v) {
                    setState(() => _emailNotifications = v);
                    _setPref(_prefsKeys['email']!, v);
                  },
                ),
                _buildSwitchTile(
                  title: 'Product Updates',
                  subtitle: 'News, tips and updates about PUUL',
                  value: _productUpdates,
                  onChanged: (v) {
                    setState(() => _productUpdates = v);
                    _setPref(_prefsKeys['updates']!, v);
                  },
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
}
