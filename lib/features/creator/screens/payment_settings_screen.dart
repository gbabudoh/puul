import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class PaymentSettingsScreen extends StatefulWidget {
  const PaymentSettingsScreen({super.key});

  @override
  State<PaymentSettingsScreen> createState() => _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState extends State<PaymentSettingsScreen> {
  static const _methodKey = 'payment_payout_method';
  static const _autoPayoutKey = 'payment_auto_payout';
  static const _accountKey = 'payment_account_details';

  static const _payoutMethods = ['Bank Transfer', 'PayPal', 'Debit Card'];

  bool _loading = true;
  String _selectedMethod = 'Bank Transfer';
  bool _autoPayout = false;
  String _accountDetails = '';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMethod = prefs.getString(_methodKey) ?? 'Bank Transfer';
      _autoPayout = prefs.getBool(_autoPayoutKey) ?? false;
      _accountDetails = prefs.getString(_accountKey) ?? '';
      _loading = false;
    });
  }

  Future<void> _setMethod(String method) async {
    setState(() => _selectedMethod = method);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_methodKey, method);
  }

  Future<void> _setAutoPayout(bool value) async {
    setState(() => _autoPayout = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoPayoutKey, value);
  }

  Future<void> _setAccountDetails(String value) async {
    setState(() => _accountDetails = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accountKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Payment Settings'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildSectionHeader('Payout Method'),
                ..._payoutMethods.map(
                  (method) => RadioListTile<String>(
                    title: Text(method),
                    value: method,
                    groupValue: _selectedMethod,
                    activeColor: AppColors.monetizationAccent,
                    onChanged: (v) {
                      if (v != null) _setMethod(v);
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.badge_outlined, color: AppColors.monetizationAccent),
                  title: const Text('Payout Account'),
                  subtitle: Text(
                    _accountDetails.isEmpty ? 'Not set' : _accountDetails,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showEditAccountDialog(context),
                ),
                const Divider(height: 32),
                _buildSectionHeader('Payout Preferences'),
                SwitchListTile(
                  title: const Text('Automatic Payouts', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    'Automatically request a payout once you reach the minimum threshold',
                  ),
                  value: _autoPayout,
                  activeThumbColor: AppColors.monetizationAccent,
                  onChanged: _setAutoPayout,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Minimum payout: \$${AppConstants.minPayoutThreshold.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
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

  void _showEditAccountDialog(BuildContext context) {
    final controller = TextEditingController(text: _accountDetails);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payout Account'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: _selectedMethod == 'PayPal'
                ? 'PayPal email address'
                : _selectedMethod == 'Debit Card'
                    ? 'Card ending in ****'
                    : 'Bank account number',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _setAccountDetails(controller.text.trim());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payout account updated')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.monetizationAccent),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
