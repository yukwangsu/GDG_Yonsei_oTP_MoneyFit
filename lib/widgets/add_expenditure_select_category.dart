import 'package:flutter/material.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/select_button.dart';

class AddExpenditureSelectCategory extends StatefulWidget {
  const AddExpenditureSelectCategory({super.key});

  @override
  State<AddExpenditureSelectCategory> createState() =>
      _AddExpenditureSelectCategoryState();
}

class _AddExpenditureSelectCategoryState
    extends State<AddExpenditureSelectCategory> {
  String selectedCategory = '';

  // 확인 버튼을 눌렀을 때
  void onClickConfirmButton() {
    if (selectedCategory.isNotEmpty) {
      Navigator.of(context).pop(selectedCategory);
    }
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
        height: 324.0, // 수정 필수
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
                runSpacing: 14.0,
                children: [
                  for (int i = 0; i < categoryList.length; i++)
                    categoryButton(categoryList[i]),
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
    );
  }

  // 카테고리 선택지
  Widget categoryButton(String name) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (selectedCategory == name) {
            selectedCategory = '';
          } else {
            selectedCategory = name;
          }
        });
      },
      child: SizedBox(
        width: 115.0,
        child: Row(
          children: [
            selectedCategory == name
                //선택된 카테고리일 경우
                ? Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8EACCD),
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  )
                //선택되지 않은 카테고리일 경우
                : Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.0, color: const Color(0xFF8EACCD)),
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 13.0),
            ),
          ],
        ),
      ),
    );
  }

  // 확인 버튼
  Widget confirmButton() {
    return Expanded(
      child: SelectButton(
        height: 31.0,
        padding: 33.0,
        bgColor: selectedCategory.isNotEmpty
            ? const Color(0xFFD2E0FB)
            : const Color.fromARGB(255, 239, 244, 252),
        radius: 5,
        text: '확인',
        textColor: selectedCategory.isNotEmpty ? Colors.black : Colors.grey,
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
