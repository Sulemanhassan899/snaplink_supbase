import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:snaplink/config/routes/routes.dart';
import 'package:snaplink/controller/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://inkjegbhkdahibykusku.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlua2plZ2Joa2RhaGlieWt1c2t1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2ODI0ODAsImV4cCI6MjA2MTI1ODQ4MH0.39U5pCMy4NL67HFGDcmOqIwEBi0VKD4aro2i5AV2yCA',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppLinks.splash_screen,
      getPages: AppRoutes.pages,
      home: AuthGate(),
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
