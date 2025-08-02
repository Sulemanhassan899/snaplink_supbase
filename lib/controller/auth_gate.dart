import 'package:flutter/material.dart';
import 'package:snaplink/views/screens/home/home.dart';
import 'package:snaplink/views/screens/auth/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Stream<AuthState> _authStateStream;
  Session? _session;

  @override
  void initState() {
    super.initState();
    _session = Supabase.instance.client.auth.currentSession;
    _authStateStream = Supabase.instance.client.auth.onAuthStateChange;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _authStateStream,
      builder: (context, snapshot) {
        // If there is already a session OR if the stream says there is a session
        final session = snapshot.data?.session ?? _session;

        if (snapshot.connectionState == ConnectionState.waiting &&
            session == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (session != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
