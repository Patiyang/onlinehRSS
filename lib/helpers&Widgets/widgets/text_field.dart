// ignore: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:rssadmin/helpers&Widgets/helpers/styling.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;

  final iconOne;
  final iconTwo;
  final Color? containerColor;
  final Color? hintColor;
  final TextEditingController? controller;
  final bool? obscure;
  final bool? readOnly;
  final TextInputType? textInputType;
  final TextAlign? align;
  final double? radius;
  final double? width;
  final double? textFieldPadding;
  final changed;
  final int? maxLines;
  final int? maxLength;
  final MainAxisAlignment? mainAxisAlignment;
//validator components
  final InputBorder? inputBorder;
  final validator;
  final onEditingComplete;
  const CustomTextField(
      {Key? key,
      this.hint,
      this.width,
      this.iconOne,
      this.iconTwo,
      this.containerColor,
      this.hintColor,
      this.controller,
      this.validator,
      this.obscure,
      this.textInputType,
      this.align,
      this.radius,
      this.inputBorder,
      this.changed,
      this.readOnly,
      this.maxLines,
      this.textFieldPadding,
      this.maxLength,
      this.onEditingComplete,
      this.mainAxisAlignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(radius ?? 9)), boxShadow: const [
        BoxShadow(blurRadius: 0, color: Colors.transparent, spreadRadius: 0),
      ]),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: textFieldPadding ?? 8, horizontal: 5),
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 11),
          width: width ?? MediaQuery.of(context).size.width,
          child: TextFormField(autofocus: false,
            maxLength: maxLength,
            maxLines: maxLines ?? 1,
            readOnly: readOnly ?? false,
            textAlign: align ?? TextAlign.start,
            keyboardType: textInputType,
            obscureText: obscure ?? false,
            validator: validator,
            onEditingComplete: onEditingComplete,
            onChanged: changed,
            controller: controller,
            style: TextStyle( fontWeight: FontWeight.w600, fontSize: 15, letterSpacing: .3),
            // cursorColor: black,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 8, left: 10),
              prefixIcon: Column(
                mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
                children: [
                  Icon(
                    iconOne,
                    size: 19,
                  ),
                ],
              ),
              suffixIcon: iconTwo ?? SizedBox.shrink(),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 9),
                  borderSide: BorderSide(color: MediaQuery.of(context).platformBrightness == Brightness.dark ? primaryColor : primaryColor, width: 1)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius ?? 9), borderSide: BorderSide(color: Colors.grey, width: 1)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius ?? 9), borderSide: BorderSide(color: Colors.red, width: 1)),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius ?? 9), borderSide: BorderSide(color: grey, width: 1)),
              errorStyle: TextStyle(fontWeight: FontWeight.bold),
              border: OutlineInputBorder(),
              hintText: '',
              alignLabelWithHint: true,
              // label: CustomText(text: hint),
              labelText: hint, hintMaxLines: 2, helperMaxLines: 2,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              // prefixIconConstraints: ,
              hintStyle: TextStyle(
                color: hintColor ?? Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
