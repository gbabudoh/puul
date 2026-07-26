import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _supportEmail = 'support@puul.app';

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'What is a PUUL?',
      'answer':
          'A PUUL is a shared album that groups photos by a specific context, like an event, trip, or moment, so you only share what\'s relevant with the people who were there.',
    },
    {
      'question': 'How do PUUL Moments work?',
      'answer':
          'PUUL Moments automatically group photos taken by connected users who were at the same place around the same time, so you can rediscover shared experiences.',
    },
    {
      'question': 'Who can see my photos?',
      'answer':
          'Only people you\'ve added to a PUUL, or your connections if your account is public, can see the photos you share. You can manage this under Profile > Privacy.',
    },
    {
      'question': 'How do I become a Creator?',
      'answer':
          'Once your content reaches enough views and engagement, you unlock the Creator Dashboard where you can track stats and monetization.',
    },
    {
      'question': 'How do I delete a photo or PUUL?',
      'answer':
          'Open the photo or PUUL, tap the menu icon, and select delete. Deleted content is removed for everyone in the PUUL.',
    },
    {
      'question': 'How do I report inappropriate content?',
      'answer':
          'Tap the menu icon on any photo or profile and select "Report". Our team reviews all reports within 24 hours.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildContactCard(context),
          _buildSectionHeader('Frequently Asked Questions'),
          ..._faqs.map((faq) => _buildFaqTile(faq['question']!, faq['answer']!)),
          const Divider(height: 32),
          _buildSectionHeader('More'),
          _buildNavTile(
            icon: Icons.flag_outlined,
            title: 'Report a Problem',
            subtitle: 'Let us know about a bug or issue',
            onTap: () => _showReportDialog(context),
          ),
          _buildNavTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms and conditions',
            onTap: () => _showTextDialog(
              context,
              'Terms of Service',
              'By using PUUL, you agree to share content responsibly and respect the privacy of others. Full terms are available on our website.',
            ),
          ),
          _buildNavTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Learn how we handle your data',
            onTap: () => _showTextDialog(
              context,
              'Privacy Policy',
              'PUUL only shares your photos with the people you choose. We never sell your personal data. Full policy is available on our website.',
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: AppColors.primaryAccent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.support_agent, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need more help?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Contact us at $_supportEmail',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white),
                tooltip: 'Copy email',
                onPressed: () => _copyEmail(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _supportEmail));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Support email copied to clipboard')),
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

  Widget _buildFaqTile(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Card(
        margin: EdgeInsets.zero,
        child: Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              question,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            iconColor: AppColors.primaryAccent,
            collapsedIconColor: AppColors.textSecondary,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    answer,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showTextDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Problem'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Describe the issue you\'re experiencing...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thanks! Your report has been submitted.'),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
