import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rssadmin/helpers&Widgets/helpers/change_screen.dart';
import 'package:rssadmin/helpers&Widgets/helpers/helper_class.dart';
import 'package:rssadmin/helpers&Widgets/helpers/styling.dart';
import 'package:rssadmin/views/authentication/login.dart';
import 'package:rssadmin/views/home/home_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () => movetohome());
    return Stack(
      children: [
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
               HelperClass.whiteLogo,
                width: 100,
              ),
              SizedBox(height: 20),
              SpinKitPulse(
                color: MediaQuery.of(context).platformBrightness == Brightness.dark ? white : primaryColor,
                size: 25,
              )
            ],
          ),
        ),
      ],
    );
  }

  Future movetohome() async {
    final pref = await SharedPreferences.getInstance();
    String uuid = pref.getString('adminId') ?? '';
    if (uuid.isNotEmpty) {
      changeScreenReplacement(context, HomePage());
    } else if (uuid.isEmpty) {
      changeScreenReplacement(context, Login());
    }
  }
}
