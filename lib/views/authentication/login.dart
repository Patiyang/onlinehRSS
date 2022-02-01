import 'package:flutter/material.dart';
import 'package:rssadmin/helpers&Widgets/helpers/helper_class.dart';
import 'package:rssadmin/helpers&Widgets/widgets/custom_button.dart';
import 'package:rssadmin/helpers&Widgets/widgets/custom_text.dart';
import 'package:rssadmin/helpers&Widgets/widgets/text_field.dart';
import 'package:rssadmin/services/login_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

bool loadingSignIn = false;
var passwordCtrl = TextEditingController();
var emailCtrl = TextEditingController();
var formKey = GlobalKey<FormState>();
LoginServices loginServices = LoginServices();
bool obscureText = true;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              HelperClass.whiteLogo,
              height: 100,
              fit: BoxFit.cover,
              width: 100,
            ),
            SizedBox(height: 5),
            CustomText(
              text: 'Login',
              size: 25,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            CustomTextField(
              controller: emailCtrl,
              hint: 'Email',
              iconOne: Icons.alternate_email_rounded,
              validator: (v) {
                if (v.isEmpty) {
                  return 'Email address cannot be empty';
                }
              },
            ),
            CustomTextField(
              controller: passwordCtrl,
              obscure: obscureText,
              iconOne: Icons.password,
              hint: 'Password',
              validator: (v){
                 if (v.isEmpty) {
                  return 'Password cannot be empty';
                }
              },
              iconTwo: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(obscureText ? Icons.lock : Icons.lock_open)),
            ),
            SizedBox(height: 25),
            CustomFlatButton(
              verifying: loadingSignIn,
              callback: () => handleSignIn(),
              text: 'Login',
            ),
          ],
        ),
      ),
    );
  }

  handleSignIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loadingSignIn = true;
      });
      formKey.currentState!.save();

      try {
        await loginServices.signIn(emailCtrl.text, passwordCtrl.text, context);
        setState(() {
          loadingSignIn = false;
        });
      } catch (e) {
        print(e.toString());
        setState(() {
          loadingSignIn = false;
        });
      }
    }
  }
}
