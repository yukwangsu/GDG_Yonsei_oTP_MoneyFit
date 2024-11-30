import 'package:flutter_financemanager/models/badge_model.dart';
import 'package:flutter_financemanager/models/expenditure_model.dart';
import 'package:flutter_financemanager/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GoalService {
  // 목표 추가하기
  static Future<bool> addGoalService(
    String category,
    String date,
    int amount,
  ) async {
    final url = Uri.parse('$uri/android/expense-objective/create');

    // token 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('moneyfitAccessToken');

    print('*****token: $token*****');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var data = {
      'upperCategoryType': category,
      'expenseLimit': amount,
      'targetMonth': date,
    };

    print('addGoalService data: $data');

    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------addGoalService----------');
      print('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('addGoalService 성공');
        print(response.body);
        return true;
      } else {
        print('addGoalService 실패');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error during addGoalService: $e');
      return false;
    }
  }

  // 목표 불러오기
  static Future<bool> getGoalService(
    String date,
  ) async {
    final url = Uri.parse('$uri/android/expense-objective/list/$date');

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
      print('----------getGoalService----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('getGoalService 성공');
        final responseData = json.decode(utf8Body);
        return true;
        // return ExpenditureListModel.fromJson(responseData);
      } else {
        print('getGoalService 실패');
        print(response.body);
        throw Error();
      }
    } catch (e) {
      print('Error during getGoalService: $e');
      throw Error();
    }
  }

  // 목표 수정하기
  static Future<bool> editGoalService(
    int id,
    int amount,
  ) async {
    final url = Uri.parse('$uri/android/expense-objective/update/$id/$amount');

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
      print('----------editGoalService----------');
      print('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('editGoalService 성공');
        print(response.body);
        return true;
      } else {
        print('editGoalService 실패');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error during editGoalService: $e');
      return false;
    }
  }

  // 목표 삭제하기
  static Future<bool> deleteGoalService(
    int id,
  ) async {
    final url = Uri.parse('$uri/android/expense-objective/delete/$id');

    // token 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('moneyfitAccessToken');

    print('*****token: $token*****');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.delete(url, headers: headers);
      print('----------deleteGoalService----------');
      print('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('deleteGoalService 성공');
        print(response.body);
        return true;
      } else {
        print('deleteGoalService 실패');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error during deleteGoalService: $e');
      return false;
    }
  }

  // 획득한 배지 불러오기
  static Future<BadgeListModel> getBadgeService() async {
    final url = Uri.parse('$uri/android/badges/list');

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
      print('----------getBadgeService----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('getBadgeService 성공');
        final responseData = json.decode(utf8Body);
        // return true;
        return BadgeListModel.fromJson(responseData);
      } else {
        print('getBadgeService 실패');
        print(response.body);
        throw Error();
      }
    } catch (e) {
      print('Error during getGoalService: $e');
      throw Error();
    }
  }
}
