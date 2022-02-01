import 'package:flutter/material.dart';
import 'package:rssadmin/helpers&Widgets/helpers/styling.dart';


import 'custom_text.dart';

class DrawerItem extends StatelessWidget {
  final IconData? iconData;
  final String? title;
  final Color? color;
  final VoidCallback? callback;
  const DrawerItem({Key? key, this.iconData, this.title, this.color, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: callback,
      leading: Container(
        child: Icon(iconData, size: 22,),
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: color ?? (MediaQuery.of(context).platformBrightness == Brightness.dark ? grey[600] : grey[300]),
        ),
      ),
      title: CustomText(text: title),
    );
  }
}
