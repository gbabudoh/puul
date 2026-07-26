import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class BrowseCampaignsScreen extends StatefulWidget {
  const BrowseCampaignsScreen({super.key});

  @override
  State<BrowseCampaignsScreen> createState() => _BrowseCampaignsScreenState();
}

class _BrowseCampaignsScreenState extends State<BrowseCampaignsScreen> {
  final List<Map<String, dynamic>> _availableCampaigns = [
    {
      'id': 'c101',
      'name': 'Spring Skincare Launch',
      'advertiser': 'GlowUp Beauty',
      'category': 'Beauty',
      'cpm': 8.50,
      'description':
          'Share your skincare routine featuring our new spring collection.',
      'joined': false,
    },
    {
      'id': 'c102',
      'name': 'Home Coffee Setup',
      'advertiser': 'BrewCraft',
      'category': 'Lifestyle',
      'cpm': 6.00,
      'description':
          'Show off your home coffee brewing setup and favorite blends.',
      'joined': false,
    },
    {
      'id': 'c103',
      'name': 'City Weekend Getaways',
      'advertiser': 'WanderLust Travel',
      'category': 'Travel',
      'cpm': 9.25,
      'description':
          'Highlight quick weekend trip spots near major cities.',
      'joined': false,
    },
    {
      'id': 'c104',
      'name': 'Smart Home Gadgets',
      'advertiser': 'TechWorld Inc.',
      'category': 'Tech',
      'cpm': 7.75,
      'description': 'Feature smart home devices in your everyday content.',
      'joined': false,
    },
  ];

  final List<Map<String, dynamic>> _joinedThisSession = [];

  void _joinCampaign(Map<String, dynamic> campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Campaign'),
        content: Text(
          'Join "${campaign['name']}" by ${campaign['advertiser']}? It will appear in your Campaigns tab once joined.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final now = DateTime.now();
              final dateFormat = DateFormat('yyyy-MM-dd');
              setState(() => campaign['joined'] = true);
              _joinedThisSession.add({
                'id': campaign['id'],
                'name': campaign['name'],
                'advertiser': campaign['advertiser'],
                'status': 'active',
                'views': 0,
                'earnings': 0.0,
                'cpm': campaign['cpm'],
                'startDate': dateFormat.format(now),
                'endDate': dateFormat.format(now.add(const Duration(days: 30))),
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Joined ${campaign['name']}!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.monetizationAccent,
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Browse Campaigns'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _joinedThisSession),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _availableCampaigns.length,
        itemBuilder: (context, index) {
          final campaign = _availableCampaigns[index];
          final joined = campaign['joined'] as bool;
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          campaign['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Chip(
                        label: Text(
                          campaign['category'],
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor:
                            AppColors.monetizationAccent.withOpacity(0.15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    campaign['advertiser'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    campaign['description'],
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${campaign['cpm'].toStringAsFixed(2)} CPM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: joined ? null : () => _joinCampaign(campaign),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: joined
                              ? AppColors.cardBackground
                              : AppColors.monetizationAccent,
                          foregroundColor:
                              joined ? AppColors.textSecondary : Colors.white,
                        ),
                        child: Text(joined ? 'Joined' : 'Join Campaign'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
