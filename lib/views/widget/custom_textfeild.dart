import 'package:flutter/material.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/my_textfeild.dart';

class CustomTextfeild extends StatelessWidget {
  const CustomTextfeild({super.key, required FocusNode focusNodeSearch})
    : _focusNodeSearch = focusNodeSearch;
  final FocusNode _focusNodeSearch;

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      marginBottom: 0,
      focusNode: _focusNodeSearch,
      radius: 10,
      hint: "Search here...",
      keyboardType: TextInputType.text,
      prefix: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: CommonImageView(
          imagePath: Assets.imagesSearchNormal,
          height: 20,
        ),
      ),
    );
  }
}
