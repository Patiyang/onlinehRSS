import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final Widget? child;
  final double? height;
  final double? width;
  final double? horizontalPadding;
  final double? verticalPadding;
  const CustomContainer({
    Key? key,
    this.backgroundColor,
    this.borderRadiusGeometry,
    this.child,
    this.height,
    this.width, this.horizontalPadding, this.verticalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:verticalPadding??8, horizontal:horizontalPadding??5),
      height: height ?? MediaQuery.of(context).size.height,
      width: width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: borderRadiusGeometry ?? BorderRadius.circular(9),
      ),
      child: child,
    );
  }
}
