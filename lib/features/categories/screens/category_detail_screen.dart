import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../camera/screens/enhanced_camera_screen.dart';
import '../../camera/screens/photo_preview_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final Map<String, dynamic> category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  // Demo photos for the category
  final List<Map<String, dynamic>> _demoPhotos = [];

  @override
  void initState() {
    super.initState();
    _generateDemoPhotos();
  }

  void _generateDemoPhotos() {
    // Generate 12 demo photos
    for (int i = 1; i <= 12; i++) {
      _demoPhotos.add({
        'id': 'photo_$i',
        'caption': 'Photo $i from ${widget.category['name']}',
        'timestamp': '${i}h ago',
        'likes': (i * 3) % 20,
      });
    }
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
            backgroundColor: widget.category['color'] as Color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.category['name'],
                style: const TextStyle(
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
                      widget.category['color'] as Color,
                      (widget.category['color'] as Color).withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    widget.category['icon'] as IconData,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showOptionsMenu(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 16),
                  _buildActionButtons(context),
                  const SizedBox(height: 24),
                  Text(
                    'Photos & Videos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          _demoPhotos.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No photos yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => _uploadPhoto(context),
                          icon: const Icon(Icons.add_a_photo),
                          label: const Text('Add Photos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildPhotoTile(context, _demoPhotos[index]);
                      },
                      childCount: _demoPhotos.length,
                    ),
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _uploadPhoto(context),
        backgroundColor: AppColors.secondaryAccent,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoItem(
              Icons.people,
              '${widget.category['members']}',
              'Members',
            ),
            _buildInfoItem(
              Icons.photo,
              '${_demoPhotos.length}',
              'Photos',
            ),
            _buildInfoItem(
              Icons.access_time,
              widget.category['lastUpdated'],
              'Updated',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryAccent),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _manageMembers(context),
            icon: const Icon(Icons.person_add),
            label: const Text('Members'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryAccent,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _shareCategory(context),
            icon: const Icon(Icons.share),
            label: const Text('Share'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoTile(BuildContext context, Map<String, dynamic> photo) {
    return GestureDetector(
      onTap: () => _viewPhoto(context, photo),
      child: Container(
        decoration: BoxDecoration(
          color: (widget.category['color'] as Color).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Icon(
              Icons.photo,
              size: 40,
              color: (widget.category['color'] as Color).withOpacity(0.3),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  photo['timestamp'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadPhoto(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upload Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
          ],
        ),
      ),
    );

    if (result == 'camera') {
      _openCamera(context);
    } else if (result == 'gallery') {
      _openGallery(context);
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    // Check if cameras are available
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        // No camera (simulator) - go to gallery instead
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera not available on simulator. Opening gallery...'),
              duration: Duration(seconds: 2),
            ),
          );
          _openGallery(context);
        }
        return;
      }
    } catch (e) {
      // Camera error - fallback to gallery
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera not available. Opening gallery...'),
            duration: Duration(seconds: 2),
          ),
        );
        _openGallery(context);
      }
      return;
    }

    // Use Enhanced Camera with AI features
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedCameraScreen(category: widget.category),
      ),
    );

    if (result != null && result['path'] != null && mounted) {
      _showPhotoPreview(context, result['path']);
    }
  }

  Future<void> _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      _showPhotoPreview(context, image.path);
    }
  }

  void _showPhotoPreview(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPreviewScreen(
          imagePath: imagePath,
          category: widget.category,
        ),
      ),
    );
  }

  void _viewPhoto(BuildContext context, Map<String, dynamic> photo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PhotoViewerSheet(
        photo: photo,
        category: widget.category,
        onPhotoUpdated: (updatedPhoto) {
          setState(() {
            final index = _demoPhotos.indexWhere((p) => p['id'] == updatedPhoto['id']);
            if (index != -1) {
              _demoPhotos[index] = updatedPhoto;
            }
          });
        },
      ),
    );
  }

  void _manageMembers(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Members (${widget.category['members']})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the close button
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.category['members'],
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryAccent,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Member ${index + 1}'),
                      subtitle: const Text('member@example.com'),
                      trailing: index == 0
                          ? const Chip(label: Text('Owner'))
                          : IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add member - Coming soon!')),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Add Member'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryAccent,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareCategory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share PUUL - Coming soon!')),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PUUL Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit PUUL'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit - Coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings - Coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete PUUL', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete PUUL?'),
        content: Text('Are you sure you want to delete "${widget.category['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.category['name']} deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}


