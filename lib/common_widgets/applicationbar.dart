import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ApplicationBar extends AppBar implements PreferredSizeWidget {

  final bool autoLeading;
  @override
  final Size preferredSize;

  ApplicationBar({super.key,
  required this.autoLeading,
  }) : preferredSize = Size.fromHeight(56.0), super(automaticallyImplyLeading: autoLeading);

  @override
  Widget build(BuildContext context) {
    //double height = Scaffold.of(context).appBarMaxHeight ?? 56;
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: autoLeading,
      title:
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
//Spacer(),
          Image.asset('assets/cleanapp_logo_blue.png', height: 24),
          SizedBox(width: 10),
          Text(AppLocalizations.of(context)!.order,
            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 27, color: Color(0xFF0B1F33)),
          ),
          SizedBox(width: 20),
//Spacer(flex: 2),
        ],),
// disable leading button (back button)
//automaticallyImplyLeading: false,
      iconTheme: IconThemeData(
        color: Color(0xFF0B1F33), //change your color here
      ),
      backgroundColor: Colors.black,
      //Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
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
        IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: Color(0xFF0B1F33),
          ),
          onPressed: () {
// do something
          },
        ),
        SizedBox(width: 10),
      ],
    );
  }
}