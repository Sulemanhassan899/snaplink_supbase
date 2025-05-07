import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:snaplink/constants/app_background.dart';
import 'package:snaplink/controller/auth_service.dart';
import 'package:snaplink/controller/model_classs.dart';
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
  final mediaService = Get.put(MediaService());
  final PagingController<int, MediaItem> pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void initState() {
    super.initState();
    _fetchUserMedia();
    initializeAppLinks();
  }

  Future<void> initializeAppLinks() async {
    // Implementation will go here
  }

  Future<void> _fetchUserMedia() async {
    await mediaService.fetchUserMedia(page: pagingController.nextPageKey ?? 1);
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
            DoubleWhiteContainers2(
              child: Obx(() {
                if (mediaService.mediaItems.isNotEmpty) {
                  return DataBody(mediaService: mediaService);
                } else {
                  return NoDataBody(mediaService: mediaService);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
