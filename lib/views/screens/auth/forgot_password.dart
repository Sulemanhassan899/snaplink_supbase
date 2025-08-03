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
import 'package:snaplink/controller/connection_check.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/auth/login.dart';
import 'package:snaplink/views/screens/auth/otp.dart';
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
  bool _isLoading = false; // Loading state for Send button
  Timer? _timer;
  int _remainingTime = 30;

 
  void resetPassword() async {
    // Check internet connection first
    if (!await ConnectionCheck.isInternetAvailable()) {
      ConnectionCheck.showNoInternetDialog(context, "to reset password");
      return;
    }

    if (_isLoading || _isButtonDisabled) return;

    setState(() {
      _emailError = null;
      _isLoading = true; // Start loading
    });

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() {
        _isLoading = false; // Stop loading
      });
      return;
    }

    final email = _emailController.text.trim();

    try {
      _disableButton();
      await _authService.forgotPassword(email); // Updated to use forgotPassword
      _startCountdown();
      setState(() {
        _isLoading = false; // Stop loading
      });

      // Navigate to OTP screen with email
      if (mounted) {
        Get.to(() => OtpScreen(email: email));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _emailError = 'Please try again.';
          _isButtonDisabled = false;
          _isLoading = false;
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
                          "Enter your email address and we'll\nsend you an OTP to reset your password.",
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
                      ),
                    ),
                    // Modified Send Button with Loading State
                    _isLoading
                        ? Container(
                          height: 50, // Match your button height
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.purple,
                              ], // Use your gradient colors
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 2,
                            ),
                          ),
                        )
                        : MyGradientButton(
                          onTap: () {
                            // Always call resetPassword to handle validation
                            resetPassword();
                          },
                          buttonText:
                              _isButtonDisabled
                                  ? "Please wait for $_remainingTime"
                                  : "Send OTP",
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
