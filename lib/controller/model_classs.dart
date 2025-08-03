

import 'package:intl/intl.dart';

class MediaItem {
  final String id;
  final String userId;
  final String url;
  final String uploadDate;
  final String fileSize;
  final String fileType;
  final bool isVideo;
  final String? thumbnailUrl;
  final DateTime uploadDateTime;

  MediaItem({
    required this.id,
    required this.userId,
    required this.url,
    required this.uploadDate,
    required this.fileSize,
    required this.fileType,
    required this.isVideo,
    this.thumbnailUrl,
    required this.uploadDateTime,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    // Parse the formatted date or use created_at timestamp
    DateTime dateTime;
    try {
      if (json['created_at'] != null) {
        dateTime = DateTime.parse(json['created_at']);
      } else {
        // Try to parse the upload_date with various formats
        final String dateStr = json['upload_date'] ?? '';
        try {
          dateTime = DateFormat('MMMM d, yyyy').parse(dateStr);
        } catch (e) {
          // Fallback to current date if parsing fails
          dateTime = DateTime.now();
        }
      }
    } catch (e) {
      dateTime = DateTime.now();
    }

    return MediaItem(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      url: json['url'] ?? '',
      uploadDate: json['upload_date'] ?? '',
      fileSize: json['file_size'] ?? '',
      fileType: json['file_type'] ?? '',
      isVideo: json['is_video'] ?? false,
      thumbnailUrl: json['thumbnail_url'],
      uploadDateTime: dateTime,
    );
  }
}
