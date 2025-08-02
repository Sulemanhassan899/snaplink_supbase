import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/constants/app_sizes.dart';
import 'package:snaplink/controller/model_classs.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/auth/notification_service.dart';
import 'package:snaplink/views/screens/bottomsheet/bottomsheet.dart';
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
      physics: const BouncingScrollPhysics(),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(text: "My Upload", size: 18, weight: FontWeight.w700),
            Obx(
              () => MyText(
                text: "${mediaService.totalItems.value} files",
                size: 14,
                color: kSubText,
                paddingTop: 10,
                paddingBottom: 10,
                textAlign: TextAlign.center,
                weight: FontWeight.w400,
              ),
            ),
          ],
        ),

        if (mediaService.isLoading.value && mediaService.mediaItems.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (mediaService.mediaItems.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: MyText(
                text: "No images",
                size: 16,
                textAlign: TextAlign.center,
                weight: FontWeight.w500,
              ),
            ),
          )
        else
          PaginatedMediaList(mediaService: mediaService),
        const Gap(200),
      ],
    );
  }
}

class PaginatedMediaList extends StatelessWidget {
  final MediaService mediaService;

  const PaginatedMediaList({Key? key, required this.mediaService})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, MediaItem>.separated(
      pagingController: mediaService.pagingController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      builderDelegate: PagedChildBuilderDelegate<MediaItem>(
        firstPageProgressIndicatorBuilder: (context) => const SizedBox.shrink(),
        newPageProgressIndicatorBuilder: (context) => const SizedBox.shrink(),

        noItemsFoundIndicatorBuilder:
            (context) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: MyText(
                  text: "No images",
                  size: 16,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w500,
                ),
              ),
            ),
        itemBuilder: (context, item, index) {
          final colors = [LightBlue, Lightyellow, LightGreen];

          Widget? dateHeader;
          final previousItem =
              index > 0
                  ? mediaService.pagingController.itemList![index - 1]
                  : null;
          if (index == 0 ||
              !_isSameDate(
                previousItem?.uploadDateTime ?? item.uploadDateTime,
                item.uploadDateTime,
              )) {
            dateHeader = Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: MyText(
                text: getRelativeDateString(item.uploadDateTime),
                size: 16,
                textAlign: TextAlign.left,
                weight: FontWeight.w500,
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Bounce(
                            // onTap: () => mediaService.deleteMediaItem(item),
                            onTap: () {
                              Get.dialog(
                                AnimatedColumn(
                                  animationDuration: 200,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: AppSizes.DEFAULT,
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: kWhite,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                      child: AnimatedColumn(
                                        children: [
                                          CommonImageView(
                                            imagePath: Assets.imagesLogout,
                                            height: 60,
                                          ),
                                          const SizedBox(height: 16),
                                          MyText(
                                            text:
                                                "Are you sure you want to Delete",
                                            size: 24,
                                            color: kBlack,
                                            weight: FontWeight.w700,
                                            textAlign: TextAlign.center,
                                          ),

                                          AnimatedRow(
                                            animationDuration: 200,
                                            spacing: 10,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: MyButton(
                                                  backgroundColor: kredColor,
                                                  buttonText: 'Yes',
                                                  fontColor: kWhite,
                                                  onTap: () async {
                                                    mediaService
                                                        .deleteMediaItem(item);
                                                    Get.back();
                                                    NotificationService.showNotification(
                                                      body:
                                                          'Deleted successfully',
                                                    );
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: MyGradientButton(
                                                  hasgrad: true,
                                                  gradient:
                                                      kChatBackgroundGradeintColor,
                                                  buttonText: 'Not now',
                                                  backgroundColor: kWhite,

                                                  onTap: () {
                                                    Get.back();
                                                  },
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
                            },
                            child: CommonImageView(
                              imagePath: Assets.imagesTrashRed,
                              height: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    child: Bounce(
                      onTap: () {
                        UploadBottomSheets.showPreviewBottomSheet(
                          context,
                          cancelUploadCallback:
                              mediaService.cancelUploadCallback,
                          mediaItem: item, // <--- Pass the tapped item directly
                        );
                      },
                      child: ImageContainer(
                        color: colors[index % colors.length],
                        imageUrl: item.url,
                        thumbnailUrl: item.thumbnailUrl,
                        isVideo: item.isVideo,
                        date: item.uploadDate,
                        size: "${item.fileSize}",
                        onShare:
                            () => mediaService.shareToOtherPlatforms(item.url),

                        onCopyUrl:
                            () => mediaService.copyUrlToClipboard(item.url),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
