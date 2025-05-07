import 'dart:io';
import 'package:bounce/bounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/controller/model_classs.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/double_white_contianers.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_compress/video_compress.dart';
import 'package:intl/intl.dart';

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

  RxInt totalUploads = 0.obs;
  RxInt uploadsInProgress = 0.obs;

  // Add a property to store uploads for the HomeScreen
  final RxList<MediaItem> uploads = <MediaItem>[].obs;

  final PagingController<int, MediaItem> pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void onInit() {
    super.onInit();

    pagingController.addPageRequestListener((pageKey) {
      fetchUserMedia(page: pageKey);
    });

  }

  // UI for bottomsheet and dialog
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
                  spacing: 20,
                  children: [
                    Bounce(
                      onTap: () {
                        Get.back();
                        pickAndUploadMedia(
                          ImageSource.camera,
                        ); // Fixed source here
                      },
                      child: CommonImageView(
                        imagePath: Assets.imagesCameraGrad,
                        height: 40,
                      ),
                    ),
                    Bounce(
                      onTap: () {
                        Get.back();
                        pickAndUploadMedia(
                          ImageSource.gallery,
                        ); // Fixed source here
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

  void showUploadingBottomSheet(BuildContext context) {
    isUploading.value = true;
    uploadCompleted.value = false;

    Get.bottomSheet(
      isDismissible: true,
      SizedBox(
        height: Get.height,
        child: DoubleWhiteContainers2(
          child: AnimatedColumn(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Bounce(
                    onTap: () {
                      if (Get.isBottomSheetOpen ?? false) {
                        Get.back(); // Close sheet
                      }
                      cancelUploadCallback.value
                          ?.call(); // Cancel actual upload
                      isUploading.value = false;
                      Get.snackbar(
                        'Cancelled',
                        'Upload is canceled',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: CommonImageView(
                      imagePath: Assets.imagesCancel,
                      height: 24,
                    ),
                  ),
                  Gap(20),
                ],
              ),
              Obx(() {
                return uploadCompleted.value
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(Assets.animationsConfetti, height: 100),
                        MyText(
                          text: "Upload Completed!",
                          size: 16,
                          weight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(Assets.animationsUploading, height: 100),
                        MyText(
                          text: "Uploading...",
                          size: 16,
                          weight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
              }),
              Gap(30),
            ],
          ),
        ),
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

  //uploding
  Future<void> pickAndUploadMedia(ImageSource source) async {
    try {
      // If source is camera, keep using image_picker
      if (source == ImageSource.camera) {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        if (pickedFile == null) return;

        // Increment the number of uploads in progress
        uploadsInProgress.value++;
        totalUploads.value++;

        // Show bottom sheet once at the beginning
        if (uploadsInProgress.value == 1) {
          showUploadingBottomSheet(Get.context!);
        }

        // Compress and upload
        await _handleSingleImage(File(pickedFile.path));
        return;
      }

      // For gallery: use file_picker to allow multiple and mixed media
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
      );

      if (result == null) return;

      // Increment total number of uploads
      totalUploads.value = result.files.length;

      // Show bottom sheet once at the beginning
      if (uploadsInProgress.value == 0) {
        showUploadingBottomSheet(Get.context!);
      }

      for (var file in result.files) {
        final filePath = file.path;
        if (filePath == null) continue;

        final fileExt = path.extension(filePath).toLowerCase();

        // Increment in-progress counter
        uploadsInProgress.value++;

        if (['.jpg', '.jpeg', '.png'].contains(fileExt)) {
          await _handleSingleImage(File(filePath));
        } else if (['.mp4', '.mov'].contains(fileExt)) {
          await _handleSingleVideo(File(filePath));
        }
      }
    } catch (e) {
      if (Get.isBottomSheetOpen ?? false) Get.back();
      isUploading.value = false;
      print(e);
      Get.snackbar(
        'Error',
        'Failed to upload media: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _handleSingleImage(File imageFile) async {
    // Don't call this method again if it's already uploading
    if (!isUploading.value) {
      showUploadingBottomSheet(
        Get.context!,
      ); // Open the bottom sheet when starting upload
    }
    isLoading.value = true;

    final File compressedFile = await compressImage(imageFile);
    final double fileSize = await getFileSizeInMB(compressedFile);
    final String fileType = path.extension(imageFile.path).replaceAll('.', '');
    final String url = await uploadFileToStorage(compressedFile, fileType);

    await saveMediaMetadata(url, fileSize, fileType, 'image');

    // Refresh pagination controller instead of directly fetching
    pagingController.refresh();

    // Decrement the in-progress counter and check if all uploads are done
    uploadsInProgress.value--;

    if (uploadsInProgress.value == 0) {
      // All uploads completed, close the bottom sheet
      uploadCompleted.value = true;
      Future.delayed(Duration(seconds: 2), () {
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
      });
    }
  }

  Future<void> _handleSingleVideo(File videoFile) async {
    showUploadingBottomSheet(Get.context!);
    isLoading.value = true;

    final MediaInfo? compressedInfo = await compressVideo(videoFile);
    if (compressedInfo?.file == null) return;

    final double fileSize = await getFileSizeInMB(compressedInfo!.file!);
    final String url = await uploadFileToStorage(compressedInfo.file!, 'mp4');

    final File? thumbnailFile = await generateVideoThumbnail(videoFile);
    String? thumbUrl;
    if (thumbnailFile != null) {
      thumbUrl = await uploadFileToStorage(thumbnailFile, 'jpg');
    }

    await saveMediaMetadata(
      url,
      fileSize,
      'mp4',
      'video',
      thumbnailUrl: thumbUrl,
    );

    // Refresh pagination controller instead of directly fetching
    pagingController.refresh();

    // Decrement the in-progress counter and check if all uploads are done
    uploadsInProgress.value--;

    if (uploadsInProgress.value == 0) {
      // All uploads completed, close the bottom sheet
      uploadCompleted.value = true;
      Future.delayed(Duration(seconds: 2), () {
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
      });
    }
  }

  //fetch

  Future<void> fetchUserMedia2() async {
    try {
      isLoading.value = true;

      final user = _supabase.auth.currentUser;
      if (user == null) {
        mediaItems.clear();
        totalItems.value = 0;
        hasData.value = false;
        isLoading.value = false;
        return;
      }

      final String userId = user.id;

      // Get total count from media_files table
      final countResponse =
          await _supabase
              .from('media_files')
              .select()
              .eq('user_id', userId)
              .count();

      totalItems.value = countResponse.count;

      // Fetch all media data without using pagination
      final response = await _supabase
          .from('media_files')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<MediaItem> items =
          (response as List).map((item) => MediaItem.fromJson(item)).toList();

      mediaItems.value = items;
      uploads.value = items; // Update uploads list for HomeScreen
      hasData.value = items.isNotEmpty;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error fetching media: $e');

      // Clear data on error
      mediaItems.clear();
      totalItems.value = 0;
      hasData.value = false;
    }
  }

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
        totalItems.value = 0;
        hasData.value = false;
        isLoading.value = false;
        return;
      }

      final String userId = user.id;

      // Fetch total count once if needed
      if (totalItems.value == 0 || page == 1) {
        final countResponse =
            await _supabase
                .from('media_files')
                .select()
                .eq('user_id', userId)
                .count();
        totalItems.value = countResponse.count;
      }

      // Use compute for JSON parsing to move it off the main thread
      final response = await _supabase
          .from('media_files')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range((page - 1) * itemsPerPage, page * itemsPerPage - 1);

      // Use isolate to process data off the main thread
      final List<MediaItem> newItems = await compute(
        _parseMediaItems,
        response as List,
      );

      // Update the mediaItems list efficiently
      if (page == 1) {
        mediaItems.value = newItems;
      } else {
        // Add new items to existing list
        final List<MediaItem> updatedItems = [...mediaItems, ...newItems];
        mediaItems.value = updatedItems;
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

  // Static method to parse media items in an isolate
  static List<MediaItem> _parseMediaItems(List responseData) {
    return responseData.map((item) => MediaItem.fromJson(item)).toList();
  }

  //compress
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

  //thumbnail

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
      if (thumbnailFile != null && await thumbnailFile.exists()) {
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

  Future<void> saveMediaMetadata(
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

      // Generate a UUID instead of concatenating strings
      final String id = now.millisecondsSinceEpoch.toString();

      final Map<String, dynamic> mediaData = {
        'id': id,
        'user_id': userId,
        'url': url,
        'upload_date': formattedDate,
        'file_size': '${size.toStringAsFixed(2)} MB',
        'file_type': fileType,
        'is_video': mediaType == 'video',
        'created_at':
            now.toIso8601String(), // Add ISO format timestamp for accurate sorting
      };

      // Add thumbnail URL if available
      if (thumbnailUrl != null) {
        mediaData['thumbnail_url'] = thumbnailUrl;
      }

      final response =
          await _supabase.from('media_files').insert(mediaData).select();

      print('Insert response: $response');
    } catch (e) {
      print('Database insert error: $e');
      throw Exception('Failed to save media metadata: $e');
    }
  }

  // Getting file size in MB with 2 decimal places
  Future<double> getFileSizeInMB(File file) async {
    final int bytes = await file.length();
    final double sizeInMB = bytes / (1024 * 1024);
    return double.parse(sizeInMB.toStringAsFixed(2));
  }

  // Function to delete media item
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
      Get.snackbar(
        'Success',
        'Media deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to delete media: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Function to load more media - improved with better error handling
  Future<void> loadMoreMedia() async {
    if (isLoading.value || mediaItems.length >= totalItems.value) {
      return;
    }
    final nextPage = (mediaItems.length / itemsPerPage).ceil() + 1;
    await fetchUserMedia(page: nextPage);
  }

  // Function to copy URL to clipboard
  void copyUrlToClipboard(String url) async {
    try {
      // Actually copy the URL to clipboard
      await Clipboard.setData(ClipboardData(text: url));

      Get.snackbar(
        'Success',
        'URL copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error copying to clipboard: $e');
      Get.snackbar(
        'Error',
        'Failed to copy URL: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
