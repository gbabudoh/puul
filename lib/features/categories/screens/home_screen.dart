import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/screens/login_screen.dart';
import '../../connections/screens/invite_contacts_screen.dart';
import '../../connections/screens/find_friends_screen.dart';
import '../../camera/screens/enhanced_camera_screen.dart';
import '../../creator/screens/creator_dashboard_screen.dart';
import '../../settings/screens/notifications_settings_screen.dart';
import '../../settings/screens/privacy_settings_screen.dart';
import '../../settings/screens/help_support_screen.dart';
import 'category_detail_screen.dart';
import '../widgets/create_puul_dialog.dart';
import '../widgets/puul_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<int> _navigationHistory = [0];

  // Demo data
  static final List<Map<String, dynamic>> _demoCategories = [
    {
      'name': 'Family',
      'tag': 'family',
      'members': 8,
      'lastUpdated': '2h ago',
      'icon': Icons.family_restroom,
      'color': AppColors.primaryAccent,
      'visibility': 'private',
      'photoCount': 24,
    },
    {
      'name': 'Work',
      'tag': 'work',
      'members': 12,
      'lastUpdated': '5h ago',
      'icon': Icons.work_outline,
      'color': AppColors.info,
      'visibility': 'restricted',
      'photoCount': 18,
    },
    {
      'name': 'Holiday 2024',
      'tag': 'holiday',
      'members': 5,
      'lastUpdated': '1d ago',
      'icon': Icons.beach_access,
      'color': AppColors.secondaryAccent,
      'visibility': 'public',
      'photoCount': 56,
    },
    {
      'name': 'Party Friends',
      'tag': 'party',
      'members': 15,
      'lastUpdated': '3d ago',
      'icon': Icons.celebration,
      'color': AppColors.monetizationAccent,
      'visibility': 'private',
      'photoCount': 42,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goBack();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeTab(),
              _buildCameraTab(),
              _buildConnectionsTab(),
              _buildProfileTab(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  void _goBack() {
    if (_navigationHistory.length > 1) {
      _navigationHistory.removeLast();
      setState(() {
        _selectedIndex = _navigationHistory.last;
      });
    }
  }

  void _navigateTo(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        if (_navigationHistory.isEmpty || _navigationHistory.last != index) {
          _navigationHistory.add(index);
        }
      });
    }
  }

  Widget _buildConnectionsTab() {
    return Column(
      children: [
        // Custom header with back button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: AppColors.cardBackground,
          child: Row(
            children: [
              if (_navigationHistory.length > 1)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBack,
                ),
              const Expanded(
                child: Text(
                  'Connections',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => _showAddOptions(context),
              ),
            ],
          ),
        ),
        const Expanded(child: _ConnectionsContent()),
      ],
    );
  }

  Widget _buildProfileTab() {
    return Column(
      children: [
        // Custom header with back button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: AppColors.cardBackground,
          child: Row(
            children: [
              if (_navigationHistory.length > 1)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBack,
                ),
              const Expanded(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        const Expanded(child: _ProfileContent()),
      ],
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Invite from Contacts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const InviteContactsScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search by Username'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const FindFriendsScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan QR Code'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Scanner coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        // App Bar
        SliverAppBar(
          floating: true,
          backgroundColor: AppColors.primaryBackground,
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.water_drop, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'PUUL',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: PuulSearchDelegate(categories: _demoCategories),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications coming soon!')),
                );
              },
            ),
          ],
        ),

        // Quick Actions
        SliverToBoxAdapter(
          child: _buildQuickActions(),
        ),

        // Stories/Recent Activity
        SliverToBoxAdapter(
          child: _buildRecentActivity(),
        ),

        // Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My PUULs',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showCreatePuulDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondaryAccent,
                  ),
                ),
              ],
            ),
          ),
        ),

        // PUUL Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _PuulCard(category: _demoCategories[index]),
              childCount: _demoCategories.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionButton(
              icon: Icons.camera_alt,
              label: 'Camera',
              color: AppColors.secondaryAccent,
              onTap: () => _navigateTo(1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.people,
              label: 'Connections',
              color: AppColors.primaryAccent,
              onTap: () => _navigateTo(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.add_circle,
              label: 'New PUUL',
              color: AppColors.info,
              onTap: () => _showCreatePuulDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _buildActivityItem('Family', Icons.family_restroom, AppColors.primaryAccent, '+3 photos'),
              _buildActivityItem('Work', Icons.work_outline, AppColors.info, '2 new members'),
              _buildActivityItem('Holiday', Icons.beach_access, AppColors.secondaryAccent, '+12 photos'),
              _buildActivityItem('Party', Icons.celebration, AppColors.monetizationAccent, 'New comment'),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildActivityItem(String name, IconData icon, Color color, String activity) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        child: InkWell(
          onTap: () {
            final category = _demoCategories.firstWhere(
              (c) => c['name'] == name,
              orElse: () => _demoCategories.first,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetailScreen(category: category),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const Spacer(),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  activity,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraTab() {
    // Camera selection screen
    return Column(
      children: [
        // Custom header with back button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: AppColors.cardBackground,
          child: Row(
            children: [
              if (_navigationHistory.length > 1)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBack,
                ),
              const Expanded(
                child: Text(
                  'Quick Capture',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        // Big camera button
        Expanded(
          flex: 2,
          child: Center(
            child: GestureDetector(
              onTap: () => _openQuickCamera(),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryAccent.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white, size: 60),
                    SizedBox(height: 8),
                    Text(
                      'TAP TO CAPTURE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Select PUUL to add to
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text(
                'Or capture directly to a PUUL',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _demoCategories.length,
                  itemBuilder: (context, index) {
                    final category = _demoCategories[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (category['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: category['color'] as Color,
                          ),
                        ),
                        title: Text(category['name']),
                        subtitle: Text('${category['photoCount']} photos'),
                        trailing: const Icon(Icons.camera_alt),
                        onTap: () => _openCameraForPuul(category),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, 'Home'),
              _buildNavItem(1, Icons.camera_alt, 'Camera', isSpecial: true),
              _buildNavItem(2, Icons.people, 'Connect'),
              _buildNavItem(3, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool isSpecial = false}) {
    final isSelected = _selectedIndex == index;
    
    if (isSpecial) {
      return GestureDetector(
        onTap: () => _navigateTo(index),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryAccent.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _navigateTo(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePuulDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreatePuulDialog(),
    );
  }

  void _openQuickCamera() async {
    // Open camera without specific PUUL - user selects after
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedCameraScreen(
          category: {
            'name': 'Quick Capture',
            'icon': Icons.camera_alt,
            'color': AppColors.secondaryAccent,
          },
        ),
      ),
    );

    if (result != null && result['path'] != null && mounted) {
      _showPuulSelector(result['path']);
    }
  }

  void _openCameraForPuul(Map<String, dynamic> category) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedCameraScreen(category: category),
      ),
    );

    if (result != null && result['path'] != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo added to ${category['name']}!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _showPuulSelector(String imagePath) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add to PUUL',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...(_demoCategories.map((category) => ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (category['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  category['icon'] as IconData,
                  color: category['color'] as Color,
                ),
              ),
              title: Text(category['name']),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Photo added to ${category['name']}!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ))),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PuulCard extends StatelessWidget {
  final Map<String, dynamic> category;

  const _PuulCard({required this.category});

  IconData _getVisibilityIcon() {
    switch (category['visibility']) {
      case 'public':
        return Icons.public;
      case 'restricted':
        return Icons.group;
      default:
        return Icons.lock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailScreen(category: category),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      category['color'] as Color,
                      (category['color'] as Color).withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        category['icon'] as IconData,
                        size: 48,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    // Visibility badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getVisibilityIcon(),
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Photo count
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.photo, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '${category['photoCount']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.people, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${category['members']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          category['lastUpdated'],
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Connections content (extracted from ConnectionsScreen)
class _ConnectionsContent extends StatefulWidget {
  const _ConnectionsContent();

  @override
  State<_ConnectionsContent> createState() => _ConnectionsContentState();
}

class _ConnectionsContentState extends State<_ConnectionsContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _followers = [
    {'id': '1', 'name': 'Sarah Johnson', 'username': '@sarahj', 'avatar': 'S', 'isFollowing': true},
    {'id': '2', 'name': 'Mike Chen', 'username': '@mikechen', 'avatar': 'M', 'isFollowing': true},
    {'id': '3', 'name': 'Emma Wilson', 'username': '@emmaw', 'avatar': 'E', 'isFollowing': false},
    {'id': '4', 'name': 'James Brown', 'username': '@jamesb', 'avatar': 'J', 'isFollowing': true},
    {'id': '5', 'name': 'Lisa Park', 'username': '@lisap', 'avatar': 'L', 'isFollowing': false},
  ];

  final List<Map<String, dynamic>> _following = [
    {'id': '1', 'name': 'Sarah Johnson', 'username': '@sarahj', 'avatar': 'S', 'followsYou': true},
    {'id': '2', 'name': 'Mike Chen', 'username': '@mikechen', 'avatar': 'M', 'followsYou': true},
    {'id': '4', 'name': 'James Brown', 'username': '@jamesb', 'avatar': 'J', 'followsYou': true},
    {'id': '6', 'name': 'Alex Turner', 'username': '@alext', 'avatar': 'A', 'followsYou': false},
  ];

  final List<Map<String, dynamic>> _suggestions = [
    {'id': '8', 'name': 'David Kim', 'username': '@davidk', 'avatar': 'D', 'mutualFriends': 5, 'isFollowing': false},
    {'id': '9', 'name': 'Rachel Green', 'username': '@rachelg', 'avatar': 'R', 'mutualFriends': 3, 'isFollowing': false},
  ];

  void _toggleFollowFromFollowersTab(Map<String, dynamic> user) {
    final newState = !(user['isFollowing'] as bool);
    setState(() {
      user['isFollowing'] = newState;
      if (newState) {
        _addToFollowing(user, followsYou: true);
      } else {
        _following.removeWhere((u) => u['id'] == user['id']);
      }
    });
    _showFollowSnackBar(user['name'], newState);
  }

  void _unfollowUser(Map<String, dynamic> user) {
    setState(() {
      _following.removeWhere((u) => u['id'] == user['id']);
      for (final follower in _followers) {
        if (follower['id'] == user['id']) follower['isFollowing'] = false;
      }
      for (final suggestion in _suggestions) {
        if (suggestion['id'] == user['id']) suggestion['isFollowing'] = false;
      }
    });
    _showFollowSnackBar(user['name'], false);
  }

  void _toggleFollowSuggestion(Map<String, dynamic> user) {
    final newState = !(user['isFollowing'] as bool);
    setState(() {
      user['isFollowing'] = newState;
      if (newState) {
        _addToFollowing(user, followsYou: false);
      } else {
        _following.removeWhere((u) => u['id'] == user['id']);
      }
    });
    _showFollowSnackBar(user['name'], newState);
  }

  void _addToFollowing(Map<String, dynamic> user, {required bool followsYou}) {
    if (_following.any((u) => u['id'] == user['id'])) return;
    _following.add({
      'id': user['id'],
      'name': user['name'],
      'username': user['username'],
      'avatar': user['avatar'],
      'followsYou': followsYou,
    });
  }

  void _showFollowSnackBar(String name, bool isNowFollowing) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isNowFollowing ? 'You are now following $name' : 'Unfollowed $name'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryAccent,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryAccent,
          tabs: [
            Tab(text: 'Followers (${_followers.length})'),
            Tab(text: 'Following (${_following.length})'),
            const Tab(text: 'Discover'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildList(_followers, isFollowers: true),
              _buildList(_following, isFollowers: false),
              _buildDiscoverList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList(List<Map<String, dynamic>> users, {required bool isFollowers}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryAccent,
              child: Text(user['avatar'], style: const TextStyle(color: Colors.white)),
            ),
            title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(user['username']),
            trailing: ElevatedButton(
              onPressed: () => isFollowers
                  ? _toggleFollowFromFollowersTab(user)
                  : _unfollowUser(user),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFollowers
                    ? (user['isFollowing'] ? AppColors.primaryAccent : AppColors.secondaryAccent)
                    : AppColors.cardBackground,
                foregroundColor: isFollowers ? Colors.white : AppColors.textPrimary,
              ),
              child: Text(isFollowers
                  ? (user['isFollowing'] ? 'Following' : 'Follow Back')
                  : 'Following'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscoverList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Suggested for You', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ..._suggestions.map((user) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryAccent,
              child: Text(user['avatar'], style: const TextStyle(color: Colors.white)),
            ),
            title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${user['mutualFriends']} mutual friends'),
            trailing: ElevatedButton(
              onPressed: () => _toggleFollowSuggestion(user),
              style: ElevatedButton.styleFrom(
                backgroundColor: user['isFollowing'] ? AppColors.cardBackground : AppColors.secondaryAccent,
                foregroundColor: user['isFollowing'] ? AppColors.textPrimary : Colors.black,
              ),
              child: Text(user['isFollowing'] ? 'Following' : 'Follow'),
            ),
          ),
        )),
      ],
    );
  }
}

// Profile content (extracted from ProfileScreen)
class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryAccent,
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Demo User',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'demo@puul.app',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
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
          const SizedBox(height: 24),
          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('4', 'PUULs'),
                    _buildStat('42', 'Connections'),
                    _buildStat('156', 'Photos'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Menu items
          _buildMenuItem(context, Icons.star, 'Creator Dashboard', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => const CreatorDashboardScreen(),
            ));
          }),
          _buildMenuItem(context, Icons.notifications, 'Notifications', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => const NotificationsSettingsScreen(),
            ));
          }),
          _buildMenuItem(context, Icons.lock, 'Privacy', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => const PrivacySettingsScreen(),
            ));
          }),
          _buildMenuItem(context, Icons.help, 'Help & Support', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => const HelpSupportScreen(),
            ));
          }),
          const Divider(height: 32),
          _buildMenuItem(context, Icons.logout, 'Logout', () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }, isDestructive: true),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
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
        Text(label, style: TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : AppColors.primaryAccent),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : null)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
