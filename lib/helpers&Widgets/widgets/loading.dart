import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rssadmin/helpers&Widgets/helpers/styling.dart';

import 'custom_text.dart';

class Loading extends StatelessWidget {
  final String? text;
  final Color ?color;
  final double ?height;
  final double ?size;
  final Color ?spinkitColor;
  final Color ?textColor;
  final Widget ?widget;

  const Loading({Key ?key, this.text, this.color, this.height, this.size, this.spinkitColor, this.textColor, this.widget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget ?? SpinKitCircle(color: spinkitColor ?? primaryColor, size: size ?? 20),
          text != null ? SizedBox(height: 10) : SizedBox.shrink(),
          text != null ? CustomText(text: text ?? '', letterSpacing: .3, fontWeight: FontWeight.bold, size: 16, color: textColor ?? primaryColor) : SizedBox.shrink()
        ],
      ),
    );
  }
}