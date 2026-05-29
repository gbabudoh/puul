class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:3000/api/v1';
  static const String minioBaseUrl = 'http://localhost:9000';
  
  // App Configuration
  static const String appName = 'PUUL';
  static const int creatorThreshold = 3000;
  static const int minConnectionRequests = 3;
  
  // Category Tags
  static const List<String> categoryTags = [
    'Family',
    'Work',
    'Holiday',
    'Adventure',
    'Business',
    'Events',
    'Party',
  ];
  
  // PUUL Moments Configuration
  static const int minPhotosForMoment = 5;
  static const Duration momentTimeWindow = Duration(hours: 8);
  static const double momentSpatialRadius = 10.0; // km
  
  // Upload Configuration
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'heic'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov'];
  
  // Monetization
  static const double revenueSplitPercentage = 0.5;
  static const double minPayoutThreshold = 100.0;
}
