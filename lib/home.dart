import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:cleanapp/common_widgets/topbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepository _userRepo = UserRepository();
  User _usr = User.empty;

  @override
  void initState() {
    _userRepo.getUser().then(
            (User usr) => setState(() {_usr = usr;})
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title:
              Row(
                children: [
                  Spacer(flex: 2),
                  Image.asset('assets/cleanapp_logo.png'),
                  Spacer(),
                  Text('CleanApp',
                    style: TextStyle(fontStyle: FontStyle.normal, fontSize: 27, color: Colors.white),
                  ),
                  Spacer(flex: 2),
                ],
              ),
        // disable leading button (back button)
        //automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      //backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_usr!.uName.toString() + ' ' + _usr!.uSurname.toString()),
            const CurrentTaskCard(),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tasks');
              },
              //child: Text(AppLocalizations.of(context)!.reportProblem),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.allTasks),
                  SizedBox(
                    width: 10,
                  ),
                  Icon( // <-- Icon
                    Icons.arrow_forward,
                    size: 24.0,
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                  Navigator.pushNamed(context, '/report_problem');
              },
              //child: Text(AppLocalizations.of(context)!.reportProblem),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.reportProblem),
                  SizedBox(
                    width: 10,
                  ),
                  Icon( // <-- Icon
                    Icons.error_outline,
                    size: 24.0,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                try {
                  Provider.of<AuthenticationRepository>(context, listen: false).logOut();
                  //Navigator.pushReplacementNamed(context, '/');
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                }
                catch (_) {
                }

              },
              child: Text(AppLocalizations.of(context)!.logOut),
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.qr_code),
      ),
    );
  }
}

class CurrentTaskCard extends StatelessWidget {
  const CurrentTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10)),
                side: BorderSide(width: 15, color: Colors.green)
                //side: BorderSide.none
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            const ListTile(
              //leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


