import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scholar_chat/pages/chat_page.dart';
import 'package:scholar_chat/pages/login_page.dart';
import 'package:scholar_chat/pages/resgister_page.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ScholarChat());
}

class ScholarChat extends StatefulWidget {
  const ScholarChat({super.key});

  @override
  State<ScholarChat> createState() => _ScholarChatState();
}

class _ScholarChatState extends State<ScholarChat> {
  late Future<FirebaseApp> firebaseInitialization;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  void _initializeFirebase() {
    firebaseInitialization = (Firebase.apps.isEmpty
            ? Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              )
            : Future.value(Firebase.app()))
        .timeout(const Duration(seconds: 20));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        RegisterPage.id: (context) => const RegisterPage(),
        ChatPage.id: (context) => ChatPage(),
      },
      home: FutureBuilder<FirebaseApp>(
        future: firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Could not start Firebase.'),
                      const SizedBox(height: 12),
                      Text(snapshot.error.toString()),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => setState(_initializeFirebase),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Starting Scholar Chat...'),
                  ],
                ),
              ),
            );
          }

          return const LoginPage();
        },
      ),
    );
  }
}
