import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextStyle textStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? textOverflow;

  const TextWidget({
    super.key,
    required this.text,
    required this.textStyle,
    this.textDirection,
    this.maxLines,
    this.textAlign,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle,
      textDirection: textDirection,
      overflow: textOverflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 10,
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}

