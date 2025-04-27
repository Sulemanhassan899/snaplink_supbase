import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:snaplink/constants/app_background.dart';
import 'package:snaplink/constants/app_sizes.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/auth/login.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/my_button_new.dart';

import 'model/onboarding_model.dart';
import 'on_boarding_widget.dart';

class OnBoardingHomeScreen extends StatefulWidget {
  const OnBoardingHomeScreen({super.key});

  @override
  State<OnBoardingHomeScreen> createState() => _OnBoardingHomeScreenState();
}

class _OnBoardingHomeScreenState extends State<OnBoardingHomeScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get totalPages => onboardingContents.length;

  @override
  Widget build(BuildContext context) {
    return BackgroundImageContainer(
      imagePath: Assets.imagesBackground,
      child: Scaffold(
        body: AnimatedColumn(
          children: [
            const Gap(50),
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemCount: onboardingContents.length,
                controller: _pageController,
                itemBuilder: (context, index) {
                  return AnimatedColumn(
                    children: [
                      Container(
                        height: 600,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.imagesContianerWhite1),
                          ),
                        ),
                        child: AnimatedColumn(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    index == 0
                                        ? Assets.imagesOnboarding1
                                        : index == 1
                                        ? Assets.imagesOnboarding2
                                        : Assets.imagesOnboarding3,
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            Center(
                              child: OnBoardingWidget(
                                description: onboardingContents[index].txt,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            AnimatedRow(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(onboardingContents.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: DotIndicator(isActive: index == _pageIndex),
                );
              }),
            ),
            const Gap(20),
            Padding(
              padding: AppSizes.HORIZONTAL,
              child: MyButton(
                onTap: () {
                  if (_pageIndex < onboardingContents.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Get.to(() => const LoginScreen());
                  }
                },
                hasgrad: true,

                buttonText: "Get Started",
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
