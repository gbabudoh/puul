import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CampaignAnalyticsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> campaigns;
  final int totalViews;
  final double totalEarnings;
  final int connectCount;

  const CampaignAnalyticsScreen({
    super.key,
    required this.campaigns,
    required this.totalViews,
    required this.totalEarnings,
    required this.connectCount,
  });

  double get _averageCpm {
    if (campaigns.isEmpty) return 0;
    final total = campaigns.fold<double>(0, (sum, c) => sum + (c['cpm'] as num));
    return total / campaigns.length;
  }

  List<Map<String, dynamic>> get _sortedByEarnings {
    final sorted = List<Map<String, dynamic>>.from(campaigns);
    sorted.sort((a, b) => (b['earnings'] as num).compareTo(a['earnings'] as num));
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final maxViews = campaigns.isEmpty
        ? 1
        : campaigns.map((c) => c['views'] as int).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.visibility,
                  totalViews.toString(),
                  'Total Views',
                  AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.attach_money,
                  '\$${totalEarnings.toStringAsFixed(2)}',
                  'Total Earnings',
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.trending_up,
                  '\$${_averageCpm.toStringAsFixed(2)}',
                  'Average CPM',
                  AppColors.monetizationAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.people,
                  connectCount.toString(),
                  'Connections',
                  AppColors.secondaryAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Views by Campaign',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (campaigns.isEmpty)
            Text('No campaign data yet.', style: TextStyle(color: AppColors.textSecondary))
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    for (final campaign in campaigns) ...[
                      _buildViewsBar(campaign, maxViews),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            'Top Earning Campaigns',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._sortedByEarnings.map((campaign) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.monetizationAccent.withOpacity(0.15),
                    child: Icon(Icons.campaign, color: AppColors.monetizationAccent),
                  ),
                  title: Text(
                    campaign['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${campaign['views']} views · \$${campaign['cpm'].toStringAsFixed(2)} CPM'),
                  trailing: Text(
                    '\$${campaign['earnings'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildViewsBar(Map<String, dynamic> campaign, int maxViews) {
    final views = campaign['views'] as int;
    final percentage = maxViews == 0 ? 0.0 : (views / maxViews).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                campaign['name'],
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '$views',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.info.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.info),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
