import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:snaplink/constants/app_background.dart';
import 'package:snaplink/controller/auth_service.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/dialogs/dialogs.dart';
import 'package:snaplink/views/screens/home/functions_image.dart';
import 'package:snaplink/views/screens/home/home_widgets.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/double_white_contianers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  String? _userEmail;
  late final MediaService mediaService;

  @override
  void initState() {
    super.initState();
    try {
      mediaService = Get.find<MediaService>();
    } catch (e) {
      mediaService = Get.put(MediaService());
    }

    _fetchUserMedia();
    initializeAppLinks();
  }

  Future<void> initializeAppLinks() async {}

  Future<void> _fetchUserMedia() async {
    await mediaService.fetchUserMedia(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImageContainer(
        imagePath: Assets.imagesBackground,
        child: AnimatedListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            const Gap(20),
            GestureDetector(
              onTap: () async {
                DialogHelper.LogoutDialog(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesLogoutButton,
                    height: 32,
                  ),
                  const Gap(20),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: CommonImageView(
                imagePath: Assets.imagesLogoSpell,
                height: 50,
              ),
            ),
            const Gap(30),
            Obx(() {
              // Check if we have any data (either from pagination or uploads)
              final bool hasAnyData =
                  (mediaService.mediaItems.isNotEmpty ||
                      mediaService.uploads.isNotEmpty ||
                      mediaService.hasData.value);

              return DoubleWhiteContainers2(
                child:
                    hasAnyData
                        ? DataBody(mediaService: mediaService)
                        : NoDataBody(mediaService: mediaService),
              );
            }),
          ],
        ),
      ),
    );
  }
}