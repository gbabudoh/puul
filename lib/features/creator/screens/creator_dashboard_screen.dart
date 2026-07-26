import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'browse_campaigns_screen.dart';
import 'campaign_analytics_screen.dart';
import 'payment_settings_screen.dart';

class CreatorDashboardScreen extends StatefulWidget {
  const CreatorDashboardScreen({super.key});

  @override
  State<CreatorDashboardScreen> createState() => _CreatorDashboardScreenState();
}

class _CreatorDashboardScreenState extends State<CreatorDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Demo data
  final int _connectCount = 3245;
  final double _totalEarnings = 1847.50;
  final double _pendingPayout = 847.50;
  final int _activeCampaigns = 3;
  final int _totalViews = 12847;

  final List<Map<String, dynamic>> _campaigns = [
    {
      'id': '1',
      'name': 'Summer Fashion Collection',
      'advertiser': 'FashionBrand Co.',
      'status': 'active',
      'views': 4523,
      'earnings': 452.30,
      'cpm': 10.00,
      'startDate': '2024-01-15',
      'endDate': '2024-02-15',
    },
    {
      'id': '2',
      'name': 'Tech Gadgets Promo',
      'advertiser': 'TechWorld Inc.',
      'status': 'active',
      'views': 5234,
      'earnings': 261.70,
      'cpm': 5.00,
      'startDate': '2024-01-20',
      'endDate': '2024-02-20',
    },
    {
      'id': '3',
      'name': 'Travel Destinations',
      'advertiser': 'WanderLust Travel',
      'status': 'active',
      'views': 3090,
      'earnings': 133.50,
      'cpm': 4.32,
      'startDate': '2024-01-25',
      'endDate': '2024-02-25',
    },
    {
      'id': '4',
      'name': 'Fitness Challenge',
      'advertiser': 'FitLife Gym',
      'status': 'completed',
      'views': 8920,
      'earnings': 892.00,
      'cpm': 10.00,
      'startDate': '2023-12-01',
      'endDate': '2024-01-01',
    },
  ];

  final List<Map<String, dynamic>> _payoutHistory = [
    {
      'id': '1',
      'amount': 1000.00,
      'date': '2024-01-01',
      'status': 'completed',
      'method': 'Bank Transfer',
    },
    {
      'id': '2',
      'amount': 750.00,
      'date': '2023-12-01',
      'status': 'completed',
      'method': 'Bank Transfer',
    },
    {
      'id': '3',
      'amount': 500.00,
      'date': '2023-11-01',
      'status': 'completed',
      'method': 'Bank Transfer',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.monetizationAccent,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Creator Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.monetizationAccent,
                      AppColors.monetizationAccent.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.star,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildStatsOverview(),
                const SizedBox(height: 16),
                _buildTabBar(),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildCampaignsTab(),
                _buildPayoutsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.verified,
                color: AppColors.monetizationAccent,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'Creator Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.people,
                  _connectCount.toString(),
                  'Connections',
                  AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.visibility,
                  _totalViews.toString(),
                  'Total Views',
                  AppColors.secondaryAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.attach_money,
                  '\$${_totalEarnings.toStringAsFixed(2)}',
                  'Total Earnings',
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.campaign,
                  _activeCampaigns.toString(),
                  'Active Campaigns',
                  AppColors.monetizationAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        splashBorderRadius: BorderRadius.circular(10),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorAnimation: TabIndicatorAnimation.elastic,
        indicatorPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          color: AppColors.monetizationAccent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.monetizationAccent.withOpacity(0.35),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(height: 42, text: 'Overview'),
          Tab(height: 42, text: 'Campaigns'),
          Tab(height: 42, text: 'Payouts'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEarningsCard(),
          const SizedBox(height: 16),
          _buildPerformanceChart(),
          const SizedBox(height: 16),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Earnings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Chip(
                  label: const Text('This Month'),
                  backgroundColor: AppColors.secondaryAccent.withOpacity(0.2),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_pendingPayout.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _pendingPayout >= 100 ? _requestPayout : null,
                  icon: const Icon(Icons.payment),
                  label: const Text('Request Payout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.monetizationAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Minimum payout: \$100.00',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildPerformanceBar('Views', _totalViews, 15000, AppColors.info),
            const SizedBox(height: 12),
            _buildPerformanceBar(
              'Earnings',
              _totalEarnings.toInt(),
              2500,
              AppColors.success,
            ),
            const SizedBox(height: 12),
            _buildPerformanceBar(
              'Campaigns',
              _activeCampaigns,
              5,
              AppColors.monetizationAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceBar(String label, int value, int max, Color color) {
    final percentage = (value / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '$value / $max',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              Icons.campaign,
              'Browse Campaigns',
              'Find new campaigns to join',
              _browseCampaigns,
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              Icons.analytics,
              'View Analytics',
              'Detailed performance insights',
              _viewAnalytics,
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              Icons.settings,
              'Payment Settings',
              'Manage payout methods',
              _openPaymentSettings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.monetizationAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.monetizationAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _campaigns.length,
      itemBuilder: (context, index) {
        return _buildCampaignCard(_campaigns[index]);
      },
    );
  }

  Widget _buildCampaignCard(Map<String, dynamic> campaign) {
    final isActive = campaign['status'] == 'active';
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _viewCampaignDetails(campaign),
        borderRadius: BorderRadius.circular(12),
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
                      isActive ? 'Active' : 'Completed',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: isActive
                        ? AppColors.success.withOpacity(0.2)
                        : AppColors.textSecondary.withOpacity(0.2),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                campaign['advertiser'],
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildCampaignStat(
                      Icons.visibility,
                      '${campaign['views']} views',
                    ),
                  ),
                  Expanded(
                    child: _buildCampaignStat(
                      Icons.attach_money,
                      '\$${campaign['earnings'].toStringAsFixed(2)}',
                    ),
                  ),
                  Expanded(
                    child: _buildCampaignStat(
                      Icons.trending_up,
                      '\$${campaign['cpm'].toStringAsFixed(2)} CPM',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignStat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPayoutsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _payoutHistory.length,
      itemBuilder: (context, index) {
        return _buildPayoutCard(_payoutHistory[index]);
      },
    );
  }

  Widget _buildPayoutCard(Map<String, dynamic> payout) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${payout['amount'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    payout['method'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  payout['date'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payout['status'].toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _requestPayout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Payout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available balance: \$${_pendingPayout.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Your payout will be processed within 3-5 business days.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payout request submitted!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.monetizationAccent,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _viewCampaignDetails(Map<String, dynamic> campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      campaign['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Advertiser', campaign['advertiser']),
              _buildDetailRow('Status', campaign['status']),
              _buildDetailRow('Views', campaign['views'].toString()),
              _buildDetailRow('Earnings', '\$${campaign['earnings'].toStringAsFixed(2)}'),
              _buildDetailRow('CPM', '\$${campaign['cpm'].toStringAsFixed(2)}'),
              _buildDetailRow('Start Date', campaign['startDate']),
              _buildDetailRow('End Date', campaign['endDate']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _browseCampaigns() async {
    final joined = await Navigator.push<List<Map<String, dynamic>>>(
      context,
      MaterialPageRoute(builder: (_) => const BrowseCampaignsScreen()),
    );
    if (joined != null && joined.isNotEmpty) {
      setState(() {
        _campaigns.insertAll(0, joined);
      });
    }
  }

  void _viewAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CampaignAnalyticsScreen(
          campaigns: _campaigns,
          totalViews: _totalViews,
          totalEarnings: _totalEarnings,
          connectCount: _connectCount,
        ),
      ),
    );
  }

  void _openPaymentSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PaymentSettingsScreen()),
    );
  }
}
