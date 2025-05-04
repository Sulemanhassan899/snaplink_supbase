import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/home/functions_image.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/my_button_new.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DataBody extends StatelessWidget {
  const DataBody({super.key, required this.mediaService});

  final MediaService mediaService;

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImageView(
              imagePath: Assets.imagesHomeMainUpload,
              height: 150,
            ),
          ],
        ),
        const Gap(20),
        MyGradientButton(
          onTap: () => mediaService.showMediaPickerDialog(),
          buttonText: "Upload Image",
        ),
        const Gap(20),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(text: "My Upload", size: 18, weight: FontWeight.w700),
              MyText(
                text: "${mediaService.totalItems.value} files",
                size: 14,
                color: kSubText,
                paddingTop: 10,
                paddingBottom: 10,
                textAlign: TextAlign.center,
                weight: FontWeight.w400,
              ),
            ],
          ),
        ),
        const Gap(20),
        Obx(() {
          if (mediaService.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (mediaService.mediaItems.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: MyText(
                  text:
                      "No images", // Display "No images" if no media is available
                  size: 16,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w500,
                ),
              ),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!mediaService.isLoading.value &&
                  scrollInfo.metrics.pixels >
                      (scrollInfo.metrics.maxScrollExtent - 200)) {
                // Load more when user approaches the bottom (within 200 pixels)
                mediaService.loadMoreMedia();
                return true;
              }
              return false;
            },
            child: ListView.builder(
              itemCount:
                  mediaService.mediaItems.length +
                  (mediaService.mediaItems.length <
                          mediaService.totalItems.value
                      ? 1
                      : 0), // Only add +1 if more items exist
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Change to make it scrollable
              itemBuilder: (context, index) {
                if (index == mediaService.mediaItems.length) {
                  // Show loading indicator at the bottom only when more items are expected
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // Rest of your existing item builder code...
                final colors = [LightBlue, Lightyellow, LightGreen];
                final item = mediaService.mediaItems[index];

                // Determine if we need a date header
                Widget? dateHeader;
                if (index == 0) {
                  // Always show header for first item
                  dateHeader = Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8),
                    child: MyText(
                      text: getRelativeDateString(item.uploadDateTime),
                      size: 16,
                      textAlign: TextAlign.left,
                      weight: FontWeight.w500,
                    ),
                  );
                } else {
                  // Check if date differs from previous item
                  final previousItem = mediaService.mediaItems[index - 1];
                  final previousDate = DateTime(
                    previousItem.uploadDateTime.year,
                    previousItem.uploadDateTime.month,
                    previousItem.uploadDateTime.day,
                  );
                  final currentDate = DateTime(
                    item.uploadDateTime.year,
                    item.uploadDateTime.month,
                    item.uploadDateTime.day,
                  );

                  if (currentDate != previousDate) {
                    dateHeader = MyText(
                      text: getRelativeDateString(item.uploadDateTime),
                      size: 16,
                      paddingBottom: 6,
                      textAlign: TextAlign.start,
                      weight: FontWeight.w700,
                    );
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show date header only if it's not null
                    if (dateHeader != null) dateHeader,

                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: kGreyContainerGreyColor2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.2,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Bounce(
                                  duration: Duration(milliseconds: 100),
                                  onTap:
                                      () => mediaService.deleteMediaItem(item),
                                  child: CommonImageView(
                                    imagePath: Assets.imagesTrashRed,
                                    height: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child: ImageContainer(
                            color: colors[index % colors.length],
                            imageUrl: item.url,
                            thumbnailUrl: item.thumbnailUrl,
                            isVideo: item.isVideo,
                            date: item.uploadDate,
                            size: "${item.fileSize}",
                            onCopyUrl:
                                () => mediaService.copyUrlToClipboard(item.url),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }),
        const Gap(200),
      ],
    );
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.color,
    required this.imageUrl,
    required this.date,
    required this.size,
    required this.onCopyUrl,
    this.thumbnailUrl,
    required this.isVideo,
  });

  final Color color;
  final String date;
  final String size;
  final String imageUrl;
  final String? thumbnailUrl;
  final bool isVideo;
  final VoidCallback onCopyUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: AnimatedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              isVideo && thumbnailUrl != null
                  ? CommonImageView(
                    radius: 8,
                    url: thumbnailUrl,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  )
                  : CommonImageView(
                    url: imageUrl,
                    height: 60,
                    radius: 8,
                    width: 60,
                    fit: BoxFit.cover,
                  ),

              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    text: 'Uploaded on',
                    size: 12,
                    color: kSubText,
                    textAlign: TextAlign.center,
                    weight: FontWeight.w400,
                  ),
                  MyText(
                    text: date,
                    size: 10,
                    color: kSubText,
                    textAlign: TextAlign.center,
                    weight: FontWeight.w400,
                  ),
                  MyText(
                    text: size,
                    size: 14,
                    textAlign: TextAlign.center,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Bounce(
                duration: const Duration(milliseconds: 100),
                onTap: onCopyUrl,
                child: CommonImageView(
                  imagePath: Assets.imagesCopyhttpIcon,
                  height: 40,
                ),
              ),
              const SizedBox(width: 8),
              Bounce(
                child: CommonImageView(
                  imagePath: Assets.imagesShareIcon,
                  height: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String getRelativeDateString(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCompare = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (dateToCompare == today) {
    return "Today";
  } else if (dateToCompare == yesterday) {
    return "Yesterday";
  } else {
    return DateFormat('d,MMMM,yyyy').format(dateTime);
  }
}

class NoDataBody extends StatelessWidget {
  const NoDataBody({super.key, required this.mediaService});

  final MediaService mediaService;

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImageView(
              imagePath: Assets.imagesHomeMainUpload,
              height: 300,
            ),
          ],
        ),

        MyText(
          text: "Let's Upload you image",
          size: 24,
          textAlign: TextAlign.center,
          weight: FontWeight.w700,
        ),
        MyText(
          text: "Instant image sharing\nDive in by uploading your image",
          size: 14,
          color: kSubText,

          textAlign: TextAlign.center,
          weight: FontWeight.w400,
        ),
        const Gap(20),
        MyGradientButton(
          onTap: () => mediaService.showMediaPickerDialog(),
          buttonText: "Upload Image",
        ),
      ],
    );
  }
}
