import 'package:flutter/material.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/select_button.dart';

class EditComparisonCategory extends StatefulWidget {
  final List<String> currentCategoryList;

  const EditComparisonCategory({
    super.key,
    required this.currentCategoryList,
  });

  @override
  State<EditComparisonCategory> createState() => _EditComparisonCategoryState();
}

class _EditComparisonCategoryState extends State<EditComparisonCategory> {
  List<String> selectedCategoryList = [];

  @override
  void initState() {
    super.initState();
    selectedCategoryList = List.from(widget.currentCategoryList);
    print(selectedCategoryList);
  }

  // 확인 버튼을 눌렀을 때
  void onClickConfirmButton() {
    Navigator.of(context).pop(selectedCategoryList);
  }

  // 취소 버튼을 눌렀을 때
  void onClickCancelButton() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 301.0,
        // height: 335.0, // 수정 필수
        height: 333.0,
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
                '지출 카테고리',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 18.0,
              ),
              Wrap(
                direction: Axis.horizontal,
                spacing: 5.0,
                runSpacing: 5.0,
                children: [
                  for (int i = 0; i < categoryList.length; i++)
                    categoryButton(categoryList[i]),
                ],
              ),
              const SizedBox(
                height: 25.0,
              ),
              Row(
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
    );
  }

  // 카테고리 선택지
  Widget categoryButton(String name) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (selectedCategoryList.contains(name)) {
            selectedCategoryList.remove(name);
          } else {
            selectedCategoryList.add(name);
          }
        });
      },
      child: Stack(
        children: [
          SizedBox(
            width: 55.0,
            height: 62.0,
            child: Column(
              children: [
                const SizedBox(
                  height: 6.0,
                ),
                Image.asset(
                    'assets/images/select_category/${categoryIconNameMap[name]}.png'),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ),
          // 선택 됐을 때 테두리 생성
          if (selectedCategoryList.contains(name))
            Container(
              width: 55.0,
              height: 62.0,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2.0,
                  color: const Color(0xFFD2E0FB),
                ),
                borderRadius: BorderRadius.circular(13.0),
              ),
            ),
        ],
      ),
    );
  }

  // 확인 버튼
  Widget confirmButton() {
    return Expanded(
      child: SelectButton(
        height: 31.0,
        padding: 33.0,
        bgColor: const Color(0xFFD2E0FB),
        radius: 5,
        text: '확인',
        textColor: Colors.black,
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
