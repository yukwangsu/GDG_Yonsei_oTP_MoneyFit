import 'package:flutter/material.dart';
import 'package:flutter_financemanager/screens/main/home.dart';
import 'package:flutter_financemanager/screens/main/landing.dart';
import 'package:flutter_financemanager/screens/onboarding/get_info.dart';
import 'package:flutter_financemanager/screens/signin/signin_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SigninScreen(),
      // theme: ThemeData(
      //   textTheme: GoogleFonts.interTextTheme(),
      // ),
    );
  }
}
