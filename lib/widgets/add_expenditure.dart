import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_financemanager/services/notification_service.dart';
import 'package:flutter_financemanager/services/spending_service.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/add_expenditure_select_category.dart';
import 'package:flutter_financemanager/widgets/number_input_format.dart';
import 'package:flutter_financemanager/widgets/select_button.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class AddExpenditure extends StatefulWidget {
  const AddExpenditure({
    super.key,
  });

  @override
  State<AddExpenditure> createState() => _AddExpenditureState();
}

class _AddExpenditureState extends State<AddExpenditure> {
  String selectedCategory = '';
  final TextEditingController amountController =
      TextEditingController(); // 지출 금액 컨트롤러
  final FocusNode _focusNode = FocusNode();
  // // 푸시 알림
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    // 포커스가 변경될 때마다 호출되는 리스너 추가
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 포커스가 풀리면 setState 호출
        setState(() {});
      }
    });

    // // 플러그인 초기화
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher'); // Android 아이콘 설정
    // const InitializationSettings initializationSettings =
    //     InitializationSettings(android: initializationSettingsAndroid);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // // 푸시 알림 보내는 함수
  // Future<void> showNotification() async {
  //   const AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //     'channel_id', // 채널 ID
  //     'channel_name', // 채널 이름
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );

  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidDetails);

  //   await flutterLocalNotificationsPlugin.show(
  //     0, // 알림 ID
  //     '푸시 알림', // 제목
  //     '버튼 클릭 시 표시되는 푸시 알림입니다.', // 내용
  //     notificationDetails,
  //   );
  // }

  // 확인 버튼을 눌렀을 때
  void onClickConfirmButton() async {
    if (selectedCategory.isNotEmpty && amountController.text.isNotEmpty) {
      // 현재 날짜 가져오기(한국 날짜)
      DateTime nowInKorea =
          DateTime.now().toUtc().add(const Duration(hours: 9));
      // 날짜를 원하는 형식으로 포맷팅
      String formattedDate =
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(nowInKorea);
      String month = formattedDate.split('T')[0].split('-')[1];
      String day = formattedDate.split('T')[0].split('-')[2];
      // DateFormat('yyyy-MM-dd').format(nowInKorea);
      // 지출 금액을 int 형식으로 변환
      int amount = int.parse(amountController.text.split(',').join());

      // 지출 추가하는 api 호출
      final isOutlier = await SpendingService.addSpending(
        categoryToUpperMap[selectedCategory]!,
        formattedDate,
        // '2024-10-25T10:26:29',
        amount,
      );
      Navigator.of(context).pop(true);

      // 비정상적인 지출일 경우 푸시 알림 보내기
      if (amount >= 80000 && selectedCategory == '식비') {
        NotificationService().showNotification(
            '$month월 $day일에 $selectedCategory 과소비를 하셨군요. 주의해주세요!');
      }
      // NotificationService().showNotification(
      //     '$month월 $day일에 $selectedCategory 과소비를 하셨군요. 주의해주세요!');
    }
  }

  // 확인 버튼을 길게 눌렀을 때 -> 모델 돌리기
  void onClickConfirmAndMLButton() async {
    // 지출 추가하는 api 호출
    // await SpendingService.addSpending(
    //   'FOOD',
    //   '2024-11-10T09:10:10',
    //   11000,
    // );
    // await SpendingService.addSpending(
    //   'FOOD',
    //   '2024-11-11T09:10:10',
    //   12000,
    // );
    // await SpendingService.addSpending(
    //   'FOOD',
    //   '2024-11-12T09:10:10',
    //   10000,
    // );
    // await SpendingService.addSpending(
    //   'FOOD',
    //   '2024-11-13T09:10:10',
    //   11000,
    // );
    // await SpendingService.addSpending(
    //   'FOOD',
    //   '2024-11-14T09:10:10',
    //   10500,
    // );
    // await SpendingService.addSpending(
    //   'FOOD',
    //   '2024-11-15T09:10:10',
    //   11300,
    // );
    // await SpendingService.addSpending(
    //   'FOOD',
    //   '2024-11-16T09:10:10',
    //   12100,
    // );
    // await SpendingService.addSpending(
    //   'FOOD',
    //   '2024-11-17T09:10:10',
    //   9800,
    // );
    // await SpendingService.addSpending(
    //   'FOOD',
    //   '2024-11-18T09:10:10',
    //   10100,
    // );
    // await SpendingService.addSpending(
    //   'FOOD',
    //   '2024-11-19T09:10:10',
    //   10000,
    // );
    final addSpendingResult = await SpendingService.addSpending(
      'FOOD',
      '2024-11-20T09:10:10',
      300000,
    );

    if (addSpendingResult) {
      print('과거 지출 10개 추가 성공!!!');
    }
    // 화면 돌아가기
    Navigator.of(context).pop(true);

    // 모델 돌리리는 api
    // await SpendingService.createModel();

    // print('####모델 생성 성공####');
  }

  // 취소 버튼을 눌렀을 때
  void onClickCancelButton() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // textfield를 사용할 경우 Dialog사용 필수!!!
      // Dialog: 희려진 부분도 모두 포함
      child: GestureDetector(
        onTap: () {
          // 화면의 다른 곳을 터치할 때 포커스 해제
          FocusScope.of(context).unfocus();
        },
        child: Dialog(
          child: Container(
            width: 301.0,
            height: 223.0, // 수정 필수
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 33.0, bottom: 20.0, left: 33.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '지출 추가하기',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          '카테고리',
                          style: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      categoryButton(),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      // textfield를 사용하기 때문에 expanded가 아닌 SizedBox 사용
                      const SizedBox(
                        width: 117.5,
                        child: Text(
                          '금액',
                          style: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 117.5,
                        child: numberField(amountController, '원'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      cancelButton(),
                      const SizedBox(
                        width: 18.0,
                      ),
                      confirmButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 카테고리 선택하는 버튼
  Widget categoryButton() {
    return Expanded(
      child: SelectButton(
        height: 36.0,
        padding: 0.0,
        bgColor: Colors.white,
        radius: 5,
        text: selectedCategory.isEmpty ? '클릭해서 선택' : selectedCategory,
        textColor: Colors.black,
        textSize: 13.0,
        borderColor: const Color(0xFF8EACCD),
        borderWidth: selectedCategory.isEmpty ? 1.0 : 2.0,
        borderOpacity: 1.0,
        onPress: () async {
          var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddExpenditureSelectCategory();
            },
          );
          if (result != null) {
            setState(() {
              selectedCategory = result;
            });
          }
        },
      ),
    );
  }

  // 숫자 입력칸을 둘러싸고 있는 컨테이너
  Widget numberField(TextEditingController controller, String text) {
    return Container(
      height: 36.0,
      decoration: BoxDecoration(
          border: Border.all(
            width: amountController.text.isNotEmpty ? 2.0 : 1.0,
            color: const Color(0xFF8EACCD),
          ),
          borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        children: [
          // 숫자 입력칸
          Expanded(
            child: numberInput(controller),
          ),
          // 기본 text
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 2.0, left: 2.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 숫자 입력칸
  Widget numberInput(TextEditingController controller) {
    return TextField(
      controller: controller,
      focusNode: _focusNode, // FocusNode를 설정
      keyboardType: TextInputType.number, // 숫자 입력 키보드 설정
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
        NumberInputFormatter() // ',' 추가
      ],
      cursorColor: const Color(0xFFA3A3A3), // 커서 색상 설정
      textAlign: TextAlign.end, // 입력 내용을 오른쪽 정렬
      style: const TextStyle(fontSize: 13.0), // 입력 글자 크기 조절
      decoration: const InputDecoration(
        border: InputBorder.none, //테두리 없음
        isDense: true, // 컴팩트하게 설정
      ),
      onTap: () {
        // 텍스트 필드에 포커스가 갈 때마다 커서를 마지막으로 이동
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
    );
  }

  // 확인 버튼
  Widget confirmButton() {
    return Expanded(
      child: SelectButton(
          height: 31.0,
          padding: 33.0,
          bgColor:
              selectedCategory.isNotEmpty && amountController.text.isNotEmpty
                  ? const Color(0xFFD2E0FB)
                  : const Color.fromARGB(255, 239, 244, 252),
          radius: 5,
          text: '확인',
          textColor:
              selectedCategory.isNotEmpty && amountController.text.isNotEmpty
                  ? Colors.black
                  : Colors.grey,
          textSize: 13.0,
          onPress: () {
            onClickConfirmButton();
          },
          longPress: () {
            onClickConfirmAndMLButton();
          }),
    );
  }

  // 취소 버튼
  Widget cancelButton() {
    return Expanded(
      child: SelectButton(
        height: 31.0,
        padding: 33.0,
        bgColor: const Color(0xFFD9D9D9),
        radius: 5,
        text: '취소',
        textColor: Colors.black,
        textSize: 13.0,
        onPress: () {
          onClickCancelButton();
        },
      ),
    );
  }
}
