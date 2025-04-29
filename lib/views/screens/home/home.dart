import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:snaplink/constants/app_background.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/controller/auth_service.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/auth/login.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/double_white_contianers.dart';
import 'package:snaplink/views/widget/my_button_new.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() {
    final email = _authService.getCurrentUserEmail();
    setState(() {
      _userEmail = email;
    });
  }

  // function for logout
  void _logout() async {
    await _authService.signOut();
    Get.offAll(() => const LoginScreen());
  }

  final getCurrentUserEmail = AuthService().getCurrentUserEmail();

  @override
  Widget build(BuildContext context) {
    return BackgroundImageContainer(
      imagePath: Assets.imagesBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: [
            Gap(20),
            Bounce(
              onTap: () {
                _logout();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesLogoutButton,
                    height: 32,
                  ),
                  Gap(20),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonImageView(imagePath: Assets.imagesLogoSpell, height: 50),
              ],
            ),
            Gap(20),
            DoubleWhiteContainers2(
              child: AnimatedColumn(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesHomeMainUpload,
                    height: 300,
                  ),
                  MyText(
                    text: "Let’s Upload you image",
                    size: 18,
                    weight: FontWeight.w700,
                  ),
                  MyText(
                    text:
                        "Instant image sharing\nDive in by uploading your image",
                    size: 14,
                    color: kSubText,
                    paddingTop: 10,
                    paddingBottom: 10,
                    textAlign: TextAlign.center,
                    weight: FontWeight.w400,
                  ),
                  MyGradientButton(onTap: () {}, buttonText: "Upload Image"),
              
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
