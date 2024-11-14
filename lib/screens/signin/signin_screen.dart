import 'package:flutter/material.dart';
import 'package:flutter_financemanager/screens/main/landing.dart';
import 'package:flutter_financemanager/screens/onboarding/get_info.dart';
import 'package:flutter_financemanager/services/signin_service.dart';
import 'package:flutter_svg/svg.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({
    super.key,
  });

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  // late Future<GoogleSignInAccount?> googleSignInAccount;
  late Future<bool> googleSigninResult;

  // result == -1: error, result == 0: new member, result == 1: existing member
  void checkGoogleSigninResult(int result) async {
    print('signinResult: $result');

    if (result == 0) {
      // result == 0: new member 일 때만 GetInfo로 네비게이션
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GetInfo()),
      );
    } else if (result == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LandingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset('assets/icons/logo_signin.svg'),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 61.0),
                  child: GestureDetector(
                    onTap: () async {
                      final int googleSigninResult = await SigninService
                          .signin(); // signin 작업이 완료될 때까지 기다림
                      checkGoogleSigninResult(
                          googleSigninResult); // 완료된 후 결과 전달
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              // 구글 로고 이미지
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Image.asset(
                                    'assets/images/google_logo.png'),
                              ),
                              // 구글로 시작하기 버튼
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: const Color(0xFFA3A3A3),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: const Center(
                                  child: Text(
                                    'Google로 시작하기',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
