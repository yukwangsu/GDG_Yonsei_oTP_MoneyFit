import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
                const SizedBox(
                  height: 125,
                ),
                SvgPicture.asset('assets/icons/logo_signin.svg'),
                const SizedBox(
                  height: 225,
                ),
                IconButton(
                    onPressed: () {
                      GoogleSignIn().signIn().then((account) {
                        if (account != null) {
                          print('Account email: ${account.email}');
                          print('Account display name: ${account.displayName}');
                          print('Account ID: ${account.id}');
                          print('Account photo URL: ${account.photoUrl}');
                        } else {
                          print('Sign-in was cancelled.');
                        }
                      }).catchError((error) {
                        print('Sign-in error: $error');
                      });
                    },
                    icon: SvgPicture.asset('assets/icons/google_signin.svg'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
