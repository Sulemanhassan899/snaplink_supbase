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
import 'package:snaplink/views/widget/image_contianer.dart';
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
            child: Column(
              children: [
                ListView.builder(
                  itemCount:
                      mediaService
                          .mediaItems
                          .length, // Remove +1, handle separately
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Change to make it scrollable
                  itemBuilder: (context, index) {
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
                                          () => mediaService.deleteMediaItem(
                                            item,
                                          ),
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
                                    () => mediaService.copyUrlToClipboard(
                                      item.url,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                Obx(() {
                  if (mediaService.isLoading.value &&
                      mediaService.mediaItems.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    );
                  } else if (mediaService.mediaItems.length >=
                          mediaService.itemsPerPage &&
                      mediaService.mediaItems.length >=
                          mediaService.totalItems.value) {
                    // Show "Limit reached" message when all items are loaded
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: "Limit reached",
                          size: 14,
                          color: kSubText,
                          textAlign: TextAlign.center,
                          weight: FontWeight.w400,
                        ),
                      ],
                    );
                  } else if (mediaService.mediaItems.length <
                      mediaService.totalItems.value) {
                    // Show circular progress indicator and auto-load more after 2 seconds
                    Future.delayed(Duration(seconds: 2), () {
                      if (mediaService.mediaItems.length <
                          mediaService.totalItems.value) {
                        mediaService.loadMoreMedia();
                      }
                    });

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                        strokeAlign: 3,
                      ),
                    );
                  } else {
                    return SizedBox.shrink(); // No more items to load
                  }
                }),
              ],
            ),
          );
        }),
        const Gap(200),
      ],
    );
  }
}

//no images found or new user
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

//date formatting

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