// Interactive Photo Viewer with Like, Comment, Share
class _PhotoViewerSheet extends StatefulWidget {
  final Map<String, dynamic> photo;
  final Map<String, dynamic> category;
  final Function(Map<String, dynamic>) onPhotoUpdated;

  const _PhotoViewerSheet({
    required this.photo,
    required this.category,
    required this.onPhotoUpdated,
  });

  @override
  State<_PhotoViewerSheet> createState() => _PhotoViewerSheetState();
}

class _PhotoViewerSheetState extends State<_PhotoViewerSheet> {
  late bool _isLiked;
  late int _likeCount;
  final _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {'user': 'Sarah', 'text': 'Love this! 😍', 'time': '2h ago'},
    {'user': 'Mike', 'text': 'Great shot!', 'time': '3h ago'},
  ];
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.photo['isLiked'] ?? false;
    _likeCount = widget.photo['likes'] ?? 0;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    
    // Update parent
    widget.onPhotoUpdated({
      ...widget.photo,
      'isLiked': _isLiked,
      'likes': _likeCount,
    });

    // Show feedback
    if (_isLiked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.favorite, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text('You liked this photo'),
            ],
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.cardBackground,
        ),
      );
    }
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(0, {
        'user': 'You',
        'text': _commentController.text.trim(),
        'time': 'Just now',
      });
      _commentController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comment added!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _sharePhoto() {
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
              'Share Photo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareOption(Icons.message, 'Message', Colors.blue),
                _buildShareOption(Icons.copy, 'Copy Link', Colors.grey),
                _buildShareOption(Icons.download, 'Save', Colors.green),
                _buildShareOption(Icons.more_horiz, 'More', Colors.orange),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Share to PUUL',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPuulShareOption('Family', Icons.family_restroom, AppColors.primaryAccent),
                  _buildPuulShareOption('Work', Icons.work, AppColors.info),
                  _buildPuulShareOption('Friends', Icons.people, AppColors.secondaryAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label - Done!')),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPuulShareOption(String name, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Shared to $name!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    widget.photo['timestamp'],
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Photo
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    // Photo container
                    Container(
                      height: 350,
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (widget.category['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.photo,
                              size: 120,
                              color: (widget.category['color'] as Color).withOpacity(0.3),
                            ),
                          ),
                          // Double tap to like
                          Positioned.fill(
                            child: GestureDetector(
                              onDoubleTap: () {
                                if (!_isLiked) _toggleLike();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Like button
                          _ActionButton(
                            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                            label: '$_likeCount',
                            color: _isLiked ? Colors.red : AppColors.textPrimary,
                            onTap: _toggleLike,
                          ),
                          const SizedBox(width: 16),
                          // Comment button
                          _ActionButton(
                            icon: Icons.chat_bubble_outline,
                            label: '${_comments.length}',
                            color: AppColors.textPrimary,
                            onTap: () => setState(() => _showComments = !_showComments),
                          ),
                          const SizedBox(width: 16),
                          // Share button
                          _ActionButton(
                            icon: Icons.send_outlined,
                            label: 'Share',
                            color: AppColors.textPrimary,
                            onTap: _sharePhoto,
                          ),
                          const Spacer(),
                          // Bookmark
                          IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Saved to collection!')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Caption
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.photo['caption'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    // Comments section
                    if (_showComments) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comments (${_comments.length})',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Comment input
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _commentController,
                                    decoration: InputDecoration(
                                      hintText: 'Add a comment...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.send, color: AppColors.primaryAccent),
                                  onPressed: _addComment,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Comments list
                            ..._comments.map((comment) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.primaryAccent,
                                    child: Text(
                                      comment['user'][0],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment['user'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              comment['time'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(comment['text']),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
