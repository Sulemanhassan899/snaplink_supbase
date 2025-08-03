import 'dart:async';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:snaplink/constants/app_background.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/controller/auth_service.dart';
import 'package:snaplink/controller/connection_check.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/screens/auth/reset_password.dart';
import 'package:snaplink/views/screens/auth/notification_service.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/double_white_contianers.dart';
import 'package:snaplink/views/widget/my_button_new.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _authService = AuthService();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResendDisabled = false;
  Timer? _timer;
  int _remainingTime = 60;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _isResendDisabled = true;
      _remainingTime = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResendDisabled = false;
        });
      }
    });
  }

void _verifyOtp() async {
  // Check internet connection first
  if (!await ConnectionCheck.isInternetAvailable()) {
    ConnectionCheck.showNoInternetDialog(context, "to verify OTP");
    return;
  }

  if (_isLoading) return;

  final otp = _otpController.text.trim();
  
  if (otp.isEmpty || otp.length != 6) {
    setState(() {
      _otpError = 'Please enter a valid 6-digit OTP';
    });
    return;
  }

  setState(() {
    _isLoading = true;
    _otpError = null;
  });

  try {
    await _authService.verifyResetWithOTP(widget.email, otp);
    
    if (mounted) {
      NotificationService.showNotification(body: 'OTP verified successfully');
      Get.to(() => ResetPasswordScreen());
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _otpError = 'Invalid OTP. Please try again.';
        _isLoading = false;
      });
      NotificationService.showNotification(body: 'Invalid OTP. Please try again.');
    }
  }
}

void _resendOtp() async {
  // Check internet connection first
  if (!await ConnectionCheck.isInternetAvailable()) {
    ConnectionCheck.showNoInternetDialog(context, "to resend OTP");
    return;
  }

  if (_isResendDisabled) return;

  try {
    await _authService.forgotPassword(widget.email);
    _startResendTimer();
    NotificationService.showNotification(body: 'OTP resent to your email');
  } catch (e) {
    NotificationService.showNotification(body: 'Failed to resend OTP');
  }
}

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageContainer(
      imagePath: Assets.imagesBackground,
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
                    text: "OTP Verification",
                    size: 24,
                    weight: FontWeight.w700,
                    color: kBlack,
                  ),
                  SizedBox(height: 8),
                  MyText(
                    text: "Enter OTP sent to ${widget.email}\nto verify your account",
                    size: 14,
                    color: kSubText,
                    textAlign: TextAlign.center,
                    weight: FontWeight.w400,
                  ),
                  SizedBox(height: 24),
                  
                  // OTP Input Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 2,
                        color: _otpError != null ? kredColor : Colors.transparent,
                      ),
                    ),
                    child: Pinput(
                      controller: _otpController,
                      length: 6,
                      onChanged: (value) {
                        if (_otpError != null) {
                          setState(() {
                            _otpError = null;
                          });
                        }
                      },
                      defaultPinTheme: PinTheme(
                        width: 48,
                        height: 56,
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: kBlack,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kSubText.withOpacity(0.3),
                            width: 2,
                          ),
                          color: kWhite,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 48,
                        height: 56,
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: kBlack,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: kPrimaryColor,
                            width: 2,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                      ),
                      submittedPinTheme: PinTheme(
                        width: 48,
                        height: 56,
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: kBlack,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          border: Border.all(
                            color: kPrimaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                      ),
                      errorPinTheme: PinTheme(
                        width: 48,
                        height: 56,
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: kredColor,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kredColor,
                            width: 2,
                          ),
                          color: kWhite,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                  ),
                  
                  // Error message
                  if (_otpError != null)
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: MyText(
                        text: _otpError!,
                        size: 12,
                        color: kredColor,
                        textAlign: TextAlign.center,
                        weight: FontWeight.w400,
                      ),
                    ),
                  
                  SizedBox(height: 24),
                  
                  // Timer and Resend
                  GestureDetector(
                    onTap: _isResendDisabled ? null : _resendOtp,
                    child: AnimatedRow(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isResendDisabled) ...[
                          MyText(
                            text: _formatTime(_remainingTime),
                            size: 14,
                            color: kSubText,
                            weight: FontWeight.w400,
                          ),
                          MyText(
                            text: " until resend",
                            size: 14,
                            color: kSubText,
                            weight: FontWeight.w400,
                          ),
                        ] else ...[
                          MyText(
                            text: "Didn't receive OTP? ",
                            size: 14,
                            color: kSubText,
                            weight: FontWeight.w400,
                          ),
                          MyGradeintText(
                            text: "Resend",
                            size: 14,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Confirm Button with Loading State
                  _isLoading
                      ? Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.purple],
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
                      : MyGradientButton(
                          onTap: _verifyOtp,
                          buttonText: "Confirm",
                        ),
                  
                  Gap(24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}