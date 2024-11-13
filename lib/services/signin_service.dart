import 'package:flutter_financemanager/secrets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SigninService {
  static void signin() async {
    GoogleSignIn().signIn().then((account) async {
      if (account != null) {
        print('Account email: ${account.email}');
        print('Account display name: ${account.displayName}');
        print('Account ID: ${account.id}');
        print('Account photo URL: ${account.photoUrl}');

        final url = Uri.parse('$uri/android/auth/login');

        var headers = {
          'Content-Type': 'application/json',
        };

        var data = {
          "email": account.email,
        };

        var body = jsonEncode(data);

        try {
          final response = await http.post(url, headers: headers, body: body);
          print('----------sign in----------');
          print('Response status: ${response.statusCode}');

          if (response.statusCode >= 200 && response.statusCode < 300) {
            print('로그인 성공');
            print(response.body);
          } else {
            print('로그인 실패');
            print(response.body);
          }
        } catch (e) {
          print('Error during sign in: $e');
        }
      } else {
        print('Sign-in was cancelled.');
      }
    }).catchError((error) {
      print('Sign-in error: $error');
    });
  }
}
