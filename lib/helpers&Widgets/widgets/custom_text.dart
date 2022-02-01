import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rssadmin/helpers&Widgets/helpers/styling.dart';


class CustomText extends StatelessWidget {
  final String ?text;
  final double ?size;
  final double ?letterSpacing;
  final Color ?color;
  final FontWeight ?fontWeight;
  final TextOverflow ?overflow;
  final int ?maxLines;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final String? fontFam;
  const CustomText({
    Key ?key,
    @required this.text,
    this.size,
    this.color,
    this.fontWeight,
    this.letterSpacing,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.textDecoration,
    this.fontFam
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: textAlign,
      maxLines: maxLines ?? 1,
      overflow: overflow ?? TextOverflow.visible,
      style: TextStyle(
        decoration: textDecoration ?? TextDecoration.none,
        fontSize:size ,
        color: color ,
        fontWeight: fontWeight ?? FontWeight.w500,
        letterSpacing: letterSpacing ?? 0,
        // fontFamily: 'Montserrat',
      ),
    );
  }
}

class CartItemRich extends StatelessWidget {
  final String? lightFont;
  final String? boldFont;
  final double? lightFontSize;
  final double? boldFontSize;
  final double? letterSpacing;
  final Color ?lightColor;
  final Color ?boldColor;
  final TextAlign? textAlign;

  final LongPressGestureRecognizer ?longPressGestureRecognizer;
  final VoidCallback? callback;
  const CartItemRich(
      {Key ?key,
      this.lightFont,
      this.boldFont,
      this.lightFontSize,
      this.boldFontSize,
      this.letterSpacing,
      this.longPressGestureRecognizer,
      this.callback,
      this.lightColor,
      this.boldColor,
      this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(children: [
        TextSpan(
            text: lightFont,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: lightColor ?? grey,
              fontSize: lightFontSize ?? 13,
              fontWeight: FontWeight.bold,
            )),
        TextSpan(
            recognizer: TapGestureRecognizer()..onTap = callback,
            text: boldFont,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: boldColor ?? black,
              fontSize: boldFontSize ?? 15,
              fontWeight: FontWeight.bold,
              letterSpacing: letterSpacing,
            )),
      ]),
    );
  }
}
