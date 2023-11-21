import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ApplicationBar extends AppBar {

  final bool autoLeading;
  @override
  //final Size preferredSize;

  ApplicationBar({super.key,
  required this.autoLeading,
  }) : super(automaticallyImplyLeading: autoLeading);
  //preferredSize = Size.fromHeight(56.0)

  Widget build(BuildContext context) {
    //double height = Scaffold.of(context).appBarMaxHeight ?? 56;
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: autoLeading,
      title:
      InkWell(
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
//Spacer(),
            Image.asset('assets/cleanapp_logo_blue.png', height: 24),
            const SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.order,
              style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 27, color: Color(0xFF0B1F33)),
            ),
            const SizedBox(width: 10),
//Spacer(flex: 2),
          ],),
      ),

// disable leading button (back button)
//automaticallyImplyLeading: false,
      iconTheme: const IconThemeData(
        color: Color(0xFF0B1F33), //change your color here
      ),
      //backgroundColor: Colors.black,
      //Theme.of(context).colorScheme.primary,
      /*shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),*/
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Color(0xFF0B1F33),
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
        //SizedBox(width: 10),
      ],
    );
  }
}