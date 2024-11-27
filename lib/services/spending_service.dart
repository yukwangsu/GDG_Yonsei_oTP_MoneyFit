import 'package:flutter_financemanager/models/category_expenditure.dart';
import 'package:flutter_financemanager/models/expenditure_model.dart';
import 'package:flutter_financemanager/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SpendingService {
  //지출 추가하기
  static Future<bool> addSpending(
    String category,
    String date,
    int amount,
  ) async {
    final url = Uri.parse('$uri/android/spending/create');

    // token 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('moneyfitAccessToken');

    print('*****token: $token*****');

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    print('expenditure date:$date');

    var data = {
      'upperCategoryType': category,
      'dateTime': date,
      'expenseAmount': amount,
    };

    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------addSpending----------');
      print('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('addSpending 성공');
        print(response.body);
        return true;
      } else {
        print('addSpending 실패');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error during addSpending: $e');
      return false;
    }
  }

  //최근 지출 불러오기
  static Future<ExpenditureListModel> getSpending() async {
    final url = Uri.parse('$uri/android/spending/latest-spendings/10/0');

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
      print('----------getSpending----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('getSpending 성공');
        final responseData = json.decode(utf8Body);
        return ExpenditureListModel.fromJson(responseData);
      } else {
        print('getSpending 실패');
        print(response.body);
        throw Error();
      }
    } catch (e) {
      print('Error during getSpending: $e');
      throw Error();
    }
  }

  // 카테고리별 이번달 총 소비 금액
  static Future<CategoryExpenditureListModel> getCategoryMonthlySpending(
    String year,
    String month,
  ) async {
    final url = Uri.parse(
        '$uri/android/spending/category-monthly-summary/$year/$month');

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
      print('----------getCategoryMonthlySpending----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('getCategoryMonthlySpending 성공');
        final responseData = json.decode(utf8Body);
        return CategoryExpenditureListModel.fromJson(responseData);
      } else {
        print('getCategoryMonthlySpending 실패');
        print(response.body);
        throw Error();
      }
    } catch (e) {
      print('Error during getCategoryMonthlySpending: $e');
      throw Error();
    }
  }

  // 한달 총 소비 금액
  static Future<double> getMonthlySpending(
    String year,
    String month,
  ) async {
    final url = Uri.parse('$uri/android/spending/monthly-expense/$year/$month');

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
      print('----------getMonthlySpending----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('getMonthlySpending 성공');
        final responseData = json.decode(utf8Body);
        return responseData;
      } else {
        print('getMonthlySpending 실패');
        print(response.body);
        throw Error();
      }
    } catch (e) {
      print('Error during getMonthlySpending: $e');
      throw Error();
    }
  }
}
