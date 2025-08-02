// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:gap/gap.dart';
// import 'package:lottie/lottie.dart';
// import 'package:bounce/bounce.dart';
// import 'package:snaplink/constants/app_colors.dart';
// import 'package:snaplink/controller/model_classs.dart';
// import 'package:snaplink/generated/assets.dart';
// import 'package:snaplink/views/screens/home/functions_image.dart';
// import 'package:snaplink/views/widget/common_image_view_widget.dart';
// import 'package:snaplink/views/widget/custom_animated_column.dart';
// import 'package:snaplink/views/widget/double_white_contianers.dart';
// import 'package:snaplink/views/widget/my_button_new.dart';
// import 'package:snaplink/views/widget/my_text_widget.dart';
// import 'package:snaplink/views/widget/my_textfeild.dart';
// import 'package:video_player/video_player.dart';

// class UploadBottomSheets {
//   static RxBool isUploadedBottomSheetOpen = false.obs;

//   static void showUploadingBottomSheet(
//     BuildContext context, {
//     required RxBool isUploading,
//     required RxBool uploadCompleted,
//     required Rx<Function?> cancelUploadCallback,
//   }) {
//     isUploading.value = true;
//     uploadCompleted.value = false;

//     Get.bottomSheet(
//       isDismissible: true,
//       isScrollControlled: true,
//       enableDrag: false,
//       SizedBox(
//         height: Get.height - 100,
//         child: DoubleWhiteContainers2(
//           child: AnimatedColumn(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Bounce(
//                     onTap: () {
//                       if (Get.isBottomSheetOpen ?? false) {
//                         Get.back(); // Close sheet
//                       }
//                       cancelUploadCallback.value
//                           ?.call(); // Cancel actual upload
//                       isUploading.value = false;
//                     },
//                     child: CommonImageView(
//                       imagePath: Assets.imagesCancel,
//                       height: 24,
//                     ),
//                   ),
//                   Gap(20),
//                 ],
//               ),
//               Obx(() {
//                 if (uploadCompleted.value) {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Lottie.asset(Assets.animationsConfetti, height: 100),
//                       MyText(
//                         text: "Upload Completed!",
//                         size: 16,
//                         weight: FontWeight.w600,
//                         textAlign: TextAlign.center,
//                       ),
//                       const Gap(20),
//                     ],
//                   );
//                 } else {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Lottie.asset(Assets.animationsUploading, height: 100),
//                       MyText(
//                         text: "Uploading...",
//                         size: 16,
//                         weight: FontWeight.w600,
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   );
//                 }
//               }),
//               Gap(30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   static void showPreviewBottomSheet(
//     BuildContext context, {
//     required Rx<Function?> cancelUploadCallback,
//     required MediaItem mediaItem, // Add this parameter
//   }) {
//     Get.bottomSheet(
//       isDismissible: true,
//       isScrollControlled: true,
//       SizedBox(
//         height: Get.height - 100,
//         child: DoubleWhiteContainers2(
//           child: AnimatedColumn(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Bounce(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: CommonImageView(
//                       imagePath: Assets.imagesCancel,
//                       height: 24,
//                     ),
//                   ),
//                   Gap(20),
//                 ],
//               ),
//               // NO Obx needed for static preview of passed item
//               Builder(
//                 builder: (context) {
//                   final selectedItem = mediaItem;

//                   final urlController = TextEditingController(
//                     text: selectedItem.url,
//                   );

