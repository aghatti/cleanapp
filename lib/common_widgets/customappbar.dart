import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBar extends AppBar {
  final bool autoLeading;
  final BuildContext context;

  CustomAppBar({super.key, required this.autoLeading, required this.context}):super(
    centerTitle: true,
    automaticallyImplyLeading: autoLeading,
    scrolledUnderElevation: 0,
    elevation: 0,
    shadowColor: Colors.black,
    title:
  InkWell(
  onTap: () {
    if (ModalRoute.of(context)!.settings.name != '/home') {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    }
  },
  child:
  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
//Spacer(),
        Image.asset('assets/cleanapp_logo_blue.png', height: 24),
        const SizedBox(width: 5),
        Text(AppLocalizations.of(context)!.order,
          style: const TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 25,
              //color: Color(0xFF0B1F33)
            color: Color(0xFF5551F1)
          ),
        ),
        //SizedBox(width: 20),
//Spacer(flex: 2),
      ],),
  ),
// disable leading button (back button)
//automaticallyImplyLeading: false,
    iconTheme: const IconThemeData(
      color: Color(0xFF0B1F33), //change your color here
    ),
    backgroundColor: Colors.white,
    //Theme.of(context).colorScheme.primary,
    /*shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),*/
    actions: <Widget>[
      IconButton(
        icon: const Icon(
          //Icons.notifications,
            Icons.notifications_outlined,
          //color: Color(0xFF0B1F33),
           color: Color(0xFF5551F1)
        ),
        onPressed: () {
// do something
        },
      ),
      /*IconButton(
        icon: const Icon(
          Icons.account_circle,
          color: Color(0xFF0B1F33),
        ),
        onPressed: () {
// do something
        },
      ),*/
      const SizedBox(width: 10),
    ],
  );
}