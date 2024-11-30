import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_financemanager/widgets/number_input_format.dart';
import 'package:flutter_financemanager/widgets/select_button.dart';
import 'package:intl/intl.dart';

class EditGoal extends StatefulWidget {
  final int id;

  const EditGoal({
    super.key,
    required this.id,
  });

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  final TextEditingController amountController =
      TextEditingController(); // 목표 금액 컨트롤러
  final FocusNode _focusNode = FocusNode();

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
  }

  // 확인 버튼을 눌렀을 때
  void onClickConfirmButton() async {
    if (amountController.text.isNotEmpty) {
      // 목표 수정하는 api 호출
      // final addSpendingResult = await SpendingService.addSpending(
      //   categoryToUpperMap[selectedCategory]!,
      //   formattedDate,
      //   amount,
      // );
      Navigator.of(context).pop(true);
    }
  }

  // 취소 버튼을 눌렀을 때
  void onClickCancelButton() {
    Navigator.of(context).pop(false);
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
            height: 173.0, // 수정 필수
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
                    '금액 수정하기',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    children: [
                      // textfield를 사용하기 때문에 expanded가 아닌 SizedBox 사용
                      const SizedBox(
                        width: 117.5,
                        child: Text(
                          '변경 금액',
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

  // 변경 버튼
  Widget confirmButton() {
    return Expanded(
      child: SelectButton(
        height: 31.0,
        padding: 33.0,
        bgColor: amountController.text.isNotEmpty
            ? const Color(0xFFD2E0FB)
            : const Color.fromARGB(255, 239, 244, 252),
        radius: 5,
        text: '변경',
        textColor:
            amountController.text.isNotEmpty ? Colors.black : Colors.grey,
        textSize: 13.0,
        onPress: () {
          onClickConfirmButton();
        },
      ),
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
