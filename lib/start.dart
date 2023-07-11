import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  // TODO: Make a collection of cards (102)
  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    return Scaffold(
      // TODO: Add app bar (102)
      // TODO: Add a grid view (102)
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Flexible(
          flex: 1,
          child:
            Image.asset('assets/cleanapp_logo_big.png'),
          ),
            const SizedBox(height: 20.0),
        Flexible(
          flex: 1,
          child:
            Text(
              AppLocalizations.of(context)!.order,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
        ),
            const SizedBox(height: 60.0),

              Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),

              child:
              FilledButton(
                /*style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // NEW
                ),*/
                style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFF7E7BF4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(100, 56),
                  //elevation: 5.0,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                //style: FilledButton.styleFrom(
                //  backgroundColor: Color.fromRGBO(126, 123, 244, 1.0),
                //),
                child: Text(AppLocalizations.of(context)!.logIn,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold
                ),),
              ),
              ),

           ],
        ),
      ),
      // TODO: Set resizeToAvoidBottomInset (101)
    );
  }
}
