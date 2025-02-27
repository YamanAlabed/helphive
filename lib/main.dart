import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/services/auth_service.dart';
import 'package:helphive_flutter/core/models/user.dart';
import 'package:helphive_flutter/features/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: 'AIzaSyBDLmC1U0WLu13ZqxqKcQ1XbOLsPh0seok',
          appId: "1:718725089862:web:ecbf2a9f67b829b18b9847",
          messagingSenderId: "718725089862",
          projectId: "helphive-5212c",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    if (kDebugMode) {
      print("✅ Firebase initialized successfully!");
    }
  } catch (e) {
    if (kDebugMode) {
      print("❌ Firebase initialization failed: $e");
    }
  }


  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of  application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        home: const Wrapper(),
      ),
    );
  }
}
