import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({super.key});

  @override
  State<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

  // Demo users database
  final List<Map<String, dynamic>> _allUsers = [
    {'id': '1', 'name': 'Sarah Johnson', 'username': 'sarahj', 'avatar': 'S', 'followers': 1234, 'isVerified': true},
    {'id': '2', 'name': 'Mike Chen', 'username': 'mikechen', 'avatar': 'M', 'followers': 567, 'isVerified': false},
    {'id': '3', 'name': 'Emma Wilson', 'username': 'emmaw', 'avatar': 'E', 'followers': 890, 'isVerified': true},
    {'id': '4', 'name': 'James Brown', 'username': 'jamesb', 'avatar': 'J', 'followers': 2345, 'isVerified': false},
    {'id': '5', 'name': 'Lisa Park', 'username': 'lisap', 'avatar': 'L', 'followers': 432, 'isVerified': false},
    {'id': '6', 'name': 'Alex Turner', 'username': 'alext', 'avatar': 'A', 'followers': 6789, 'isVerified': true},
    {'id': '7', 'name': 'Nina Patel', 'username': 'ninap', 'avatar': 'N', 'followers': 321, 'isVerified': false},
    {'id': '8', 'name': 'David Kim', 'username': 'davidk', 'avatar': 'D', 'followers': 1567, 'isVerified': false},
    {'id': '9', 'name': 'Rachel Green', 'username': 'rachelg', 'avatar': 'R', 'followers': 4321, 'isVerified': true},
    {'id': '10', 'name': 'Tom Hardy', 'username': 'tomh', 'avatar': 'T', 'followers': 9876, 'isVerified': true},
  ];

  final Set<String> _followedUsers = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final results = _allUsers.where((user) {
          final name = user['name'].toString().toLowerCase();
          final username = user['username'].toString().toLowerCase();
          final q = query.toLowerCase();
          return name.contains(q) || username.contains(q);
        }).toList();

        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Find Friends'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or @username',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.cardBackground,
              ),
              onChanged: _performSearch,
            ),
          ),

          // Results
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_searchController.text.isEmpty) {
      return _buildSuggestions();
    }

    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.primaryAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Search Tips',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Search by name or username to find friends',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Popular users
          Text(
            'Popular on PUUL',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...(_allUsers.where((u) => u['isVerified'] == true).map(
            (user) => _buildUserCard(user),
          )),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return _buildUserCard(_searchResults[index]);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final isFollowed = _followedUsers.contains(user['id']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryAccent,
              radius: 24,
              child: Text(
                user['avatar'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (user['isVerified'] == true)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified,
                    size: 14,
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Text(
              user['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('@${user['username']}'),
            const SizedBox(height: 2),
            Text(
              '${_formatNumber(user['followers'])} followers',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _toggleFollow(user),
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowed 
                ? AppColors.cardBackground 
                : AppColors.secondaryAccent,
            foregroundColor: isFollowed 
                ? AppColors.textPrimary 
                : Colors.white,
            side: isFollowed 
                ? BorderSide(color: AppColors.divider) 
                : null,
          ),
          child: Text(isFollowed ? 'Following' : 'Follow'),
        ),
        onTap: () => _viewProfile(user),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  void _toggleFollow(Map<String, dynamic> user) {
    setState(() {
      if (_followedUsers.contains(user['id'])) {
        _followedUsers.remove(user['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unfollowed ${user['name']}')),
        );
      } else {
        _followedUsers.add(user['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Now following ${user['name']}')),
        );
      }
    });
  }

  void _viewProfile(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildProfilePreview(user),
    );
  }

  Widget _buildProfilePreview(Map<String, dynamic> user) {
    final isFollowed = _followedUsers.contains(user['id']);
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryAccent,
                radius: 50,
                child: Text(
                  user['avatar'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
              if (user['isVerified'] == true)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified,
                      size: 24,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            user['name'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '@${user['username']}',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfileStat(_formatNumber(user['followers']), 'Followers'),
              const SizedBox(width: 32),
              _buildProfileStat('24', 'PUULs'),
              const SizedBox(width: 32),
              _buildProfileStat('156', 'Photos'),
            ],
          ),
          const SizedBox(height: 24),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _toggleFollow(user);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowed 
                        ? AppColors.cardBackground 
                        : AppColors.secondaryAccent,
                    foregroundColor: isFollowed 
                        ? AppColors.textPrimary 
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(isFollowed ? 'Following' : 'Follow'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message feature coming soon!')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Message'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryAccent,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
