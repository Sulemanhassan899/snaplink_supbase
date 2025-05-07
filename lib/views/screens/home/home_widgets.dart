import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/controller/model_classs.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/home/functions_image.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
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
        const Gap(20),
        if (mediaService.isLoading.value && mediaService.mediaItems.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (mediaService.mediaItems.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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

//paginated list 
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
        firstPageProgressIndicatorBuilder:
            (context) =>
                mediaService.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
        newPageProgressIndicatorBuilder:
            (context) => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        noMoreItemsIndicatorBuilder:
            (context) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MyText(
                  text: "Limit reached",
                  size: 14,
                  color: kSubText,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w400,
                ),
              ),
            ),
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
          if (index == 0 ||
              !_isSameDate(
                mediaService.mediaItems[index - 1].uploadDateTime,
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
                            duration: const Duration(milliseconds: 100),
                            onTap: () => mediaService.deleteMediaItem(item),
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
