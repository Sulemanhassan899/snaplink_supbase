import 'package:app_links/app_links.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snaplink/views/screens/auth/reset_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; // <--- ADD THIS

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AuthService() {
    _initNotifications();
    _requestNotificationPermission();
  }

  //Notifications functions

  void _initNotifications() {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    _notificationsPlugin.initialize(initSettings);
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'reset_password_channel',
          'Password Reset',
          channelDescription: 'Channel for password reset notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }

  //supabase functions

  Future<void> signInWithEmail(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Login failed. Please check your credentials.');
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<void> updateUserName(String name) async {
    await _supabase.auth.updateUser(
      UserAttributes(
        data: {'full_name': name}, 
      ),
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  Future<void> requestresetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'snaplink://reset-password',
      );
      await _showNotification(
        'Password Reset',
        'Password reset link sent to your email.',
      );
    } catch (e) {
      throw Exception('Failed to send reset password email: ${e.toString()}');
    }
  }

  Future<void> configDeeplink() async {
    final appLinks = AppLinks();

    final Uri? initialUri = await appLinks.getInitialAppLink();
    if (initialUri != null && initialUri.host == 'reset-password') {
      Get.to(() => const ResetPasswordScreen());
    }

    appLinks.uriLinkStream.listen((uri) {
      if (uri.host == 'reset-password') {
        Get.to(() => const ResetPasswordScreen());
      }
    });
  }

  Future<void> resetPassword(String NewPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: NewPassword));
    } catch (e) {
      throw Exception('Failed to reset password : ${e.toString()}');
    }
  }

  Future<AuthResponse> googleSignIn() async {
    const webClientId =
        '696549028830-molb7e2f81g4c0k4a63jdop5tp58g738.apps.googleusercontent.com';

    const iosClientId =
        '696549028830-t4qsq1qr66ms38b0oq5ife7l44epbsdr.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  //list  functions

  //uplaoding functions

  //image compressing functions

  //image compressing functions
}





    // MyText(
    //                 text: getCurrentUserEmail.toString(),
    //                 size: 14,
    //                 textAlign: TextAlign.center,
    //                 weight: FontWeight.w400,
    //               ),
