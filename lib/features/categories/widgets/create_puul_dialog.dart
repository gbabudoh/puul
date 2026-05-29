import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CreatePuulDialog extends StatefulWidget {
  const CreatePuulDialog({super.key});

  @override
  State<CreatePuulDialog> createState() => _CreatePuulDialogState();
}

class _CreatePuulDialogState extends State<CreatePuulDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedTag = 'family';
  String _visibility = 'private';
  bool _allowComments = true;
  bool _allowDownloads = false;
  bool _requireApproval = false;

  final List<Map<String, dynamic>> _categoryTags = [
    {'value': 'family', 'label': 'Family', 'icon': Icons.family_restroom},
    {'value': 'work', 'label': 'Work', 'icon': Icons.work_outline},
    {'value': 'holiday', 'label': 'Holiday', 'icon': Icons.beach_access},
    {'value': 'adventure', 'label': 'Adventure', 'icon': Icons.hiking},
    {'value': 'business', 'label': 'Business', 'icon': Icons.business},
    {'value': 'events', 'label': 'Events', 'icon': Icons.event},
    {'value': 'party', 'label': 'Party', 'icon': Icons.celebration},
    {'value': 'other', 'label': 'Other', 'icon': Icons.folder},
  ];

  final List<Map<String, dynamic>> _visibilityOptions = [
    {
      'value': 'private',
      'label': 'Private',
      'icon': Icons.lock,
      'description': 'Only invited members can see',
      'color': Colors.orange,
    },
    {
      'value': 'restricted',
      'label': 'Restricted',
      'icon': Icons.group,
      'description': 'Followers only, with approval',
      'color': Colors.blue,
    },
    {
      'value': 'public',
      'label': 'Public',
      'icon': Icons.public,
      'description': 'Anyone can view and follow',
      'color': Colors.green,
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: AppColors.secondaryAccent,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Create New PUUL',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'PUUL Name',
                    hintText: 'e.g., Summer Vacation 2024',
                    prefixIcon: const Icon(Icons.label),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categoryTags.map((tag) {
                    final isSelected = _selectedTag == tag['value'];
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tag['icon'] as IconData,
                            size: 16,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(tag['label']),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTag = tag['value'];
                        });
                      },
                      selectedColor: AppColors.primaryAccent,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                
                // Visibility Section
                Text(
                  'Sharing & Privacy',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Visibility options as cards
                ..._visibilityOptions.map((option) => _buildVisibilityCard(option)),
                
                const SizedBox(height: 16),
                
                // Additional settings
                _buildSettingsSection(),
                
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _createPuul,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Create'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisibilityCard(Map<String, dynamic> option) {
    final isSelected = _visibility == option['value'];
    final color = option['color'] as Color;
    
    return GestureDetector(
      onTap: () => setState(() => _visibility = option['value']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                option['icon'] as IconData,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['label'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    option['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: option['value'],
              groupValue: _visibility,
              onChanged: (value) => setState(() => _visibility = value!),
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Settings',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingToggle(
            'Allow Comments',
            'Members can comment on photos',
            _allowComments,
            (value) => setState(() => _allowComments = value),
          ),
          const Divider(height: 16),
          _buildSettingToggle(
            'Allow Downloads',
            'Members can download photos',
            _allowDownloads,
            (value) => setState(() => _allowDownloads = value),
          ),
          if (_visibility == 'restricted') ...[
            const Divider(height: 16),
            _buildSettingToggle(
              'Require Approval',
              'Approve new members before they join',
              _requireApproval,
              (value) => setState(() => _requireApproval = value),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryAccent,
        ),
      ],
    );
  }

  void _createPuul() {
    if (_formKey.currentState!.validate()) {
      final newPuul = {
        'name': _nameController.text,
        'tag': _selectedTag,
        'visibility': _visibility,
        'allowComments': _allowComments,
        'allowDownloads': _allowDownloads,
        'requireApproval': _requireApproval,
      };
      
      Navigator.pop(context, newPuul);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PUUL "${_nameController.text}" created!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
