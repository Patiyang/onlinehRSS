import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rssadmin/helpers&Widgets/helpers/helper_class.dart';
import 'package:rssadmin/views/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

String? _adminPass;
String? _adminEmail;

class LoginServices{
  Future<bool> signIn(String email, String password, BuildContext context) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();

  try {
    await firestore.collection('admin').where('email', isEqualTo: email).get().then((snap) async {
      String? _aPass = snap.docs[0].data()['admin password'];
      String? _aEmail = snap.docs[0].data()['email'];

      _adminPass = _aPass;
      _adminEmail = _aEmail;

      if (_adminPass == password && _adminEmail == email) {
        sp.setString('adminId', HelperClass.tokenKey);
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomePage()));
      } else {
        Fluttertoast.showToast(msg: 'wrong email or password');
      }
      if (snap.docs.isEmpty) {
        Fluttertoast.showToast(msg: 'User not found');
      }
    });
    return true;
  } catch (e) {
    print(e.toString());
    Fluttertoast.showToast(msg: e.toString().split(']')[1]);
    return false;
  }
}
}

