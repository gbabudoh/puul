import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'invite_contacts_screen.dart';
import 'find_friends_screen.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Demo data
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
    {'id': '7', 'name': 'Nina Patel', 'username': '@ninap', 'avatar': 'N', 'followsYou': false},
  ];

  final List<Map<String, dynamic>> _suggestions = [
    {'id': '8', 'name': 'David Kim', 'username': '@davidk', 'avatar': 'D', 'mutualFriends': 5},
    {'id': '9', 'name': 'Rachel Green', 'username': '@rachelg', 'avatar': 'R', 'mutualFriends': 3},
    {'id': '10', 'name': 'Tom Hardy', 'username': '@tomh', 'avatar': 'T', 'mutualFriends': 8},
    {'id': '11', 'name': 'Sophie Lee', 'username': '@sophiel', 'avatar': 'S', 'mutualFriends': 2},
  ];

  final List<Map<String, dynamic>> _pendingRequests = [
    {'id': '12', 'name': 'Chris Evans', 'username': '@chrise', 'avatar': 'C', 'time': '2h ago'},
    {'id': '13', 'name': 'Amy Adams', 'username': '@amya', 'avatar': 'A', 'time': '1d ago'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      appBar: AppBar(
        title: const Text('Connections'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () => _showQRCode(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryAccent,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryAccent,
          tabs: [
            Tab(text: 'Followers (${_followers.length})'),
            Tab(text: 'Following (${_following.length})'),
            Tab(text: 'Requests (${_pendingRequests.length})'),
            const Tab(text: 'Discover'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFollowersList(),
          _buildFollowingList(),
          _buildRequestsList(),
          _buildDiscoverList(),
        ],
      ),
    );
  }

  Widget _buildFollowersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _followers.length,
      itemBuilder: (context, index) {
        final user = _followers[index];
        return _buildUserTile(
          user: user,
          trailing: ElevatedButton(
            onPressed: () => _toggleFollow(user),
            style: ElevatedButton.styleFrom(
              backgroundColor: user['isFollowing'] 
                  ? AppColors.primaryAccent 
                  : AppColors.secondaryAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(user['isFollowing'] ? 'Following' : 'Follow Back'),
          ),
        );
      },
    );
  }

  Widget _buildFollowingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _following.length,
      itemBuilder: (context, index) {
        final user = _following[index];
        return _buildUserTile(
          user: user,
          subtitle: user['followsYou'] ? 'Follows you' : null,
          trailing: OutlinedButton(
            onPressed: () => _confirmUnfollow(user),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryAccent,
            ),
            child: const Text('Following'),
          ),
        );
      },
    );
  }

  Widget _buildRequestsList() {
    if (_pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_disabled, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No pending requests',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingRequests.length,
      itemBuilder: (context, index) {
        final user = _pendingRequests[index];
        return _buildUserTile(
          user: user,
          subtitle: 'Requested ${user['time']}',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () => _acceptRequest(user),
              ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => _declineRequest(user),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiscoverList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick actions
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.contacts,
                  label: 'Invite Contacts',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InviteContactsScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.search,
                  label: 'Find Friends',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FindFriendsScreen()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Suggestions
          Text(
            'Suggested for You',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...(_suggestions.map((user) => _buildUserTile(
            user: user,
            subtitle: '${user['mutualFriends']} mutual friends',
            trailing: ElevatedButton(
              onPressed: () => _followUser(user),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Follow'),
            ),
          ))),
        ],
      ),
    );
  }

  Widget _buildUserTile({
    required Map<String, dynamic> user,
    String? subtitle,
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryAccent,
          child: Text(
            user['avatar'],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle ?? user['username']),
        trailing: trailing,
        onTap: () => _viewProfile(user),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primaryAccent),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
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
                  const SnackBar(content: Text('QR Scanner - Coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Profile Link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile link copied!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQRCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Center(
                child: Icon(
                  Icons.qr_code_2,
                  size: 150,
                  color: AppColors.primaryAccent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '@demouser',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan to follow me on PUUL',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Code saved!')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _toggleFollow(Map<String, dynamic> user) {
    setState(() {
      user['isFollowing'] = !user['isFollowing'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(user['isFollowing'] 
            ? 'Now following ${user['name']}' 
            : 'Unfollowed ${user['name']}'),
      ),
    );
  }

  void _confirmUnfollow(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unfollow?'),
        content: Text('Are you sure you want to unfollow ${user['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _following.remove(user);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Unfollowed ${user['name']}')),
              );
            },
            child: const Text('Unfollow', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _acceptRequest(Map<String, dynamic> user) {
    setState(() {
      _pendingRequests.remove(user);
      _followers.add({...user, 'isFollowing': false});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user['name']} is now following you!')),
    );
  }

  void _declineRequest(Map<String, dynamic> user) {
    setState(() {
      _pendingRequests.remove(user);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Declined request from ${user['name']}')),
    );
  }

  void _followUser(Map<String, dynamic> user) {
    setState(() {
      _suggestions.remove(user);
      _following.add({...user, 'followsYou': false});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Now following ${user['name']}')),
    );
  }

  void _viewProfile(Map<String, dynamic> user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing ${user['name']}\'s profile')),
    );
  }
}
