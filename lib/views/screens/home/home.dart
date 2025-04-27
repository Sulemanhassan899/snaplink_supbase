import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/controller/auth_service.dart';
import 'package:snaplink/views/screens/auth/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() {
    final email = _authService.getCurrentUserEmail();
    setState(() {
      _userEmail = email;
    });
  }

  // function for logout
  void _logout() async {
    await _authService.signOut();
    Get.offAll(() => const LoginScreen());
  }

  final getCurrentUserEmail = AuthService().getCurrentUserEmail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 100),
          const Center(
            child: Text('Profile Screen', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              getCurrentUserEmail.toString(),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
