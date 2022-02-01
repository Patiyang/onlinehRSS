import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rssadmin/helpers&Widgets/helpers/styling.dart';


import 'custom_text.dart';




class CustomFlatButton extends StatelessWidget {
  final String? text;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback callback;
  final double? height;
  final double? width;
  final double? radius;
  final double? iconSize;
  final bool? verifying;
  final IconData? icon;
  final double? fontSize;

  const CustomFlatButton(
      {Key? key,
      this.text,
      this.color,
     required this.callback,
      this.textColor,
      this.height,
      this.width,
      this.radius,
      this.icon,
      this.fontSize,
      this.iconColor,
      this.iconSize,
      this.verifying = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: MaterialButton(
        elevation: 2,
        height: height ?? 45,
        minWidth: width ?? 200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius ?? 12))),
        onPressed: verifying == true
            ? () {
                Fluttertoast.showToast(msg: 'Please wait');
              }
            : callback,
        color:MediaQuery.of(context).platformBrightness == Brightness.dark ?grey[800]:white,
        child: Container(
          width: width ?? 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon == null
                  ? SizedBox.shrink()
                  : Icon(
                      icon,
                    
                      size: iconSize ?? 17,
                    ),
              icon == null
                  ? SizedBox.shrink()
                  : SizedBox(
                      width: 7,
                    ),
              Expanded(
                child: verifying == true
                    ? SpinKitChasingDots(color: textColor ?? white, size: 18)
                    : CustomText(
                        text: text ?? '',
                   
                        size: fontSize,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
