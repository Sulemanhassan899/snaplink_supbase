import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:snaplink/constants/app_background.dart';
import 'package:snaplink/views/screens/home/home.dart';
import 'package:snaplink/views/screens/launch/onboarding/on_bording_home.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../generated/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      final session = Supabase.instance.client.auth.currentSession;

      if (session != null) {
        // User is logged in
        Get.offAll(() => const HomeScreen());
      } else {
        // User is not logged in
        Get.offAll(() => const OnBoardingHomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageContainer(
      imagePath: Assets.imagesSplashbg,
      child: Scaffold(
        body: AnimatedColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Animate(
                effects: const [
                  MoveEffect(
                    duration: Duration(milliseconds: 1500),
                    begin: Offset(0, 80),
                  ),
                ],
                child: CommonImageView(
                  imagePath: Assets.imagesLogowithname,
                  height: 120,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
