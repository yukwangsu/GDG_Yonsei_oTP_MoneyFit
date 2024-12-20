import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  final double height;
  final double padding;
  final Color bgColor;
  final double radius;
  final String text;
  final Color textColor;
  final double textSize;
  final Color? borderColor; // nullable 테두리 색상
  final double? borderWidth; // 테두리 두께
  final double? borderOpacity; // 테두리 투명도
  final Function onPress;
  final Function? longPress;

  const SelectButton({
    super.key,
    required this.height,
    required this.padding,
    required this.bgColor,
    required this.radius,
    required this.text,
    required this.textColor,
    required this.textSize,
    this.borderColor,
    this.borderWidth,
    this.borderOpacity,
    required this.onPress,
    this.longPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton(
        onPressed: () => onPress(), // 함수를 호출하지 않고 참조를 전달
        onLongPress: () => longPress != null ? longPress!() : onPress(),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
          ), // 텍스트와 버튼 사이 거리
          minimumSize: Size(0, height), // 최소 높이 설정
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius), // 테두리 반경 설정
            side: borderColor != null
                ? BorderSide(
                    color: borderColor!.withOpacity(borderOpacity!),
                    width: borderWidth!,
                  )
                : BorderSide.none, // 테두리 설정하지 않음
          ),
          splashFactory: NoSplash.splashFactory, // 스플래시 효과 제거
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: textSize, color: textColor, height: 20 / textSize),
        ),
      ),
    );
  }
}