//                   return Column(
//                     children: [
//                       // Video or Image Preview
//                       Container(
//                         height: 250,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.black12,
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child:
//                               selectedItem.isVideo == true
//                                   ? _buildVideoPlayer(selectedItem.url)
//                                   : CommonImageView(
//                                     radius: 12,
//                                     url: selectedItem.url,
//                                     height: 250,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                         ),
//                       ),
//                       const Gap(12),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               MyText(
//                                 text: "Uploaded on: ",
//                                 size: 12,
//                                 color: kSubText,
//                               ),
//                               MyText(
//                                 text: selectedItem.uploadDate ?? "-",
//                                 size: 12,
//                                 weight: FontWeight.w600,
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               // Show media type indicator
//                               Icon(
//                                 selectedItem.isVideo == true
//                                     ? Icons.videocam
//                                     : Icons.image,
//                                 size: 12,
//                                 color: kSubText,
//                               ),
//                               Gap(4),
//                               MyText(
//                                 text: selectedItem.fileSize ?? "-",
//                                 size: 12,
//                                 color: kSubText,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const Gap(20),
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: MyText(
//                           text: "Link",
//                           size: 16,
//                           weight: FontWeight.w600,
//                         ),
//                       ),
//                       const Gap(10),
//                       MyTextField(
//                         controller: urlController,
//                         isReadOnly: true,
//                         radius: 12,
//                         filledColor: const Color(0xffF0F7FF),
//                         bordercolor: const Color(0xffD2E6FF),
//                       ),
//                       const Gap(20),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: MyBorderButton(
//                               onTap: () {
//                                 final mediaService = Get.find<MediaService>();
//                                 mediaService.copyUrlToClipboard(
//                                   selectedItem.url,
//                                 );
//                               },
//                               buttonText: "Copy URL",
//                               hasicon: true,
//                               choiceIcon: Assets.imagesCopy,
//                               fontColor: kBlack,
//                               outlineColor: kBorderColor,
//                             ),
//                           ),
//                           const Gap(10),
//                           Expanded(
//                             child: MyGradientButton(
//                               onTap: () {
//                                 final mediaService = Get.find<MediaService>();
//                                 mediaService.shareToOtherPlatforms(
//                                   selectedItem.url,
//                                 );
//                               },
//                               buttonText: "Share",
//                               hasicon: true,
//                               choiceIcon: Assets.imagesShare,
//                               fontColor: kWhite,
//                               backgroundColor: kPrimaryColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               Gap(30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   static Widget _buildVideoPlayer(String videoUrl) {
//     return Container(
//       width: double.infinity,
//       height: 250,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.black,
//       ),
//       child: Stack(
//         children: [
//           // Video player widget - you'll need to implement based on your video player package
//           // For example, if using video_player package:
//           VideoPlayerWidget(
//             videoUrl: videoUrl,
//             autoPlay: false,
//             showControls: true,
//           ),
//           // Play button overlay (optional)
//           Positioned(
//             top: 8,
//             right: 8,
//             child: Container(
//               padding: EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Colors.black54,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Icon(Icons.play_arrow, color: Colors.white, size: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   final bool autoPlay;
//   final bool showControls;

//   const VideoPlayerWidget({
//     Key? key,
//     required this.videoUrl,
//     this.autoPlay = false,
//     this.showControls = true,
//   }) : super(key: key);

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideoPlayer();
//   }

//   void _initializeVideoPlayer() async {
//     try {
//       _controller = VideoPlayerController.network(widget.videoUrl);
//       await _controller.initialize();

//       if (mounted) {
//         setState(() {
//           _isInitialized = true;
//         });

//         if (widget.autoPlay) {
//           _controller.play();
//           _isPlaying = true;
//         }
//       }
//     } catch (e) {
//       print('Error initializing video player: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//         _isPlaying = false;
//       } else {
//         _controller.play();
//         _isPlaying = true;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isInitialized) {
//       return Container(
//         color: Colors.black,
//         child: Center(
//           child: CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
//           ),
//         ),
//       );
//     }

//     return SizedBox(
//       width: double.infinity,
//       height: 250,
//       child: Stack(
//         children: [
//           // Video player
//           SizedBox(
//             width: double.infinity,
//             height: 250,
//             child: FittedBox(
//               fit: BoxFit.cover,
//               child: SizedBox(
//                 width: _controller.value.size.width,
//                 height: _controller.value.size.height,
//                 child: VideoPlayer(_controller),
//               ),
//             ),
//           ),

//           // Controls overlay
//           if (widget.showControls)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black26,
//                 child: Center(
//                   child: GestureDetector(
//                     onTap: _togglePlayPause,
//                     child: Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.black54,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         _isPlaying ? Icons.pause : Icons.play_arrow,
//                         color: Colors.white,
//                         size: 32,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//           // Video progress indicator (optional)
//           if (widget.showControls)
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: SizedBox(
//                 height: 4,
//                 child: VideoProgressIndicator(
//                   _controller,
//                   allowScrubbing: true,
//                   colors: VideoProgressColors(
//                     playedColor: kPrimaryColor,
//                     bufferedColor: Colors.white30,
//                     backgroundColor: Colors.white10,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class UploadedNewBottomSheet {
//   static void show(
//     BuildContext context,
//     List<MediaItem> uploads, {
//     Function? onCopyUrl,
//     Function? onShare,
//   }) {
//     Get.bottomSheet(
//       isDismissible: true,
//       isScrollControlled: true,
//       SizedBox(
//         height: Get.height - 100,
//         child: DoubleWhiteContainers2(
//           child: AnimatedColumn(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Header with close button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   MyText(
//                     text: "Uploaded Successfully",
//                     size: 18,
//                     weight: FontWeight.w600,
//                   ),
//                   Bounce(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: CommonImageView(
//                       imagePath: Assets.imagesCancel,
//                       height: 24,
//                     ),
//                   ),
//                 ],
//               ),

//               Gap(20),

//               // Main content
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Media Preview Section (Images and Videos)
//                       _buildMediaPreviewSection(uploads),

//                       Gap(20),

//                       // Upload Details
//                       _buildUploadDetails(uploads),

//                       Gap(20),

//                       // Links Section - Dynamic for each upload
//                       _buildLinksSection(uploads),

//                       Gap(20),
//                       uploads.length == 1
//                           ? Row(
//                             children: [
//                               Expanded(
//                                 child: MyBorderButton(
//                                   onTap: () {
//                                     final mediaService =
//                                         Get.find<MediaService>();
//                                     mediaService.copyUrlToClipboard(
//                                       uploads.first.url,
//                                     );
//                                     if (onCopyUrl != null) onCopyUrl();
//                                   },
//                                   buttonText: "Copy URL",
//                                   hasicon: true,
//                                   choiceIcon: Assets.imagesCopy,
//                                   fontColor: kBlack,
//                                   outlineColor: kBorderColor,
//                                 ),
//                               ),
//                               Gap(10),
//                               Expanded(
//                                 child: MyGradientButton(
//                                   onTap: () {
//                                     final mediaService =
//                                         Get.find<MediaService>();
//                                     mediaService.shareToOtherPlatforms(
//                                       uploads.first.url,
//                                     );
//                                     if (onShare != null) onShare();
//                                   },
//                                   buttonText: "Share",
//                                   hasicon: true,
//                                   choiceIcon: Assets.imagesShare,
//                                   fontColor: kWhite,
//                                   backgroundColor: kPrimaryColor,
//                                 ),
//                               ),
//                             ],
//                           )
//                           : const SizedBox.shrink(),
//                     ],
//                   ),
//                 ),
//               ),

//               Gap(30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   static Widget _buildLinksSection(List<MediaItem> uploads) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ...uploads.asMap().entries.map((entry) {
//           int index = entry.key;
//           MediaItem item = entry.value;
//           final colors = [LightBlue, Lightyellow, LightGreen];

//           return Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: colors[index % colors.length],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   spacing: 6,
//                   children: [
//                     Expanded(
//                       child: MyTextField(
//                         controller: TextEditingController(text: item.url),
//                         isReadOnly: true,
//                         marginBottom: 0,
//                         radius: 12,
//                         filledColor: kWhite,
//                         bordercolor: kTransperentColor,
//                       ),
//                     ),
//                     if (uploads.length > 1)
//                       Row(
//                         spacing: 6,
//                         children: [
//                           Bounce(
//                             onTap: () {
//                               final mediaService = Get.find<MediaService>();
//                               mediaService.copyUrlToClipboard(item.url);
//                             },
//                             child: CommonImageView(
//                               imagePath: Assets.imagesCopy,
//                               height: 40,
//                             ),
//                           ),
//                           Bounce(
//                             onTap: () {
//                               final mediaService = Get.find<MediaService>();
//                               mediaService.shareToOtherPlatforms(item.url);
//                             },
//                             child: CommonImageView(
//                               imagePath: Assets.imagesShareIcon,
//                               height: 40,
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),

//               // Add gap between text fields (except after the last one)
//               if (index < uploads.length - 1) Gap(10),
//             ],
//           );
//         }),
//       ],
//     );
//   }

//   // Updated to handle both images and videos
//   static Widget _buildMediaPreviewSection(List<MediaItem> uploads) {
//     if (uploads.isEmpty) return SizedBox();

//     final int itemCount = uploads.length;

//     if (itemCount == 1) {
//       // Single media item - center
//       return _buildSingleMediaItem(uploads[0], 250, double.infinity);
//     } else if (itemCount >= 2 && itemCount <= 3) {
//       // 2-3 media items - center row, size 100
//       return SizedBox(
//         height: 200,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children:
//               uploads.take(3).map((item) {
//                 final double size = itemCount == 2 ? 120 : 90;
//                 return Container(
//                   margin: EdgeInsets.symmetric(horizontal: 4),
//                   width: size,
//                   height: size,
//                   child: _buildSingleMediaItem(item, size, size),
//                 );
//               }).toList(),
//         ),
//       );
//     } else if (itemCount >= 4 && itemCount <= 5) {
//       // 4-5 media items - two rows, size 90
//       final int firstRowCount = itemCount == 4 ? 2 : 3;
//       final int secondRowCount = itemCount - firstRowCount;
//       const double size = 90;
//       return SizedBox(
//         height: 220,
//         child: Column(
//           children: [
//             // First row - center
//             SizedBox(
//               height: size,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:
//                     uploads.take(firstRowCount).map((item) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 4),
//                         width: size,
//                         child: _buildSingleMediaItem(item, size, size),
//                       );
//                     }).toList(),
//               ),
//             ),

//             Gap(8),

//             // Second row - start alignment
//             SizedBox(
//               height: size,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:
//                     uploads.skip(firstRowCount).take(secondRowCount).map((
//                       item,
//                     ) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 4),
//                         width: size,
//                         child: _buildSingleMediaItem(item, size, size),
//                       );
//                     }).toList(),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else if (itemCount == 6) {
//       // 6 media items - two rows, size 100
//       const int firstRowCount = 3;
//       const int secondRowCount = 3;
//       const double size = 100;
//       return SizedBox(
//         height: 220,
//         child: Column(
//           children: [
//             // First row - center
//             SizedBox(
//               height: size,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:
//                     uploads.take(firstRowCount).map((item) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 4),
//                         width: size,
//                         child: _buildSingleMediaItem(item, size, size),
//                       );
//                     }).toList(),
//               ),
//             ),

//             Gap(8),

//             // Second row - start alignment
//             SizedBox(
//               height: size,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:
//                     uploads.skip(firstRowCount).take(secondRowCount).map((
//                       item,
//                     ) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 4),
//                         width: size,
//                         child: _buildSingleMediaItem(item, size, size),
//                       );
//                     }).toList(),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // More than 6 media items - show first 5 and +count on 6th
//       final int remainingCount = itemCount - 5;
//       const double size = 80;
//       return SizedBox(
//         height: 220,
//         child: Column(
//           children: [
//             // First row - 3 media items
//             SizedBox(
//               height: size,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:
//                     uploads.take(3).map((item) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 4),
//                         width: size,
//                         child: _buildSingleMediaItem(item, size, size),
//                       );
//                     }).toList(),
//               ),
//             ),

//             Gap(8),

//             // Second row - 2 media items + count overlay
//             SizedBox(
//               height: size,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   // 4th media item
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                     width: size,
//                     child: _buildSingleMediaItem(uploads[3], size, size),
//                   ),

//                   // 5th media item
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                     width: size,
//                     child: _buildSingleMediaItem(uploads[4], size, size),
//                   ),

//                   // 6th media item with overlay
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                     width: size,
//                     child: Stack(
//                       children: [
//                         _buildSingleMediaItem(uploads[5], size, size),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.6),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Center(
//                             child: MyText(
//                               text: "+$remainingCount",
//                               size: 24,
//                               weight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // New helper method to build single media item (image or video)
//   static Widget _buildSingleMediaItem(
//     MediaItem item,
//     double height,
//     double width,
//   ) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: SizedBox(
//         height: height,
//         width: width,
//         child:
//             item.isVideo == true
//                 ? _buildVideoThumbnail(item, height, width)
//                 : CommonImageView(
//                   radius: 12,
//                   url: item.url,
//                   height: height,
//                   width: width,
//                   fit: BoxFit.cover,
//                 ),
//       ),
//     );
//   }

//   static Widget _buildVideoThumbnail(
//     MediaItem item,
//     double height,
//     double width,
//   ) {
//     // Create a video player controller to manage playback state
//     VideoPlayerController? controller;

//     return SizedBox(
//       height: height,
//       width: width,
//       child: Stack(
//         children: [
//           // Use thumbnail URL if available, otherwise use video URL
//           CommonImageView(
//             radius: 12,
//             url: item.thumbnailUrl ?? item.url,
//             height: height,
//             width: width,
//             fit: BoxFit.cover,
//           ),

//           // Dark overlay for video indication
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),

