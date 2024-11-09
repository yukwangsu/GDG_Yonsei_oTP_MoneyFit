import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_financemanager/screens/main/landing.dart';
import 'package:flutter_financemanager/widgets/select_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetInfo extends StatefulWidget {
  const GetInfo({super.key});

  @override
  State<GetInfo> createState() => _GetInfoState();
}

class _GetInfoState extends State<GetInfo> {
  final TextEditingController nameController =
      TextEditingController(); // 닉네임 컨트롤러
  final TextEditingController incomeController =
      TextEditingController(); // 월간소득 컨트롤러
  final TextEditingController ageController =
      TextEditingController(); // 나이 컨트롤러
  String selectedGender = '';
  String selectedJob = '';
  int income = -1;
  int age = -1;

  //다음 버튼을 눌렀을 때
  void onClickButtonHandler() {
    if (nameController.text.isNotEmpty &&
        incomeController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        selectedGender.isNotEmpty &&
        selectedJob.isNotEmpty) {
      // 추후 추가
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LandingScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면 자동 조정
      backgroundColor: Colors.white,
      body: GestureDetector(
        // 빈공간을 터치해도 인식
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // 화면의 다른 곳을 터치할 때 포커스 해제
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              //빈공간
              SizedBox(height: (MediaQuery.of(context).size.height - 600) / 3),
              // 1. 앱 로고
              SizedBox(
                height: 183, // 높이 고정
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: SvgPicture.asset('assets/icons/logo.svg'),
                    ),
                    const SizedBox(
                      height: 47.0,
                    ),
                  ],
                ),
              ),
              // 2. 사용자 정보 입력
              SizedBox(
                height: 416, // 높이 고정
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 46.0),
                    child: Column(
                      children: [
                        //2-1 닉네임 입력
                        Column(
                          children: [
                            inputTitle('닉네임'),
                            textField(nameController),
                            const SizedBox(
                              height: 3.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //추후 수정
                                checkName('사용 가능한 닉네임입니다.'),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 14.0,
                        ),
                        //2-2 성별
                        inputTitle('성별'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: genderButton('여자'),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: genderButton('남자'),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 33.0,
                        ),
                        //2-3 직업
                        inputTitle('직업'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: jobButton('학생'),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: jobButton('직장인'),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 33.0,
                        ),
                        //2-4 월간 소득, 나이
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  inputTitle('월간소득'),
                                  numberField(incomeController, '만원'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  inputTitle('나이'),
                                  numberField(ageController, '세'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 3. 시작하기 버튼
              SizedBox(
                //빈공간
                height: (MediaQuery.of(context).size.height - 600) * 2 / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 31.0),
                          child: GestureDetector(
                            onTap: () {
                              //시작 버튼을 눌렀을 때
                              onClickButtonHandler();
                            },
                            child: Text(
                              '시작하기',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: (nameController.text.isNotEmpty &&
                                          incomeController.text.isNotEmpty &&
                                          ageController.text.isNotEmpty &&
                                          selectedGender.isNotEmpty)
                                      ? Colors.black
                                      : const Color(0xFFA3A3A3)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50.0,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //제목 텍스트 위젯
  Widget inputTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 10.0),
      child: Row(
        children: [
          Text(
            title,
            // style: GoogleFonts.inter(fontSize: 17.0, fontWeight: FontWeight.w400),
            style: const TextStyle(fontSize: 17.0),
          )
        ],
      ),
    );
  }

  //알림 텍스트 위젯
  Widget checkName(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 13.0,
        color: Color(0xFFA3A3A3),
      ),
    );
  }

  // 문자 입력칸
  Widget textField(TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: const Color(0xFFA3A3A3), // 커서 색상 설정
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // 둥근 테두리 설정
            borderSide: const BorderSide(color: Color(0xFFA3A3A3)), // 기본 테두리 색상
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // 둥근 테두리 유지
            borderSide:
                const BorderSide(color: Color(0xFFA3A3A3)), // 포커스 상태에서도 같은 색 유지
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 15.0,
          ) //글자와 textfield 사이에 padding
          ),
    );
  }

  // 숫자 입력칸을 둘러싸고 있는 컨테이너
  Widget numberField(TextEditingController controller, String text) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: const Color(0xFFA3A3A3),
          ),
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: [
          // 숫자 입력칸
          Expanded(
            child: numberInput(controller),
          ),
          // 기본 text
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 3.0, left: 2.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 17.0,
                color: Color(0xFFA3A3A3),
                height: 20 / 17,
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
      keyboardType: TextInputType.number, // 숫자 입력 키보드 설정
      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 숫자만 입력 가능
      cursorColor: const Color(0xFFA3A3A3), // 커서 색상 설정
      textAlign: TextAlign.end, // 입력 내용을 오른쪽 정렬
      decoration: const InputDecoration(
        border: InputBorder.none, //테두리 없음
      ),
      onTap: () {
        // 텍스트 필드에 포커스가 갈 때마다 커서를 마지막으로 이동
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
    );
  }

  // 성별 고르는 버튼
  Widget genderButton(String gender) {
    return SelectButton(
        height: 40.0,
        padding: 0,
        bgColor: Colors.white,
        radius: 10,
        text: gender,
        textColor:
            gender == selectedGender ? Colors.black : const Color(0xFFA3A3A3),
        textSize: 17.0,
        borderColor: gender == selectedGender
            ? const Color(0xFF8EACCD)
            : const Color(0xFFA3A3A3),
        borderWidth: gender == selectedGender ? 3.0 : 1.0,
        borderOpacity: 1.0,
        onPress: () {
          setState(() {
            selectedGender = gender;
          });
        });
  }

  // 직업 고르는 버튼
  Widget jobButton(String job) {
    return SelectButton(
        height: 40.0,
        padding: 0,
        bgColor: Colors.white,
        radius: 10,
        text: job,
        textColor: job == selectedJob ? Colors.black : const Color(0xFFA3A3A3),
        textSize: 17.0,
        borderColor: job == selectedJob
            ? const Color(0xFF8EACCD)
            : const Color(0xFFA3A3A3),
        borderWidth: job == selectedJob ? 3.0 : 1.0,
        borderOpacity: 1.0,
        onPress: () {
          setState(() {
            selectedJob = job;
          });
        });
  }
}
