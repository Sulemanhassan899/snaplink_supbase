import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_sizes.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';

class CustomBottomNavigationBarWidget extends StatelessWidget {
  final List<Widget> children;

  const CustomBottomNavigationBarWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.DEFAULT,
      child: AnimatedColumn(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [...children],
      ),
    );
  }
}
