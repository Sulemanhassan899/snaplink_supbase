import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.color,
    required this.imageUrl,
    required this.date,
    required this.size,
    required this.onCopyUrl,
        required this.onShare,

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
   final VoidCallback onShare;

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
            spacing: 20,
            children: [
              isVideo && thumbnailUrl != null
                  ? Bounce(
                    child: CommonImageView(
                      radius: 8,
                      url: thumbnailUrl,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                  : Bounce(
                    child: CommonImageView(
                      url: imageUrl,
                      height: 60,
                      radius: 8,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),

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
            spacing: 10,
            children: [
              Bounce(
                onTap: onCopyUrl,
                child: CommonImageView(
                  imagePath: Assets.imagesCopyhttpIcon,
                  height: 40,
                ),
              ),

              Bounce(
                 onTap: onShare,
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
