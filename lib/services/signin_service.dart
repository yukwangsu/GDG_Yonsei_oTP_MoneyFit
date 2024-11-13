import 'package:flutter_financemanager/secrets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SigninService {
  // 구글 계정인증하고 구글 계정 이메일로 회원가입 요청
  static Future<bool> signin() async {
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

            //accessToken 저장
            final Map<String, dynamic> responseData =
                json.decode(response.body);
            final prefs = await SharedPreferences.getInstance();
            String accessToken = responseData['accessToken'];
            await prefs.setString('moneyfitAccessToken', accessToken);
            print('AccessToken saved: $accessToken');
            return true;
          } else {
            print('로그인 실패');
            print(response.body);
            return false;
          }
        } catch (e) {
          print('Error during sign in: $e');
          return false;
        }
      } else {
        print('Sign-in was cancelled.');
        return false;
      }
    }).catchError((error) {
      print('Sign-in error: $error');
      return false;
    });
    return false;
  }

  // 구글 계정 이메일을 사용하여 발급 받은 토큰을 사용하여 유저 정보를 입력하여 회원가입 마무리
  static void submitInfo() async {
    final url = Uri.parse('$uri/');

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('moneyfitAccessToken');
    print('*****token: $token*****');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    var data = {};

    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------submitInfo----------');
      print('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('submitInfo 성공');
        print(response.body);
      } else {
        print('submitInfo 실패');
        print(response.body);
      }
    } catch (e) {
      print('Error during submitInfo: $e');
    }
  }
}
