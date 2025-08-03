
// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:snaplink/constants/app_background.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/controller/auth_service.dart';
import 'package:snaplink/controller/auth_validtions.dart';
import 'package:snaplink/controller/connection_check.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/dialogs/dialogs.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/double_white_contianers.dart';
import 'package:snaplink/views/widget/my_button_new.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:snaplink/views/widget/my_textfeild.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfrimPassword = FocusNode();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final validators = AuthValidations();
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();
  bool _isPasswordObscured = true; // Toggle for password visibility
  bool _isConfrimPasswordObscured = true; // Toggle for password visibility

void newpassword() async {
  // Check internet connection first
  if (!await ConnectionCheck.isInternetAvailable()) {
    ConnectionCheck.showNoInternetDialog(context, "to reset password");
    return;
  }

  final password = _passwordController.text.trim();
  final confirmPassword = _confirmPasswordController.text.trim();

  if (password.isEmpty || confirmPassword.isEmpty) {
    setState(() {});
    _formKey.currentState?.validate();
    return;
  }

  final isValid = _formKey.currentState?.validate() ?? false;
  if (!isValid) {
    print('Form validation failed');
    return;
  }

  if (password != confirmPassword) {
    setState(() {});
    _formKey.currentState?.validate();
    return;
  }

  try {
    if (password == confirmPassword) {
      // Fixed: Use resetPasswordWithOTP instead of resetPassword
      await _authService.resetPasswordWithOTP(password);
      if (mounted) {
        print('New password is: $password');
        DialogHelper.RestPasswordDialog(context);
      }
    }
  } catch (e, s) {
    print('Error resetting password: $e');
    print('Stacktrace: $s');
    if (mounted) {
      setState(() {});
      _formKey.currentState?.validate();
    }
  }
}

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageContainer(
      imagePath: Assets.imagesBackground,
      child: GestureDetector(
        onTap: () {
          if (_focusNodePassword.hasFocus ||
              _focusNodeConfrimPassword.hasFocus) {
            _focusNodePassword.unfocus();
            _focusNodeConfrimPassword.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              Gap(20),
              Bounce(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesBackWhite,
                      height: 32,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesLogoSpell,
                    height: 50,
                  ),
                ],
              ),
              Gap(30),
              DoubleWhiteContainers2(
                child: AnimatedColumn(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyText(
                      text: "Reset Password", // Fixed typo: "Rest" -> "Reset"
                      size: 24,
                      weight: FontWeight.w700,
                    ),
                    MyText(
                      text: "Set your new password",
                      size: 14,
                      color: kSubText,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w400,
                    ),
                    SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyTextField(
                            hint: "Password",
                            marginBottom: 12,
                            controller: _passwordController,
                            isObSecure:
                                _isPasswordObscured, // Toggle visibility
                            suffix: Bounce(
                              onTap: () {
                                setState(() {
                                  _isPasswordObscured =
                                      !_isPasswordObscured; // Toggle password visibility
                                });
                              },
                              child: CommonImageView(
                                imagePath:
                                    _isPasswordObscured
                                        ? Assets.imagesHide
                                        : Assets.imagesUnhide, // Change icon
                                height: 18,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the password';
                              }
                              return validators.passwordValidator(value);
                            },
                            focusNode: _focusNodePassword,
                          ),

                          MyTextField(
                            controller: _confirmPasswordController,
                            hint: "Confirm Password",
                            marginBottom: 12,
                            isObSecure:
                                _isConfrimPasswordObscured, // Toggle visibility
                            suffix: Bounce(
                              onTap: () {
                                setState(() {
                                  _isConfrimPasswordObscured =
                                      !_isConfrimPasswordObscured; // Toggle password visibility
                                });
                              },
                              child: CommonImageView(
                                imagePath:
                                    _isConfrimPasswordObscured
                                        ? Assets.imagesHide
                                        : Assets.imagesUnhide, // Change icon
                                height: 18,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm Password cannot be empty';
                              }
                              if (value != _passwordController.text) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                            focusNode: _focusNodeConfrimPassword,
                          ),
                        ],
                      ),
                    ),
                    MyGradientButton(
                      onTap: () {
                        newpassword();
                      },
                      buttonText: "Confirm", // Fixed typo: "Confrim" -> "Confirm"
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}