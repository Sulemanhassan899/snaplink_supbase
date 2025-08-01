import 'dart:io';
import 'package:bounce/bounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/controller/model_classs.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_compress/video_compress.dart';
import 'package:intl/intl.dart';
import 'package:snaplink/views/screens/bottomsheet/bottomsheet.dart';

class MediaService extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<MediaItem> mediaItems = <MediaItem>[].obs;
  final RxInt totalItems = 0.obs;
  final RxBool hasData = false.obs;
  final RxInt currentPage = 1.obs;
  final int itemsPerPage = 50;
  RxBool isUploading = false.obs;
  RxBool uploadCompleted = false.obs;
  Rx<Function?> cancelUploadCallback = Rx<Function?>(null);
  final Rx<MediaItem?> latestUploadedItem = Rx<MediaItem?>(null);
  RxBool isUploadingSheetOpen = false.obs;
  RxBool isUploadedSheetOpen = false.obs;

  RxInt totalUploads = 0.obs;
  RxInt uploadsInProgress = 0.obs;

  // Add a property to store uploads for the HomeScreen
  final RxList<MediaItem> uploads = <MediaItem>[].obs;

  final PagingController<int, MediaItem> pagingController = PagingController(
    firstPageKey: 1,
  );

  // --- ADD THIS: ---
  RxBool uploadedSheetShown = false.obs; // <-- To control uploaded sheet

  @override
  void onInit() {
    super.onInit();

    pagingController.addPageRequestListener((pageKey) {
      fetchUserMedia(page: pageKey);
    });
  }

  Future<void> showMediaPickerDialog() async {
    Get.dialog(
      AnimatedColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: AnimatedColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyText(
                  text: "Upload Media",
                  size: 16,
                  paddingBottom: 20,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Bounce(
                      onTap: () {
                        Get.back();
                        pickAndUploadMedia(ImageSource.camera);
                      },
                      child: CommonImageView(
                        imagePath: Assets.imagesCameraGrad,
                        height: 40,
                      ),
                    ),
                    SizedBox(width: 20),
                    Bounce(
                      onTap: () {
                        Get.back();
                        pickAndUploadMedia(ImageSource.gallery);
                      },
                      child: CommonImageView(
                        imagePath: Assets.imagesGalleryGrad,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  upload file to Supabase storage
  Future<String> uploadFileToStorage(File file, String fileType) async {
    try {
      final String userId = _supabase.auth.currentUser!.id;
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}.$fileType';
      final String filePath = 'user_media/$userId/$fileName';

      // Make sure the file exists and is readable
      if (!await file.exists()) {
        throw Exception('File does not exist');
      }

      // Read the file as bytes
      final fileBytes = await file.readAsBytes();

      // Upload the file using bytes to avoid file access issues
      await _supabase.storage
          .from('media')
          .uploadBinary(
            filePath,
            fileBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return _supabase.storage.from('media').getPublicUrl(filePath);
    } catch (e) {
      print('Storage upload error: $e');
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> pickAndUploadMedia(ImageSource source) async {
    uploadedSheetShown.value = false;
    List<MediaItem> batchUploadedItems = [];

    try {
      if (source == ImageSource.camera) {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        if (pickedFile == null) return;

        uploadsInProgress.value++;
        totalUploads.value++;

        if (uploadsInProgress.value == 1) {
          UploadBottomSheets.showUploadingBottomSheet(
            Get.context!,
            isUploading: isUploading,
            uploadCompleted: uploadCompleted,
            cancelUploadCallback: cancelUploadCallback,
          );
        }

        final MediaItem? item = await _handleSingleImage(File(pickedFile.path));
        if (item != null) {
          uploads.insert(0, item);
          if (!mediaItems.any((m) => m.url == item.url)) {
            mediaItems.insert(0, item);
          }
          batchUploadedItems.add(item);
        }

        totalItems.value = mediaItems.length;
        pagingController.refresh();
        hasData.value = mediaItems.isNotEmpty;
      } else {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
        );

        if (result == null) return;

        totalUploads.value = result.files.length;
        if (uploadsInProgress.value == 0) {
          UploadBottomSheets.showUploadingBottomSheet(
            Get.context!,
            isUploading: isUploading,
            uploadCompleted: uploadCompleted,
            cancelUploadCallback: cancelUploadCallback,
          );
        }

        uploads.clear();
        List<Future<MediaItem?>> uploadFutures = [];

        for (var file in result.files) {
          final filePath = file.path;
          if (filePath == null) continue;
          final fileExt = path.extension(filePath).toLowerCase();
          uploadsInProgress.value++;

          if (['.jpg', '.jpeg', '.png'].contains(fileExt)) {
            uploadFutures.add(_handleSingleImage(File(filePath)));
          } else if (['.mp4', '.mov'].contains(fileExt)) {
            uploadFutures.add(_handleSingleVideo(File(filePath)));
          }
        }

        // Run uploads in parallel!
        final results = await Future.wait(uploadFutures);

        for (final newItem in results) {
          if (newItem != null) {
            uploads.insert(0, newItem);
            if (!mediaItems.any((m) => m.url == newItem.url)) {
              mediaItems.insert(0, newItem);
            }
            batchUploadedItems.add(newItem);
          }
        }

        totalItems.value = mediaItems.length;
        pagingController.refresh();
        hasData.value = mediaItems.isNotEmpty;
      }
    } catch (e) {
      if (Get.isBottomSheetOpen ?? false) Get.back();
      isUploading.value = false;
      print(e);
      // Get.snackbar(
      //   'Error',
      //   'Failed to upload media: $e',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }

  Future<MediaItem?> _handleSingleImage(File imageFile) async {
    if (!isUploading.value) {
      UploadBottomSheets.showUploadingBottomSheet(
        Get.context!,
        isUploading: isUploading,
        uploadCompleted: uploadCompleted,
        cancelUploadCallback: cancelUploadCallback,
      );
    }
    isLoading.value = true;

    try {
      final File compressedFile = await compressImage(imageFile);
      final double fileSize = await getFileSizeInMB(compressedFile);
      final String fileType = path
          .extension(imageFile.path)
          .replaceAll('.', '');
      final String url = await uploadFileToStorage(compressedFile, fileType);

      final MediaItem newItem = await saveMediaMetadata(
        url,
        fileSize,
        fileType,
        'image',
      );

      latestUploadedItem.value = newItem;
      return newItem;
    } catch (e) {
      print('Error in _handleSingleImage: $e');
      if (Get.isBottomSheetOpen ?? false) Get.back();
      // Get.snackbar(
      //   'Error',
      //   'Failed to upload image: $e',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      return null;
    } finally {
      isLoading.value = false;
      uploadsInProgress.value--;

      // Only show uploaded sheet once per batch
      if (uploadsInProgress.value == 0) {
        uploadCompleted.value = true;
        if (!uploadedSheetShown.value) {
          uploadedSheetShown.value = true;
          Future.delayed(Duration(milliseconds: 200), () {
            if (Get.isBottomSheetOpen ?? false) Get.back();
            Future.delayed(Duration(milliseconds: 200), () {
              UploadedNewBottomSheet.show(
                Get.context!,
                uploads.toList(), // Pass the uploads list
                onCopyUrl: () {
                  // Optional: Add any additional logic when URL is copied
                  print("URL copied successfully");
                },
                onShare: () {
                  // Optional: Add any additional logic when shared
                  print("Content shared successfully");
                },
              );
            });
          });
        }
      }
    }
  }

  Future<MediaItem?> _handleSingleVideo(File videoFile) async {
    if (!isUploading.value) {
      UploadBottomSheets.showUploadingBottomSheet(
        Get.context!,
        isUploading: isUploading,
        uploadCompleted: uploadCompleted,
        cancelUploadCallback: cancelUploadCallback,
      );
    }
    isLoading.value = true;

    try {
      final MediaInfo? compressedInfo = await compressVideo(videoFile);
      if (compressedInfo?.file == null) return null;

      final double fileSize = await getFileSizeInMB(compressedInfo!.file!);
      final String url = await uploadFileToStorage(compressedInfo.file!, 'mp4');

      final File? thumbnailFile = await generateVideoThumbnail(videoFile);
      String? thumbUrl;
      if (thumbnailFile != null) {
        thumbUrl = await uploadFileToStorage(thumbnailFile, 'jpg');
      }

      final MediaItem newItem = await saveMediaMetadata(
        url,
        fileSize,
        'mp4',
        'video',
        thumbnailUrl: thumbUrl,
      );

      latestUploadedItem.value = newItem;
      return newItem;
    } catch (e) {
      print('Error in _handleSingleVideo: $e');
      if (Get.isBottomSheetOpen ?? false) Get.back();
      // Get.snackbar(
      //   'Error',
      //   'Failed to upload video: $e',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      return null;
    } finally {
      isLoading.value = false;
      uploadsInProgress.value--;

      // Only show uploaded sheet once per batch
      if (uploadsInProgress.value == 0) {
        uploadCompleted.value = true;
        if (!uploadedSheetShown.value) {
          uploadedSheetShown.value = true;
          Future.delayed(Duration(milliseconds: 200), () {
            if (Get.isBottomSheetOpen ?? false) Get.back();
            Future.delayed(Duration(milliseconds: 200), () {
              UploadedNewBottomSheet.show(
                Get.context!,
                uploads.toList(), // Pass the uploads list
                onCopyUrl: () {
                  // Optional: Add any additional logic when URL is copied
                  print("URL copied successfully");
                },
                onShare: () {
                  // Optional: Add any additional logic when shared
                  print("Content shared successfully");
                },
              );
            });
          });
        }
      }
    }
  }

  //fetch

  Future<void> fetchAndAddLatestUpload(String url) async {
    try {
      final response = await _supabase
          .from('media_files')
          .select()
          .eq('url', url)
          .order('created_at', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        final item = MediaItem.fromJson(response.first);

        // Prevent duplicate based on URL
        final alreadyExists = mediaItems.any((media) => media.url == item.url);
        if (alreadyExists) return;

        // Add to uploads and mediaItems lists
        uploads.insert(0, item);
        mediaItems.insert(0, item);

        // Update status and refresh
        hasData.value = true;
        totalItems.value = mediaItems.length;
        mediaItems.refresh(); // Trigger UI update
      }
    } catch (e) {
      print('Error fetching latest upload: $e');
    }
  }

  //fetchUserMedia method with proper first-page logic
  Future<void> fetchUserMedia({required int page}) async {
    try {
      if (page == 1) {
        isLoading.value = true;
      }

      final user = _supabase.auth.currentUser;
      if (user == null) {
        pagingController.value = PagingState(
          itemList: [],
          nextPageKey: null,
          error: null,
        );
        mediaItems.clear();
        uploads.clear();
        totalItems.value = 0;
        hasData.value = false;
        isLoading.value = false;
        return;
      }

      final String userId = user.id;

      // Fetch total count
      if (totalItems.value == 0 || page == 1) {
        final countResponse =
            await _supabase
                .from('media_files')
                .select()
                .eq('user_id', userId)
                .count();
        totalItems.value = countResponse.count;
      }

      final response = await _supabase
          .from('media_files')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range((page - 1) * itemsPerPage, page * itemsPerPage - 1);

      final List<MediaItem> newItems = await compute(
        _parseMediaItems,
        response as List,
      );

      // --- CHANGED: Always set mediaItems & uploads for first page
      if (page == 1) {
        mediaItems.value = newItems;
        uploads.clear();
        if (newItems.isNotEmpty) {
          // uploads.addAll(newItems);
        }
      } else {
        // Additional pages - add new items without duplicates
        for (final newItem in newItems) {
          final alreadyExists = mediaItems.any(
            (item) => item.url == newItem.url,
          );
          if (!alreadyExists) {
            mediaItems.add(newItem);
          }
        }
      }

      hasData.value = mediaItems.isNotEmpty;

      final isLastPage =
          newItems.length < itemsPerPage ||
          mediaItems.length >= totalItems.value;

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        pagingController.appendPage(newItems, page + 1);
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error fetching media: $e');
      pagingController.error = e;
    }
  }

  MediaItem? getLatestUploadedItem() {
    return latestUploadedItem.value ??
        (uploads.isNotEmpty ? uploads.first : null);
  }

  void clearLatestUploadedItem() {
    latestUploadedItem.value = null;
  }

  void refreshMediaItems() {
    mediaItems.clear();
    pagingController.refresh();
    currentPage.value = 1;
    hasData.value = false;
    totalItems.value = 0;
  }

  static List<MediaItem> _parseMediaItems(List responseData) {
    return responseData.map((item) => MediaItem.fromJson(item)).toList();
  }

  //saved media
  Future<MediaItem> saveMediaMetadata(
    String url,
    double size,
    String fileType,
    String mediaType, {
    String? thumbnailUrl,
  }) async {
    try {
      final String userId = _supabase.auth.currentUser!.id;
      final String formattedDate = DateFormat(
        'MMMM d, yyyy',
      ).format(DateTime.now());
      final DateTime now = DateTime.now();
      final String id = now.millisecondsSinceEpoch.toString();

      final Map<String, dynamic> mediaData = {
        'id': id,
        'user_id': userId,
        'url': url,
        'upload_date': formattedDate,
        'file_size': '${size.toStringAsFixed(2)} MB',
        'file_type': fileType,
        'is_video': mediaType == 'video',
        'created_at': now.toIso8601String(),
      };

      if (thumbnailUrl != null) {
        mediaData['thumbnail_url'] = thumbnailUrl;
      }

      final response =
          await _supabase.from('media_files').insert(mediaData).select();

      if (response.isNotEmpty) {
        return MediaItem.fromJson(response.first);
      } else {
        throw Exception('Failed to get inserted media item');
      }
    } catch (e) {
      print('Database insert error: $e');
      throw Exception('Failed to save media metadata: $e');
    }
  }

  //compress pphoe and video size
  Future<File> compressImage(File file) async {
    final String dir = path.dirname(file.path);
    final String fileName = path.basenameWithoutExtension(file.path);
    final String extension = path.extension(file.path);
    final String targetPath = '$dir/${fileName}_compressed$extension';

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 50,
    );

    if (result == null) {
      return file;
    }

    final resultFile = File(result.path);
    if (!await resultFile.exists() || await resultFile.length() == 0) {
      return file;
    }

    return resultFile;
  }

  Future<MediaInfo?> compressVideo(File file) async {
    try {
      return await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );
    } catch (e) {
      print('Error compressing video: $e');
      return null;
    }
  }

  //thumbnail for video

  Future<File?> generateVideoThumbnail(File videoFile) async {
    try {
      // Use VideoCompress to generate thumbnail with better quality
      final thumbnailFile = await VideoCompress.getFileThumbnail(
        videoFile.path,
        quality: 80, // Higher quality for better thumbnails
        position:
            1000, // Get thumbnail from 1 second into the video for better representation
      );

      // Verify the thumbnail was created
      if (await thumbnailFile.exists()) {
        return thumbnailFile;
      } else {
        print('Thumbnail generation failed: No file created');
        return null;
      }
    } catch (e) {
      print('Error generating video thumbnail: $e');

      // Fallback method if VideoCompress fails
      try {
        final String outputPath = '${videoFile.path}_thumb.jpg';
        final ProcessResult result = await Process.run('ffmpeg', [
          '-i', videoFile.path,
          '-ss', '00:00:01.000',
          '-vframes', '1',
          '-q:v', '2', // Higher quality
          outputPath,
        ]);

        final File thumbFile = File(outputPath);
        if (await thumbFile.exists()) {
          return thumbFile;
        } else {
          print('FFmpeg thumbnail generation failed: ${result.stderr}');
          return null;
        }
      } catch (e) {
        print('Fallback thumbnail generation failed: $e');
        return null;
      }
    }
  }

  Future<double> getFileSizeInMB(File file) async {
    final int bytes = await file.length();
    final double sizeInMB = bytes / (1024 * 1024);
    return double.parse(sizeInMB.toStringAsFixed(2));
  }

  Future<void> deleteMediaItem(MediaItem item) async {
    try {
      isLoading.value = true;

      // Delete main file from storage
      final Uri uri = Uri.parse(item.url);
      final String filePath = uri.pathSegments.sublist(2).join('/');
      await _supabase.storage.from('media').remove([filePath]);

      // Delete thumbnail if exists
      if (item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty) {
        final Uri thumbnailUri = Uri.parse(item.thumbnailUrl!);
        final String thumbnailPath = thumbnailUri.pathSegments
            .sublist(2)
            .join('/');
        await _supabase.storage.from('media').remove([thumbnailPath]);
      }

      // Delete from database
      await _supabase.from('media_files').delete().eq('id', item.id);

      // Refresh pagination controller instead of directly fetching
      pagingController.refresh();

      isLoading.value = false;
      // Get.snackbar(
      //   'Success',
      //   'Media deleted successfully',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar(
      //   'Error',
      //   'Failed to delete media: $e',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }

  Future<void> loadMoreMedia() async {
    if (isLoading.value || mediaItems.length >= totalItems.value) {
      return;
    }
    final nextPage = (mediaItems.length / itemsPerPage).ceil() + 1;
    await fetchUserMedia(page: nextPage);
  }

  void copyUrlToClipboard(String url) async {
    try {
      await Clipboard.setData(ClipboardData(text: url));

      // Get.snackbar(
      //   'Success',
      //   'URL copied to clipboard',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    } catch (e) {
      print('Error copying to clipboard: $e');
      // Get.snackbar(
      //   'Error',
      //   'Failed to copy URL: $e',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }

  Future<void> shareToOtherPlatforms(String url, {String? subject}) async {
    try {
      await Share.share(
        url,
        subject: subject ?? 'Check out this media from SnapLink',
      );
    } catch (e) {
      print('Error sharing: $e');
      // Get.snackbar(
      //   'Error',
      //   'Failed to share: $e',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }
}
