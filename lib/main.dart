// ignore_for_file: duplicate_import

import 'package:cbsapperals/auth/supplier_login.dart';
import 'package:cbsapperals/auth/supplier_signup.dart';
import 'package:cbsapperals/main_screens/supplier_home.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';






import 'main_screens/flash.dart';
// import 'firebase_options.dart';


import 'main_screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding_screen',
      routes: {
        '/flash_screen': (context) => const FlashScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/supplier_signup': (context) => const SupplierRegister(),
        '/supplier_login': (context) => const SupplierLogin(),
        '/onboarding_screen': (context) => const Onboardingscreen(),
      },
    );
  }
}
