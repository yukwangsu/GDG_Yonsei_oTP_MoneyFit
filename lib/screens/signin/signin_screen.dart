import 'package:flutter/material.dart';
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
                    onTap: () {
                      SigninService.signin();
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