//           // Play icon overlay
//           Positioned.fill(
//             child: Center(
//               child: Container(
//                 padding: EdgeInsets.all(height > 100 ? 8 : 4),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   shape: BoxShape.circle,
//                 ),
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.play_arrow,
//                     color: Colors.white,
//                     size: height > 100 ? 24 : 16,
//                   ),
//                   onPressed: () async {
//                     // Initialize video player controller and play
//                     controller = VideoPlayerController.network(item.url)
//                       ..initialize().then((_) {
//                         controller!.play();
//                       });
//                   },
//                 ),
//               ),
//             ),
//           ),

//           // Video duration indicator (if available)
//           if (item.fileType == 'mp4' || item.fileType == 'mov')
//             Positioned(
//               bottom: 4,
//               right: 4,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.videocam, color: Colors.white, size: 8),
//                     Gap(2),
//                     MyText(
//                       text: "VIDEO",
//                       size: 8,
//                       color: Colors.white,
//                       weight: FontWeight.w600,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   static Widget _buildUploadDetails(List<MediaItem> uploads) {
//     final MediaItem firstItem = uploads.first;

//     return AnimatedColumn(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 MyText(text: "Uploaded on: ", size: 14, color: kSubText),
//                 MyText(
//                   text: firstItem.uploadDate ?? "-",
//                   size: 14,
//                   weight: FontWeight.w600,
//                 ),
//               ],
//             ),

