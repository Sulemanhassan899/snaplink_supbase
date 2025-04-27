import 'package:bounce/bounce.dart';
import 'package:snaplink/constants/app_fonts.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:snaplink/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FadeEffect(duration: Duration(milliseconds: 500))],
      child: AnimatedColumn(
        children: [
          AppBar(
            backgroundColor: kTransperentColor,
            title: const AnimatedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: "Welcome",
                  size: 14,
                  weight: FontWeight.w400,
                  textAlign: TextAlign.start,
                  fontFamily: AppFonts.Nunito,
                ),
                MyText(
                  text: "John Doe",
                  size: 18,
                  weight: FontWeight.w400,
                  textAlign: TextAlign.start,
                  fontFamily: AppFonts.Nunito,
                ),
              ],
            ),
            actions: [
              Bounce(
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: CommonImageView(
                    imagePath: Assets.imagesBellWhite,
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  String title;
  final Widget? bottomChild;

  CustomAppBar2({super.key, required this.title, this.bottomChild});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FadeEffect(duration: Duration(milliseconds: 500))],
      child: AnimatedColumn(
        children: [
          AppBar(
            backgroundColor: kTransperentColor,
            title: MyText(
              text: title,
              size: 18,
              weight: FontWeight.w400,
              textAlign: TextAlign.start,
              fontFamily: AppFonts.Nunito,
            ),
            actions: [
              Bounce(
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: CommonImageView(
                    imagePath: Assets.imagesBellWhite,
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
