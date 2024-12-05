import 'package:flutter/material.dart';
import 'package:flutter_financemanager/screens/splash/splash.dart';
import 'package:flutter_financemanager/services/notification_service.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() async {
  // 앱 실행 전에 NotificationService 인스턴스 생성
  final notificationService = NotificationService();
  WidgetsFlutterBinding.ensureInitialized();
  // 로컬 푸시 알림 초기화
  await notificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      // theme: ThemeData(
      //   textTheme: GoogleFonts.interTextTheme(),
      // ),
    );
  }
}
