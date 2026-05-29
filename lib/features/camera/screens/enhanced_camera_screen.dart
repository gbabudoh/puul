import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';

class EnhancedCameraScreen extends StatefulWidget {
  final Map<String, dynamic> category;

  const EnhancedCameraScreen({super.key, required this.category});

  @override
  State<EnhancedCameraScreen> createState() => _EnhancedCameraScreenState();
}

class _EnhancedCameraScreenState extends State<EnhancedCameraScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isLoading = true;
  bool _isCapturing = false;
  FlashMode _flashMode = FlashMode.off;
  int _selectedCameraIndex = 0;
  
  // Lens modes
  String _selectedLens = 'normal';
  final List<Map<String, dynamic>> _lensModes = [
    {'id': 'wide', 'name': 'Wide', 'icon': Icons.panorama_wide_angle, 'zoom': 0.5},
    {'id': 'normal', 'name': '1x', 'icon': Icons.circle_outlined, 'zoom': 1.0},
    {'id': 'portrait', 'name': 'Portrait', 'icon': Icons.person, 'zoom': 1.5},
    {'id': 'macro', 'name': 'Macro', 'icon': Icons.grass, 'zoom': 2.0},
  ];

  // AI Features
  bool _aiEnhanceEnabled = true;
  bool _showAiSuggestions = false;
  String? _aiSuggestedPuul;
  List<String> _detectedObjects = [];

  // Filters
  bool _showFilters = false;
  String _selectedFilter = 'none';
  final List<Map<String, dynamic>> _filters = [
    {'id': 'none', 'name': 'Original', 'color': null},
    {'id': 'vivid', 'name': 'Vivid', 'color': Colors.orange.withOpacity(0.2)},
    {'id': 'cool', 'name': 'Cool', 'color': Colors.blue.withOpacity(0.15)},
    {'id': 'warm', 'name': 'Warm', 'color': Colors.amber.withOpacity(0.2)},
    {'id': 'bw', 'name': 'B&W', 'color': Colors.grey},
    {'id': 'vintage', 'name': 'Vintage', 'color': Colors.brown.withOpacity(0.25)},
    {'id': 'dramatic', 'name': 'Dramatic', 'color': Colors.purple.withOpacity(0.15)},
  ];

  // Animation
  late AnimationController _captureAnimController;

  @override
  void initState() {
    super.initState();
    _captureAnimController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _initializeCamera();
    _simulateAiDetection();
  }

  void _simulateAiDetection() {
    // Simulate AI detecting objects and suggesting PUUL
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _detectedObjects = ['Person', 'Smile', 'Indoor'];
          _aiSuggestedPuul = widget.category['name'];
          _showAiSuggestions = true;
        });
      }
    });
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        // No camera - use gallery
        if (mounted) {
          _pickFromGallery();
        }
        return;
      }
      await _setupCamera(_selectedCameraIndex);
    } catch (e) {
      if (mounted) {
        _pickFromGallery();
      }
    }
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_cameras == null || _cameras!.isEmpty) return;

    if (_controller != null) {
      await _controller!.dispose();
    }

    final camera = _cameras![cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        _pickFromGallery();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _captureAnimController.dispose();
    super.dispose();
  }

  Future<void> _setZoomForLens(String lensId) async {
    if (_controller == null) return;
    
    final lens = _lensModes.firstWhere((l) => l['id'] == lensId);
    final zoom = lens['zoom'] as double;
    
    try {
      final minZoom = await _controller!.getMinZoomLevel();
      final maxZoom = await _controller!.getMaxZoomLevel();
      final targetZoom = (zoom).clamp(minZoom, maxZoom);
      await _controller!.setZoomLevel(targetZoom);
    } catch (e) {
      // Zoom not supported
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);
    _captureAnimController.forward().then((_) => _captureAnimController.reverse());

    try {
      final image = await _controller!.takePicture();
      if (mounted) {
        Navigator.pop(context, {
          'path': image.path,
          'filter': _selectedFilter,
          'lens': _selectedLens,
          'aiEnhanced': _aiEnhanceEnabled,
          'detectedObjects': _detectedObjects,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null && mounted) {
      Navigator.pop(context, {
        'path': image.path,
        'filter': _selectedFilter,
        'lens': 'normal',
        'aiEnhanced': _aiEnhanceEnabled,
        'detectedObjects': [],
      });
    } else if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    final modes = [FlashMode.off, FlashMode.auto, FlashMode.always, FlashMode.torch];
    final currentIndex = modes.indexOf(_flashMode);
    final nextMode = modes[(currentIndex + 1) % modes.length];

    setState(() => _flashMode = nextMode);
    await _controller!.setFlashMode(nextMode);
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    setState(() {
      _isLoading = true;
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    });

    await _setupCamera(_selectedCameraIndex);
  }

  IconData _getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.highlight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else if (_isInitialized && _controller != null)
            _buildCameraPreview(),

          // Filter overlay
          if (_selectedFilter != 'none')
            _buildFilterOverlay(),

          // Capture flash animation
          AnimatedBuilder(
            animation: _captureAnimController,
            builder: (context, child) {
              return Opacity(
                opacity: _captureAnimController.value * 0.5,
                child: Container(color: Colors.white),
              );
            },
          ),

          // Top controls
          _buildTopControls(),

          // AI Suggestions
          if (_showAiSuggestions && _aiEnhanceEnabled)
            _buildAiSuggestions(),

          // Lens selector
          _buildLensSelector(),

          // Bottom controls
          _buildBottomControls(),

          // Filters panel
          if (_showFilters)
            _buildFiltersPanel(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.previewSize!.height,
          height: _controller!.value.previewSize!.width,
          child: CameraPreview(_controller!),
        ),
      ),
    );
  }

  Widget _buildFilterOverlay() {
    final filter = _filters.firstWhere((f) => f['id'] == _selectedFilter);
    if (filter['color'] == null) return const SizedBox();
    
    if (_selectedFilter == 'bw') {
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
        child: Container(),
      );
    }
    
    return Container(
      color: filter['color'] as Color,
    );
  }

  Widget _buildTopControls() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close button
                _buildControlButton(
                  icon: Icons.close,
                  onTap: () => Navigator.pop(context),
                ),
                
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.category['icon'] as IconData,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.category['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Flash button
                _buildControlButton(
                  icon: _getFlashIcon(),
                  onTap: _toggleFlash,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // AI toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _aiEnhanceEnabled = !_aiEnhanceEnabled),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _aiEnhanceEnabled 
                          ? AppColors.secondaryAccent.withOpacity(0.8)
                          : Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'AI Enhance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: _aiEnhanceEnabled ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiSuggestions() {
    return Positioned(
      top: 140,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondaryAccent, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: AppColors.secondaryAccent, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'AI Detected',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _showAiSuggestions = false),
                  child: const Icon(Icons.close, color: Colors.white54, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: _detectedObjects.map((obj) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  obj,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLensSelector() {
    return Positioned(
      bottom: 180,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _lensModes.map((lens) {
              final isSelected = _selectedLens == lens['id'];
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedLens = lens['id']);
                  _setZoomForLens(lens['id']);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondaryAccent : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lens['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Filter toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _showFilters = !_showFilters),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _showFilters ? AppColors.secondaryAccent : Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.auto_fix_high, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            _selectedFilter == 'none' ? 'Filters' : _filters.firstWhere((f) => f['id'] == _selectedFilter)['name'],
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Main controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery
                  _buildControlButton(
                    icon: Icons.photo_library,
                    onTap: _pickFromGallery,
                    size: 28,
                  ),
                  
                  // Capture button
                  GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _isCapturing ? Colors.red : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: _isCapturing
                            ? const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  
                  // Switch camera
                  _buildControlButton(
                    icon: Icons.flip_camera_ios,
                    onTap: _cameras != null && _cameras!.length > 1 ? _switchCamera : null,
                    size: 28,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return Positioned(
      bottom: 200,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black87,
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter['id'];
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter['id']),
              child: Container(
                width: 70,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.secondaryAccent : Colors.white24,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: filter['color'] ?? Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: filter['id'] == 'none'
                          ? const Icon(Icons.block, color: Colors.white54, size: 20)
                          : null,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      filter['name'],
                      style: TextStyle(
                        color: isSelected ? AppColors.secondaryAccent : Colors.white,
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    VoidCallback? onTap,
    double size = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}
