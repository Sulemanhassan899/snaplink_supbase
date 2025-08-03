import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/constants/app_sizes.dart';
import 'package:snaplink/controller/auth_service.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/auth/login.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/my_button_new.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:snaplink/views/screens/auth/notification_service.dart';

class DialogHelper {
  static void RestPasswordDialog(BuildContext context) {
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
                  imagePath: Assets.imagesSucess2,
                  height: 118,
                  width: 133,
                ),
                const Gap(20),
                MyText(
                  text: "Password Changed",
                  size: 24,
                  color: kBlack,
                  weight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                const Gap(10),
                MyText(
                  text: "Your account password has been changed successfully.",

                  size: 14,
                  color: kSubText4,
                  paddingBottom: 32,
                  weight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                MyGradientButton(
                  buttonText: 'Back to Login',
                  onTap: () {
                    Get.offAll(() => LoginScreen());
                    NotificationService.showNotification(
                      body: 'Your password has been changed successfully',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void LogoutDialog(BuildContext context) {
    final authService = AuthService();
    bool isLoading = false; // Track loading state

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AnimatedColumn(
            animationDuration: 200,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: AppSizes.DEFAULT,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: AnimatedColumn(
                  children: [
                    CommonImageView(imagePath: Assets.imagesLogout, height: 60),
                    const SizedBox(height: 16),
                    MyText(
                      text: "Logging out?",
                      size: 24,
                      color: kBlack,
                      weight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    MyText(
                      text: "Are you sure you want to log out?",
                      size: 14,
                      color: kSubText4,
                      paddingBottom: 16,
                      paddingTop: 16,
                      weight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                    AnimatedRow(
                      animationDuration: 200,
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child:
                              isLoading
                                  ? Container(
                                    height: 50, // Match button height
                                    decoration: BoxDecoration(
                                      color: kredColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              kWhite,
                                            ),
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                  : MyButton(
                                    backgroundColor: kredColor,
                                    buttonText: 'Yes, logout',
                                    fontColor: kWhite,
                                    onTap: () async {
                                      if (isLoading)
                                        return; // Prevent multiple clicks

                                      setState(() {
                                        isLoading = true; // Start loading
                                      });

                                      try {
                                        await authService.signOut();
                                        Get.offAll(() => const LoginScreen());
                                        NotificationService.showNotification(
                                          body: 'Logged out successfully',
                                        );
                                      } catch (e) {
                                        // Handle error if needed
                                        NotificationService.showNotification(
                                          body:
                                              'Logout failed. Please try again.',
                                        );
                                        setState(() {
                                          isLoading =
                                              false; // Stop loading on error
                                        });
                                      }
                                    },
                                  ),
                        ),
                        Expanded(
                          child: MyGradientButton(
                            hasgrad: true,
                            gradient: kChatBackgroundGradeintColor,
                            buttonText: 'Not now',
                            backgroundColor: kWhite,
                            onTap: () {
                              if (!isLoading) {
                                // Only allow cancel if not loading
                                Get.back();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      barrierDismissible: false, // Prevent dismissing while loading
    );
  }
}
