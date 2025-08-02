// // ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_constructors

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
import 'package:snaplink/views/screens/home/home.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/double_white_contianers.dart';
import 'package:snaplink/views/widget/my_button_new.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:snaplink/views/widget/my_textfeild.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeFullName = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfrimPassword = FocusNode();
  final validators = AuthValidations();
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();
  bool _isPasswordObscured = true;
  bool _isConfrimPasswordObscured = true;

 
  void signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final fullName = _fullnameController.text.trim();

    if (email.isEmpty && password.isEmpty && confirmPassword.isEmpty) {
      setState(() {});
      _formKey.currentState?.validate();
      return;
    } else if (email.isEmpty) {
      setState(() {});
      _formKey.currentState?.validate();
      return;
    } else if (password.isEmpty) {
      setState(() {});
      _formKey.currentState?.validate();
      return;
    } else if (confirmPassword.isEmpty) {
      setState(() {});
      _formKey.currentState?.validate();
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (password != confirmPassword) {
      setState(() {});
      _formKey.currentState?.validate();
      return;
    }

    try {
      final user = await _authService.signUpWithEmail(email, password);
      if (user != null) {
        await _authService.updateUserName(fullName);
      }
      if (mounted) {
        Get.offAll(() => HomeScreen());
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
        _formKey.currentState?.validate();
      }
    }
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _focusNodeFullName.dispose();
    _fullnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageContainer(
      imagePath: Assets.imagesBackground,
      child: GestureDetector(
        onTap: () {
          if (_focusNodeEmail.hasFocus ||
              _focusNodePassword.hasFocus ||
              _focusNodeConfrimPassword.hasFocus) {
            _focusNodeEmail.unfocus();
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyText(
                            text: "Get started Free",
                            size: 24,
                            weight: FontWeight.w700,
                          ),
                          MyText(
                            text: "Free forever. No credit card needed.",
                            size: 14,
                            color: kSubText,
                            letterSpacing: 0.05,
                            weight: FontWeight.w400,
                          ),
                          SizedBox(height: 16),
                          MyTextField(
                            hint: "Full Name",
                            marginBottom: 12,
                            controller: _fullnameController,
                            focusNode: _focusNodeFullName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                                return 'Name must not contain special characters';
                              }
                              return null;
                            },
                          ),
                          MyTextField(
                            hint: "Email",
                            marginBottom: 12,
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the email';
                              }
                              return validators.emailValidator(value);
                            },
                            focusNode: _focusNodeEmail,
                          ),

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
                           
                            hint: "Confirm Password",
                             controller: _confirmPasswordController,
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
                            marginBottom: 12,
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
                          MyGradientButton(
                            onTap: signup,
                            buttonText: "Sign Up",
                          ),
                          Gap(24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyText(
                                text: "Already have an account ?",
                                color: kSubText,
                                size: 14,
                                weight: FontWeight.w400,
                              ),
                              MyGradeintText(
                                text: " Sign In",
                                onTap: () {
                                  Get.offAll(() => LoginScreen());
                                },
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
                                text: 'or signup with',
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
                          AuthButtons(
                            onTap: () async {
                              try {
                                final response =
                                    await authService.googleSignIn();
                                if (response.user != null) {
                                  Get.offAll(() => HomeScreen());
                                }
                              } catch (e) {
                              }
                            },
                            img: Assets.imagesGoogle,
                            text: "Continue with Google",
                          ),
                        ],
                      ),
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