//             Row(
//               children: [
//                 // Media type indicator
//                 MyText(text: "File Size: ", size: 14, color: kSubText),
//                 Gap(4),
//                 MyText(
//                   text: _getTotalFileSize(uploads),
//                   size: 14,
//                   color: kBlack,
//                   weight: FontWeight.w600,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // Helper method to get appropriate icon for media type
//   static IconData _getMediaTypeIcon(List<MediaItem> uploads) {
//     final bool hasVideo = uploads.any((item) => item.isVideo == true);
//     final bool hasImage = uploads.any((item) => item.isVideo != true);

//     if (hasVideo && hasImage) {
//       return Icons.perm_media; // Mixed media
//     } else if (hasVideo) {
//       return Icons.videocam; // Only videos
//     } else {
//       return Icons.image; // Only images
//     }
//   }

//   static String _getTotalFileSize(List<MediaItem> uploads) {
//     double total = 0.0;
//     for (final item in uploads) {
//       final match = RegExp(r"([\d.]+)").firstMatch(item.fileSize ?? "");
//       if (match != null) {
//         total += double.tryParse(match.group(1) ?? "0") ?? 0;
//       }
//     }
//     return "${total.toStringAsFixed(2)} MB";
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:bounce/bounce.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/controller/model_classs.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/home/functions_image.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/double_white_contianers.dart';
import 'package:snaplink/views/widget/my_button_new.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:snaplink/views/widget/my_textfeild.dart';
import 'package:video_player/video_player.dart';

