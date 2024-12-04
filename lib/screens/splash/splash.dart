import 'package:flutter/material.dart';
import 'package:flutter_financemanager/screens/main/landing.dart';
import 'package:flutter_financemanager/screens/onboarding/get_info.dart';
import 'package:flutter_financemanager/screens/signin/signin_screen.dart';
import 'package:flutter_financemanager/services/signin_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // result == -1: error, result == 0: 유저 정보를 입력받아야함, result == 1: existing member, result == 2: 구글로그인 필요
  void checkUser() async {
    // // *** 구글 자동 로그인 방지*** // //
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('moneyfitEmail');
    if (email != null) {
      await prefs.remove('moneyfitEmail');
    }
    // // *** 구글 자동 로그인 방지*** // //

    final result = await SigninService.checkUser();
    // 1.5초간 대기
    await Future.delayed(const Duration(milliseconds: 1500));
    if (result == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GetInfo()),
      );
    } else if (result == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LandingScreen()),
      );
    } else if (result == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SvgPicture.asset('assets/icons/logo_signin.svg'),
      ),
    );
  }
}
