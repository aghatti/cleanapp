//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'supplemental/ellipseclipper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TODO: Add text editing controllers (101)
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  int authRes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          //padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
          children: <Widget>[
            //const SizedBox(height: 80.0),
            Flexible(
              flex: 1,
              child: SizedBox(
                height: 400,
                child: ClipPath(
                  clipper: EllipseClipper(),
                  child: Container(
                    color: Color.fromRGBO(85, 81, 241, 1.0),
                    //height: 200,
                    //alignment: Alignment.center,
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/3.0x/cleanapp_logo.png'),
                          const SizedBox(height: 10.0),
                          Text(
                            AppLocalizations.of(context)!.order,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
        Flexible(
          flex: 1,
            child:
            ListView (
              children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.auth,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
// [Login]]
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
              child: TextField(
                controller: loginController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  filled: true,
                  labelText: AppLocalizations.of(context)!.logInPrompt,
                ),
              ),
            ),
// spacer
            const SizedBox(height: 12.0),
// [Password]
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  filled: true,
                  labelText: AppLocalizations.of(context)!.passwordPrompt,
                ),
                obscureText: true,
              ),
            ),

            Visibility(visible: authRes != 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            Padding(
            padding:
            const EdgeInsets.fromLTRB(26, 8, 26, 0),
              child: Text(AppLocalizations.of(context)!.authError, style: TextStyle(color: Colors.redAccent)),),
              ],),),
            const SizedBox(height: 12.0),
// [Auth button]
            //Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            //child:
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
              child:
              /*Opacity(
                opacity: 0.7,
                child:*/
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Color(0xFF7E7BF4),
                    minimumSize: Size(100, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    //elevation: 5.0,
                  ),
                  onPressed: () {
                    try {
                      Provider.of<AuthenticationRepository>(context, listen: false)
                          .logInAPI(username: loginController.text.trim(), password: passwordController.text.trim())
                          .then((val) {
                          if(val == 0) {
                            Provider.of<AuthenticationRepository>(
                                context, listen: false)
                                .checkSession()
                                .then((value) {
                              if (value.isNotEmpty) {
                                authRes = 0;
                                //Navigator.pushReplacementNamed(context, '/home');
                                Provider.of<UserRepository>(
                                    context, listen: false).getUserAPI(
                                    auth_token: value.toString()).then((
                                    void_val) {
                                  Navigator.of(context!)
                                      .pushNamedAndRemoveUntil(
                                      '/home', (Route<dynamic> route) => false);
                                });
                              } else {
                                //Navigator.pushReplacementNamed(context, '/');
                              }
                            });
                          }
                          else {
                            setState(() {
                              authRes = val;
                            });
                          }
                      });
                    }
                    catch (_) {
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.logIn,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            //),
              ]
            ),
        ),
            // ),

          ],
        ),
      ),
    );
  }
}
