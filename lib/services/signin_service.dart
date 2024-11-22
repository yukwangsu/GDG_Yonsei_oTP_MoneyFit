import 'package:flutter_financemanager/secrets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SigninService {
  // 구글 계정인증하고 구글 계정 이메일로 회원가입 요청
  static Future<int> signin() async {
    // 로그아웃
    await GoogleSignIn().signOut();
    final GoogleSignInAccount? account = await GoogleSignIn().signIn();

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

          // accessToken 저장
          final Map<String, dynamic> responseData = json.decode(response.body);
          final prefs = await SharedPreferences.getInstance();
          String accessToken = responseData['accessToken'];
          await prefs.setString('moneyfitAccessToken', accessToken);
          print('AccessToken saved: $accessToken');
          // email 저장
          String email = account.email;
          await prefs.setString('moneyfitEmail', email);
          // newMember 인지 확인
          bool isNewMember = responseData['newMember'];

          if (isNewMember) {
            return 0;
          } else {
            return 1;
          }
        } else {
          print('로그인 실패');
          print(response.body);
          return -1;
        }
      } catch (e) {
        print('Error during sign in: $e');
        return -1;
      }
    } else {
      print('Sign-in was cancelled.');
      return -1;
    }
  }

  static Future<int> checkUser() async {
    final url = Uri.parse('$uri/android/auth/login');

    var headers = {
      'Content-Type': 'application/json',
    };

    // email 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('moneyfitEmail');

    // // 새로운 유저 test 용
    // // email 가져오기
    // final prefs = await SharedPreferences.getInstance();
    // String? email = prefs.getString('moneyfitEmail2');

    if (email == null) {
      print('google 로그인이 필요한 사용자');
      return 2;
    }

    var data = {
      "email": email,
    };

    var body = jsonEncode(data);

    print('google 로그인 성공');

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------checkUser----------');
      print('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('checkUser 성공');
        print(response.body);

        // accessToken 저장
        final Map<String, dynamic> responseData = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        String accessToken = responseData['accessToken'];
        await prefs.setString('moneyfitAccessToken', accessToken);
        print('AccessToken saved[엑세스 토큰 저장]: $accessToken');
        // newMember 인지 확인
        bool isNewMember = responseData['newMember'];

        if (isNewMember) {
          print('google 로그인을 했지만 유저 정보입력을 완료하지 않은 사용자');
          return 0;
        } else {
          print('google 로그인, 유저 정보입력을 완료한 사용자');
          return 1;
        }
      } else {
        print('error');
        print(response.body);
        return -1;
      }
    } catch (e) {
      print('Error during checkUser: $e');
      return -1;
    }
  }

  static String setGender(String gender) {
    if (gender == '남성') {
      return 'MALE';
    } else {
      return 'FEMALE';
    }
  }

  static String setIncome(String income) {
    if (int.parse(income) < 100) {
      return 'LOW';
    } else if (int.parse(income) < 200) {
      return 'MEDIUM';
    } else {
      return 'HIGH';
    }
  }

  static String setJob(String job) {
    if (job == '학생') {
      return 'STUDENT';
    } else {
      return 'WORKER';
    }
  }

  // 구글 계정 이메일을 사용하여 발급 받은 토큰을 사용하여 유저 정보를 입력하여 회원가입 마무리
  static Future<bool> submitInfo(
    String name,
    String selectedGender,
    String income,
    String selectedJob,
  ) async {
    final url = Uri.parse('$uri/android/member/create');

    // token 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('moneyfitAccessToken');
    // email 가져오기
    String? email = prefs.getString('moneyfitEmail');

    print('*****token: $token*****');
    print('*****email: $email*****');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    print(
        'name: $name, email: $email, gender: ${setGender(selectedGender)}, incomeLevel: ${setIncome(income)}, dateOfBirth: 2000-01-01, job: ${setJob(selectedJob)},');

    var data = {
      'name': name,
      'email': email,
      'gender': setGender(selectedGender),
      'incomeLevel': setIncome(income),
      'dateOfBirth': '2000-01-01',
      'job': setJob(selectedJob),
    };

    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------submitInfo----------');
      print('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('submitInfo 성공');
        print(response.body);
        return true;
      } else {
        print('submitInfo 실패');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error during submitInfo: $e');
      return false;
    }
  }
}
