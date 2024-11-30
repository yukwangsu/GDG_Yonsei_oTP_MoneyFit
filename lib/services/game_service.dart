import 'package:flutter_financemanager/models/badge_model.dart';
import 'package:flutter_financemanager/models/expenditure_model.dart';
import 'package:flutter_financemanager/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GameService {
  // 잔여 포인트 불러오기
  static Future<bool> getLeftPoint() async {
    final url = Uri.parse('$uri/android/points');

    // token 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('moneyfitAccessToken');

    print('*****token: $token*****');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------getLeftPoint----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('getLeftPoint 성공');
        final responseData = json.decode(utf8Body);
        return true;
        // return ExpenditureListModel.fromJson(responseData);
      } else {
        print('getLeftPoint 실패');
        print(response.body);
        throw Error();
      }
    } catch (e) {
      print('Error during getLeftPoint: $e');
      throw Error();
    }
  }

  // 출석
  static Future<bool> attendance() async {
    final url = Uri.parse('$uri/android/points/attendancePoints');

    // token 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('moneyfitAccessToken');

    print('*****token: $token*****');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.put(url, headers: headers);
      print('----------attendance----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('attendance 성공');
        final responseData = json.decode(utf8Body);
        return true;
        // return ExpenditureListModel.fromJson(responseData);
      } else {
        print('attendance 실패');
        print(response.body);
        throw Error();
      }
    } catch (e) {
      print('Error during attendance: $e');
      throw Error();
    }
  }

  // 뽑기
  static Future<bool> gachaService() async {
    // token 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('moneyfitAccessToken');
    print('*****token: $token*****');
    // email 가져오기
    String? email = prefs.getString('moneyfitEmail');

    final url = Uri.parse('$uri/android/points/gatcha10/$email');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.put(url, headers: headers);
      print('----------gachaService----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('gachaService 성공');
        final responseData = json.decode(utf8Body);
        return true;
        // return ExpenditureListModel.fromJson(responseData);
      } else {
        print('gachaService 실패');
        print(response.body);
        throw Error();
      }
    } catch (e) {
      print('Error during gachaService: $e');
      throw Error();
    }
  }

  // (테스트용) 포인트 1000 증가
  static Future<bool> addPoint() async {
    final url = Uri.parse('$uri/android/points/addThousandPoints');

    // token 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('moneyfitAccessToken');

    print('*****token: $token*****');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.put(url, headers: headers);
      print('----------addPoint----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('addPoint 성공');
        final responseData = json.decode(utf8Body);
        return true;
        // return ExpenditureListModel.fromJson(responseData);
      } else {
        print('addPoint 실패');
        print(response.body);
        throw Error();
      }
    } catch (e) {
      print('Error during addPoint: $e');
      throw Error();
    }
  }
}
