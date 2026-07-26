import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class InviteContactsScreen extends StatefulWidget {
  const InviteContactsScreen({super.key});

  @override
  State<InviteContactsScreen> createState() => _InviteContactsScreenState();
}

class _InviteContactsScreenState extends State<InviteContactsScreen> {
  final _searchController = TextEditingController();
  final Set<String> _selectedContacts = {};
  final bool _isLoading = false;

  // Demo contacts
  final List<Map<String, dynamic>> _contacts = [
    {'id': '1', 'name': 'Alice Anderson', 'phone': '+1 234 567 8901', 'onPuul': true},
    {'id': '2', 'name': 'Bob Baker', 'phone': '+1 234 567 8902', 'onPuul': false},
    {'id': '3', 'name': 'Carol Chen', 'phone': '+1 234 567 8903', 'onPuul': true},
    {'id': '4', 'name': 'David Davis', 'phone': '+1 234 567 8904', 'onPuul': false},
    {'id': '5', 'name': 'Eva Evans', 'phone': '+1 234 567 8905', 'onPuul': false},
    {'id': '6', 'name': 'Frank Foster', 'phone': '+1 234 567 8906', 'onPuul': true},
    {'id': '7', 'name': 'Grace Green', 'phone': '+1 234 567 8907', 'onPuul': false},
    {'id': '8', 'name': 'Henry Hill', 'phone': '+1 234 567 8908', 'onPuul': false},
    {'id': '9', 'name': 'Ivy Irving', 'phone': '+1 234 567 8909', 'onPuul': true},
    {'id': '10', 'name': 'Jack Johnson', 'phone': '+1 234 567 8910', 'onPuul': false},
  ];

  List<Map<String, dynamic>> get _filteredContacts {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _contacts;
    return _contacts.where((c) => 
      c['name'].toLowerCase().contains(query) ||
      c['phone'].contains(query)
    ).toList();
  }

  List<Map<String, dynamic>> get _contactsOnPuul => 
      _contacts.where((c) => c['onPuul'] == true).toList();

  List<Map<String, dynamic>> get _contactsNotOnPuul => 
      _contacts.where((c) => c['onPuul'] == false).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Invite Contacts'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        actions: [
          if (_selectedContacts.isNotEmpty)
            TextButton(
              onPressed: _sendInvites,
              child: Text(
                'Invite (${_selectedContacts.length})',
                style: TextStyle(
                  color: AppColors.secondaryAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.cardBackground,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatChip(
                  '${_contactsOnPuul.length} on PUUL',
                  AppColors.success,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  '${_contactsNotOnPuul.length} to invite',
                  AppColors.secondaryAccent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Contacts list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      // Contacts on PUUL
                      if (_contactsOnPuul.isNotEmpty) ...[
                        _buildSectionHeader('Already on PUUL'),
                        ..._contactsOnPuul.map((c) => _buildContactTile(c, isOnPuul: true)),
                      ],
                      
                      // Contacts to invite
                      if (_contactsNotOnPuul.isNotEmpty) ...[
                        _buildSectionHeader('Invite to PUUL'),
                        ..._contactsNotOnPuul.map((c) => _buildContactTile(c, isOnPuul: false)),
                      ],
                    ],
                  ),
          ),

          // Bottom action
          if (_selectedContacts.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: _sendInvites,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Send ${_selectedContacts.length} Invite${_selectedContacts.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildContactTile(Map<String, dynamic> contact, {required bool isOnPuul}) {
    final isSelected = _selectedContacts.contains(contact['id']);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOnPuul ? AppColors.success : AppColors.primaryAccent,
          child: Text(
            contact['name'][0],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          contact['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(contact['phone']),
        trailing: isOnPuul
            ? ElevatedButton(
                onPressed: () => _followContact(contact),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Follow'),
              )
            : Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedContacts.add(contact['id']);
                    } else {
                      _selectedContacts.remove(contact['id']);
                    }
                  });
                },
                activeColor: AppColors.secondaryAccent,
              ),
        onTap: isOnPuul
            ? null
            : () {
                setState(() {
                  if (isSelected) {
                    _selectedContacts.remove(contact['id']);
                  } else {
                    _selectedContacts.add(contact['id']);
                  }
                });
              },
      ),
    );
  }

  void _followContact(Map<String, dynamic> contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Following ${contact['name']}')),
    );
  }

  void _sendInvites() {
    final count = _selectedContacts.length;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Invites'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.send, size: 48, color: AppColors.secondaryAccent),
            const SizedBox(height: 16),
            Text('Send invites to $count contact${count > 1 ? 's' : ''}?'),
            const SizedBox(height: 8),
            const Text(
              'They will receive an SMS with a link to download PUUL.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
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
              setState(() => _selectedContacts.clear());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$count invite${count > 1 ? 's' : ''} sent!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryAccent,
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
