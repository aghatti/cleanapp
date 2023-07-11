//import 'dart:ffi';

import 'package:flutter/material.dart';
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
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.auth,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // TODO: Remove filled: true values (103)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
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
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
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

            const SizedBox(height: 12.0),
// [Password]
            //Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            //child:
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
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
                      Provider.of<AuthenticationRepository>(context, listen: false).logIn(username: loginController.text, password: passwordController.text);
                      Provider.of<AuthenticationRepository>(context, listen: false)
                          .checkSession()
                          .then((value) {
                        if (value.isNotEmpty) {
                          //Navigator.pushReplacementNamed(context, '/home');
                          Navigator.of(context!).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                        } else {
                          //Navigator.pushReplacementNamed(context, '/');
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

            // TODO: Add button bar (101)
          ],
        ),
      ),
    );
  }
}
