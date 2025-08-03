

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
import 'package:snaplink/views/screens/auth/forgot_password.dart';
import 'package:snaplink/views/screens/auth/signup.dart';
import 'package:snaplink/views/screens/home/home.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/double_white_contianers.dart';
import 'package:snaplink/views/widget/my_button_new.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:snaplink/views/widget/my_textfeild.dart';
import 'package:snaplink/views/screens/auth/notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final validators = AuthValidations();
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  String? _passwordError;
  final authService = AuthService();
  bool _isPasswordObscured = true; // Toggle for password visibility
  bool _isLoading = false; // Loading state for Sign In button
  bool _isGoogleLoading = false; // Loading state for Google Sign In button

 

void login() async {
  // Check internet connection first
  if (!await ConnectionCheck.isInternetAvailable()) {
    ConnectionCheck.showNoInternetDialog(context, "to sign in");
    return;
  }

  // Prevent multiple clicks
  if (_isLoading) return;

  setState(() {
    _emailError = null;
    _passwordError = null;
    _isLoading = true; // Start loading
  });

  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  if (email.isEmpty && password.isEmpty) {
    setState(() {
      _emailError = 'Please enter the email';
      _passwordError = 'Please enter the password';
      _isLoading = false; // Stop loading
    });
    _formKey.currentState?.validate();
    return;
  } else if (email.isEmpty) {
    setState(() {
      _emailError = 'Please enter the email';
      _isLoading = false; // Stop loading
    });
    _formKey.currentState?.validate();
    return;
  } else if (password.isEmpty) {
    setState(() {
      _passwordError = 'Please enter the password';
      _isLoading = false; // Stop loading
    });
    _formKey.currentState?.validate();
    return;
  }

  final isValid = _formKey.currentState?.validate() ?? false;
  if (!isValid) {
    setState(() {
      _isLoading = false; // Stop loading
    });
    return;
  }

  try {
    await _authService.signInWithEmail(email, password);
    if (mounted) {
      Get.offAll(() => HomeScreen());
      NotificationService.showNotification(body: 'Signed in successfully');
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _emailError = 'Incorrect email';
        _passwordError = 'Incorrect password';
        _isLoading = false; // Stop loading
      });
      _formKey.currentState?.validate();
      NotificationService.showNotification(
        body: 'Incorrect email or password',
      );
    }
  }
}

void googleSignIn() async {
  // Check internet connection first
  if (!await ConnectionCheck.isInternetAvailable()) {
    ConnectionCheck.showNoInternetDialog(context, "to sign in");
    return;
  }

  // Prevent multiple clicks
  if (_isGoogleLoading) return;

  setState(() {
    _isGoogleLoading = true; // Start loading
  });

  try {
    final response = await authService.googleSignIn();
    if (response.user != null) {
      Get.offAll(() => HomeScreen());
      NotificationService.showNotification(
        body: 'Signed in successfully',
      );
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _isGoogleLoading = false; // Stop loading
      });
      NotificationService.showNotification(
        body: e.toString(),
      );
    }
  }
}


  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageContainer(
      imagePath: Assets.imagesBackground,
      child: GestureDetector(
        onTap: () {
          if (_focusNodeEmail.hasFocus || _focusNodePassword.hasFocus) {
            _focusNodeEmail.unfocus();
            _focusNodePassword.unfocus();
          }
        },
        child: Scaffold(
          body: AnimatedListView(
            children: [
              Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesLogoSpell,
                    height: 50,
                  ),
                ],
              ),
              DoubleWhiteContainers(
                child: AnimatedColumn(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyText(text: "Sign In", size: 24, weight: FontWeight.w700),
                    SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyTextField(
                            hint: "Email",
                            marginBottom: 12,
                            controller: _emailController,
                            focusNode: _focusNodeEmail,
                            validator: (value) {
                              final basicValidation = validators.emailValidator(
                                value,
                              );
                              if (basicValidation != null)
                                return basicValidation;
                              if (_emailError != null) return _emailError;
                              return null;
                            },
                          ),
                          MyTextField(
                            hint: "Password",
                            marginBottom: 12,
                            controller: _passwordController,
                            focusNode: _focusNodePassword,
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
                              final basicValidation = validators
                                  .passwordValidator(value);
                              if (basicValidation != null)
                                return basicValidation;
                              if (_passwordError != null) return _passwordError;
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    // Modified Sign In Button with Loading State
                    _isLoading
                        ? Container(
                            height: 50, // Match your button height
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.purple], // Use your gradient colors
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : MyGradientButton(onTap: login, buttonText: "Sign In"),
                    MyText(
                      text: "Forgot Your Password?",
                      color: kSubText,
                      size: 14,
                      onTap: () {
                        Get.to(() => ForgotPasswordScreen());
                      },
                      paddingTop: 16,
                      paddingBottom: 24,
                      weight: FontWeight.w500,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: "Doesn't have an account ?",
                          color: kSubText,
                          size: 14,
                          weight: FontWeight.w400,
                        ),
                        MyGradeintText(
                          onTap: () {
                            Get.to(() => SignUpScreen());
                          },
                          text: " Sign up",
                          color: kSubText,
                          size: 14,
                          weight: FontWeight.w400,
                        ),
                      ],
                    ),
                    const Gap(30),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            height: 1,
                            color: kDividerColor,
                          ),
                        ),
                        MyText(
                          text: 'or sign in with',
                          size: 14,
                          letterSpacing: 0.5,
                          weight: FontWeight.w400,
                          color: kSubText,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            height: 1,
                            color: kDividerColor,
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    // Modified Google Sign In Button with Loading State
                    _isGoogleLoading
                        ? Container(
                            height: 50, // Match your AuthButtons height
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : AuthButtons(
                            onTap: googleSignIn,
                            img: Assets.imagesGoogle,
                            text: "Continue with Google",
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