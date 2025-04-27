import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/views/widget/my_button_new.dart';

class FollowBackButton extends StatefulWidget {
  const FollowBackButton({super.key});

  @override
  _FollowBackButtonState createState() => _FollowBackButtonState();
}

class _FollowBackButtonState extends State<FollowBackButton> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return MyButton(
      onTap: () {
        setState(() {
          isFollowing = !isFollowing;
        });
      },
      hasgrad: true,
      height: 22,
      width: 80,
      fontSize: 10,
      radius: 4,
      fontColor: isFollowing ? kPrimaryColor : kWhite,
      backgroundColor: isFollowing ? kBorderColor : kPrimaryColor,
      buttonText: isFollowing ? "Message" : "Follow Back",
      fontWeight: FontWeight.w500,
    );
  }
}

class FollowingButton extends StatefulWidget {
  const FollowingButton({super.key});

  @override
  _FollowingButtonState createState() => _FollowingButtonState();
}

class _FollowingButtonState extends State<FollowingButton> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return MyButton(
      onTap: () {
        setState(() {
          isFollowing = !isFollowing;
        });
      },
      hasgrad: true,
      height: 22,
      width: 80,
      fontSize: 10,
      radius: 4,
      fontColor: isFollowing ? kPrimaryColor : kWhite,
      backgroundColor: isFollowing ? kBorderColor : kPrimaryColor,
      buttonText: isFollowing ? "Message" : "Follow Back",
      fontWeight: FontWeight.w500,
    );
  }
}
