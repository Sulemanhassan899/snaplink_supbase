import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:snaplink/views/widget/my_button_new.dart';

class ConnectionCheck {
  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static void showNoInternetDialog(BuildContext context, String action) {
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
              children: [
                const Gap(20),
                CommonImageView(
                  imagePath: Assets.imagesNoInternet, // You'll need to add this asset
                  height: 118,
                  width: 133,
                ),
                const Gap(20),
                MyText(
                  text: "No Internet Connection",
                  size: 24,
                  color: kBlack,
                  weight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                const Gap(10),
                MyText(
                  text: "Please connect to internet $action.",
                  size: 14,
                  color: kSubText,
                  paddingBottom: 32,
                  weight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                MyGradientButton(
                  buttonText: 'Okay',
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}