class UploadBottomSheets {
  static RxBool isUploadedBottomSheetOpen = false.obs;

  static void showUploadingBottomSheet(
    BuildContext context, {
    required RxBool isUploading,
    required RxBool uploadCompleted,
    required Rx<Function?> cancelUploadCallback,
  }) {
    isUploading.value = true;
    uploadCompleted.value = false;

    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: false,
      SizedBox(
        height: Get.height - 100,
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
                if (uploadCompleted.value) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(Assets.animationsConfetti, height: 100),
                      MyText(
                        text: "Upload Completed!",
                        size: 16,
                        weight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(20),
                    ],
                  );
                } else {
                  return Column(
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
                }
              }),
              Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  static void showPreviewBottomSheet(
    BuildContext context, {
    required Rx<Function?> cancelUploadCallback,
    required MediaItem mediaItem, // Add this parameter
  }) {
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      SizedBox(
        height: Get.height - 100,
        child: DoubleWhiteContainers2(
          child: AnimatedColumn(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Bounce(
                    onTap: () {
                      Get.back();
                    },
                    child: CommonImageView(
                      imagePath: Assets.imagesCancel,
                      height: 24,
                    ),
                  ),
                  Gap(20),
                ],
              ),
              // NO Obx needed for static preview of passed item
              Builder(
                builder: (context) {
                  final selectedItem = mediaItem;

                  final urlController = TextEditingController(
                    text: selectedItem.url,
                  );

                  return Column(
                    children: [
                      // Video or Image Preview
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black12,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              selectedItem.isVideo == true
                                  ? _buildVideoPlayer(selectedItem.url)
                                  : CommonImageView(
                                    radius: 12,
                                    url: selectedItem.url,
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ),
                      const Gap(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              MyText(
                                text: "Uploaded on: ",
                                size: 12,
                                color: kSubText,
                              ),
                              MyText(
                                text: selectedItem.uploadDate ?? "-",
                                size: 12,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Show media type indicator
                              Icon(
                                selectedItem.isVideo == true
                                    ? Icons.videocam
                                    : Icons.image,
                                size: 12,
                                color: kSubText,
                              ),
                              Gap(4),
                              MyText(
                                text: selectedItem.fileSize ?? "-",
                                size: 12,
                                color: kSubText,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: MyText(
                          text: "Link",
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ),
                      const Gap(10),
                      MyTextField(
                        controller: urlController,
                        isReadOnly: true,
                        radius: 12,
                        filledColor: const Color(0xffF0F7FF),
                        bordercolor: const Color(0xffD2E6FF),
                      ),
                      const Gap(20),
                      Row(
                        children: [
                          Expanded(
                            child: MyBorderButton(
                              onTap: () {
                                try {
                                  final mediaService = Get.find<MediaService>();
                                  mediaService.copyUrlToClipboard(
                                    selectedItem.url,
                                  );
                                  Get.snackbar(
                                    'Success',
                                    'URL copied to clipboard!',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 2),
                                  );
                                } catch (e) {
                                  // Fallback: Copy to clipboard directly
                                  Clipboard.setData(ClipboardData(text: selectedItem.url));
                                  Get.snackbar(
                                    'Success',
                                    'URL copied to clipboard!',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 2),
                                  );
                                }
                              },
                              buttonText: "Copy URL",
                              hasicon: true,
                              choiceIcon: Assets.imagesCopy,
                              fontColor: kBlack,
                              outlineColor: kBorderColor,
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: MyGradientButton(
                              onTap: () {
                                try {
                                  final mediaService = Get.find<MediaService>();
                                  mediaService.shareToOtherPlatforms(
                                    selectedItem.url,
                                  );
                                  Get.snackbar(
                                    'Success',
                                    'Sharing URL...',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.blue,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 2),
                                  );
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'MediaService not available',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 2),
                                  );
                                }
                              },
                              buttonText: "Share",
                              hasicon: true,
                              choiceIcon: Assets.imagesShare,
                              fontColor: kWhite,
                              backgroundColor: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildVideoPlayer(String videoUrl) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      child: Stack(
        children: [
          // Video player widget - you'll need to implement based on your video player package
          // For example, if using video_player package:
          VideoPlayerWidget(
            videoUrl: videoUrl,
            autoPlay: false,
            showControls: true,
          ),
          // Play button overlay (optional)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.play_arrow, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool showControls;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.autoPlay = false,
    this.showControls = true,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.network(widget.videoUrl);
      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        if (widget.autoPlay) {
          _controller.play();
          _isPlaying = true;
        }
      }
    } catch (e) {
      print('Error initializing video player: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Stack(
        children: [
          // Video player
          SizedBox(
            width: double.infinity,
            height: 250,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),

          // Controls overlay
          if (widget.showControls)
            Positioned.fill(
              child: Container(
                color: Colors.black26,
                child: Center(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Video progress indicator (optional)
          if (widget.showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 4,
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: kPrimaryColor,
                    bufferedColor: Colors.white30,
                    backgroundColor: Colors.white10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class UploadedNewBottomSheet {
  static void show(
    BuildContext context,
    List<MediaItem> uploads, {
    Function? onCopyUrl,
    Function? onShare,
  }) {
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      SizedBox(
        height: Get.height - 100,
        child: DoubleWhiteContainers2(
          child: AnimatedColumn(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: "Uploaded Successfully",
                    size: 18,
                    weight: FontWeight.w600,
                  ),
                  Bounce(
                    onTap: () {
                      Get.back();
                    },
                    child: CommonImageView(
                      imagePath: Assets.imagesCancel,
                      height: 24,
                    ),
                  ),
                ],
              ),

              Gap(20),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Media Preview Section (Images and Videos)
                      _buildMediaPreviewSection(uploads),

                      Gap(20),

                      // Upload Details
                      _buildUploadDetails(uploads),

                      Gap(20),

                      // Links Section - Dynamic for each upload
                      _buildLinksSection(uploads),

                      Gap(20),
                      uploads.length == 1
                          ? Row(
                            children: [
                              Expanded(
                                child: MyBorderButton(
                                  onTap: () {
                                    final mediaService =
                                        Get.find<MediaService>();
                                    mediaService.copyUrlToClipboard(
                                      uploads.first.url,
                                    );
                                    if (onCopyUrl != null) onCopyUrl();
                                  },
                                  buttonText: "Copy URL",
                                  hasicon: true,
                                  choiceIcon: Assets.imagesCopy,
                                  fontColor: kBlack,
                                  outlineColor: kBorderColor,
                                ),
                              ),
                              Gap(10),
                              Expanded(
                                child: MyGradientButton(
                                  onTap: () {
                                    final mediaService =
                                        Get.find<MediaService>();
                                    mediaService.shareToOtherPlatforms(
                                      uploads.first.url,
                                    );
                                    if (onShare != null) onShare();
                                  },
                                  buttonText: "Share",
                                  hasicon: true,
                                  choiceIcon: Assets.imagesShare,
                                  fontColor: kWhite,
                                  backgroundColor: kPrimaryColor,
                                ),
                              ),
                            ],
                          )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),

              Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildLinksSection(List<MediaItem> uploads) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...uploads.asMap().entries.map((entry) {
          int index = entry.key;
          MediaItem item = entry.value;
          final colors = [LightBlue, Lightyellow, LightGreen];

          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  spacing: 6,
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: TextEditingController(text: item.url),
                        isReadOnly: true,
                        marginBottom: 0,
                        radius: 12,
                        filledColor: kWhite,
                        bordercolor: kTransperentColor,
                      ),
                    ),
                    if (uploads.length > 1)
                      Row(
                        spacing: 6,
                        children: [
                          Bounce(
                            onTap: () {
                              try {
                                final mediaService = Get.find<MediaService>();
                                mediaService.copyUrlToClipboard(item.url);
                                Get.snackbar(
                                  'Success',
                                  'URL copied to clipboard!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  
                                  backgroundGradient: kContainerBackgroundGradeintColor,
                                  colorText: Colors.white,
                                  duration: Duration(seconds: 2),
                                );
                              } catch (e) {
                                // Fallback: Copy to clipboard directly
                                Clipboard.setData(ClipboardData(text: item.url));
                                Get.snackbar(
                                  'Success',
                                  'URL copied to clipboard!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: Duration(seconds: 2),
                                );
                              }
                            },
                            child: CommonImageView(
                              imagePath: Assets.imagesCopy,
                              height: 40,
                            ),
                          ),
                       ],
                      ),
                  ],
                ),
              ),

              // Add gap between text fields (except after the last one)
              if (index < uploads.length - 1) Gap(10),
            ],
          );
        }),
      ],
    );
  }

  // Updated to handle both images and videos
  static Widget _buildMediaPreviewSection(List<MediaItem> uploads) {
    if (uploads.isEmpty) return SizedBox();

    final int itemCount = uploads.length;

    if (itemCount == 1) {
      // Single media item - center
      return _buildSingleMediaItem(uploads[0], 250, double.infinity);
    } else if (itemCount >= 2 && itemCount <= 3) {
      // 2-3 media items - center row, size 100
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            uploads.take(3).map((item) {
              final double size = itemCount == 2 ? 120 : 90;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: size,
                height: size,
                child: _buildSingleMediaItem(item, size, size),
              );
            }).toList(),
      );
    } else if (itemCount >= 4 && itemCount <= 5) {
      // 4-5 media items - two rows, size 90
      final int firstRowCount = itemCount == 4 ? 2 : 3;
      final int secondRowCount = itemCount - firstRowCount;
      const double size = 90;
      return Column(
        children: [
          // First row - center
          SizedBox(
            height: size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  uploads.take(firstRowCount).map((item) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: size,
                      child: _buildSingleMediaItem(item, size, size),
                    );
                  }).toList(),
            ),
          ),
      
          Gap(8),
      
          // Second row - start alignment
          SizedBox(
            height: size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  uploads.skip(firstRowCount).take(secondRowCount).map((
                    item,
                  ) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: size,
                      child: _buildSingleMediaItem(item, size, size),
                    );
                  }).toList(),
            ),
          ),
        ],
      );
    } else if (itemCount == 6) {
      // 6 media items - two rows, size 100
      const int firstRowCount = 3;
      const int secondRowCount = 3;
      const double size = 100;
      return Column(
        children: [
          // First row - center
          SizedBox(
            height: size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  uploads.take(firstRowCount).map((item) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: size,
                      child: _buildSingleMediaItem(item, size, size),
                    );
                  }).toList(),
            ),
          ),
      
          Gap(8),
      
          // Second row - start alignment
          SizedBox(
            height: size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  uploads.skip(firstRowCount).take(secondRowCount).map((
                    item,
                  ) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: size,
                      child: _buildSingleMediaItem(item, size, size),
                    );
                  }).toList(),
            ),
          ),
        ],
      );
    } else {
      // More than 6 media items - show first 5 and +count on 6th
      final int remainingCount = itemCount - 5;
      const double size = 80;
      return Column(
        children: [
          // First row - 3 media items
          SizedBox(
            height: size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  uploads.take(3).map((item) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: size,
                      child: _buildSingleMediaItem(item, size, size),
                    );
                  }).toList(),
            ),
          ),
      
          Gap(8),
      
          // Second row - 2 media items + count overlay
          SizedBox(
            height: size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 4th media item
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: size,
                  child: _buildSingleMediaItem(uploads[3], size, size),
                ),
      
                // 5th media item
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: size,
                  child: _buildSingleMediaItem(uploads[4], size, size),
                ),
      
                // 6th media item with overlay
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: size,
                  child: Stack(
                    children: [
                      _buildSingleMediaItem(uploads[5], size, size),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: MyText(
                            text: "+$remainingCount",
                            size: 24,
                            weight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  // New helper method to build single media item (image or video)
  static Widget _buildSingleMediaItem(
    MediaItem item,
    double height,
    double width,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        width: width,
        child:
            item.isVideo == true
                ? _buildVideoThumbnail(item, height, width)
                : CommonImageView(
                  radius: 12,
                  url: item.url,
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                ),
      ),
    );
  }

  static Widget _buildVideoThumbnail(
    MediaItem item,
    double height,
    double width,
  ) {
    // Create a video player controller to manage playback state
    VideoPlayerController? controller;

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          // Use thumbnail URL if available, otherwise use video URL
          CommonImageView(
            radius: 12,
            url: item.thumbnailUrl ?? item.url,
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),

          // Dark overlay for video indication
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Play icon overlay
          Positioned.fill(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(height > 100 ? 8 : 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: height > 100 ? 24 : 16,
                  ),
                  onPressed: () async {
                    // Initialize video player controller and play
                    controller = VideoPlayerController.network(item.url)
                      ..initialize().then((_) {
                        controller!.play();
                      });
                  },
                ),
              ),
            ),
          ),

          // Video duration indicator (if available)
          if (item.fileType == 'mp4' || item.fileType == 'mov')
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.videocam, color: Colors.white, size: 8),
                    Gap(2),
                    MyText(
                      text: "VIDEO",
                      size: 8,
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  static Widget _buildUploadDetails(List<MediaItem> uploads) {
    final MediaItem firstItem = uploads.first;

    return AnimatedColumn(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                MyText(text: "Uploaded on: ", size: 14, color: kSubText),
                MyText(
                  text: firstItem.uploadDate ?? "-",
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ],
            ),

            Row(
              children: [
                // Media type indicator
                MyText(text: "File Size: ", size: 14, color: kSubText),
                Gap(4),
                MyText(
                  text: _getTotalFileSize(uploads),
                  size: 14,
                  color: kBlack,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to get appropriate icon for media type
  static IconData _getMediaTypeIcon(List<MediaItem> uploads) {
    final bool hasVideo = uploads.any((item) => item.isVideo == true);
    final bool hasImage = uploads.any((item) => item.isVideo != true);

    if (hasVideo && hasImage) {
      return Icons.perm_media; // Mixed media
    } else if (hasVideo) {
      return Icons.videocam; // Only videos
    } else {
      return Icons.image; // Only images
    }
  }

  static String _getTotalFileSize(List<MediaItem> uploads) {
    double total = 0.0;
    for (final item in uploads) {
      final match = RegExp(r"([\d.]+)").firstMatch(item.fileSize ?? "");
      if (match != null) {
        total += double.tryParse(match.group(1) ?? "0") ?? 0;
      }
    }
    return "${total.toStringAsFixed(2)} MB";
  }
}