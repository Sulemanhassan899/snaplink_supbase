// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:snaplink/constants/app_background.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/controller/auth_service.dart';
import 'package:snaplink/controller/auth_validtions.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/auth/login.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/double_white_contianers.dart';
import 'package:snaplink/views/widget/my_button_new.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:snaplink/views/widget/my_textfeild.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FocusNode _focusNodeEmail = FocusNode();
  final validators = AuthValidations();
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  bool _isButtonDisabled = false;
  Timer? _timer;
  int _remainingTime = 30;

  void resetPassword() async {
    setState(() {
      _emailError = null;
    });

    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    try {
      _disableButton();
      await _authService.requestresetPassword(email);
      await _authService.configDeeplink();
      _startCountdown();
    } catch (e) {
      if (mounted) {
        setState(() {
          _emailError = 'Please try again.';
          _isButtonDisabled = false;
        });
        _formKey.currentState?.validate();
      }
    }
  }

  void _disableButton() {
    setState(() {
      _isButtonDisabled = true;
      _remainingTime = 30; // Reset the countdown
    });
  }

  void _startCountdown() {
    _timer?.cancel(); // Cancel any existing timer

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--; // Decrease the remaining time by 1 second
        });
      } else {
        timer.cancel(); // Stop the timer once the countdown reaches 0
        setState(() {
          _isButtonDisabled = false; // Re-enable the button
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _emailController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageContainer(
      imagePath: Assets.imagesBackground,
      child: GestureDetector(
        onTap: () {
          if (_focusNodeEmail.hasFocus) {
            _focusNodeEmail.unfocus();
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
                      text: "Forgot Password",
                      size: 24,
                      weight: FontWeight.w700,
                    ),
                    MyText(
                      text:
                          "Enter your email address and we'll\nsend you a link to reset your password.",
                      size: 14,
                      color: kSubText,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w400,
                    ),
                    SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: MyTextField(
                        hint: "Email",
                        marginBottom: 12,
                        controller: _emailController,
                        focusNode: _focusNodeEmail,
                        validator: (value) {
                          final basicValidation = validators.emailValidator(
                            value,
                          );
                          if (basicValidation != null) return basicValidation;
                          if (_emailError != null) return _emailError;
                          return null;
                        },
                        errorText: _emailError,
                      ),
                    ),
                    MyGradientButton(
                      onTap: () {
                        if (!_isButtonDisabled) {
                          resetPassword(); // Trigger password reset if button is enabled
                        }
                      },
                      buttonText:
                          _isButtonDisabled
                              ? "Please wait for $_remainingTime"
                              : "Send",
                    ),
                    Gap(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: "Back to",
                          color: kSubText,
                          size: 14,
                          weight: FontWeight.w400,
                        ),
                        MyGradeintText(
                          text: " Sign In",
                          color: kSubText,
                          onTap: () {
                            Get.offAll(() => LoginScreen());
                          },
                          size: 14,
                          weight: FontWeight.w400,
                        ),
                      ],
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
