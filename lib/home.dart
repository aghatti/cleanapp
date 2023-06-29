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
    Color selectedColor = Theme.of(context).primaryColor;
    ThemeData lightTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.light,
    );
    ColorScheme colorScheme = lightTheme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  //Spacer(),
                  Image.asset('assets/cleanapp_logo.png', height: 24),
                  SizedBox(width: 10),
                  Text(AppLocalizations.of(context)!.order,
                    style: TextStyle(fontStyle: FontStyle.normal, fontSize: 27, color: Colors.white),
                  ),
                    SizedBox(width: 20),
                  //Spacer(flex: 2),
                  ],),
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
      body: Padding(
          padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
          child:
          Expanded(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            SizedBox(height: 10),
            Text(_usr!.uName.toString() + ' ' + _usr!.uSurname.toString(), textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyLarge,),

            Expanded(
              child:        Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child:
                       Text('24 января'),
                  ),
                  Flexible(child: Text('Сегодня', style: TextStyle(fontWeight: FontWeight.bold)),),
                  Container(
                    child: Text('18 заданий'),
                  ),
                ],
              ),
            ),

            ColorGroup(children: [
              ColorChip(
                label: AppLocalizations.of(context)!.currentTask,
                color: colorScheme.primary,
                onColor: colorScheme.onPrimary,
              ),
              ColorChip(
                  label: 'onPrimary',
                  color: colorScheme.onPrimary,
                  onColor: colorScheme.primary),
              ColorChip(
                label: 'primaryContainer',
                color: colorScheme.primaryContainer,
                onColor: colorScheme.onPrimaryContainer,
              ),
              ColorChip(
                label: 'onPrimaryContainer',
                color: colorScheme.onPrimaryContainer,
                onColor: colorScheme.primaryContainer,
              ),
            ]),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    //color: Colors.orange,
                  ),
                ),
            //const CurrentTaskCard(),
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
        ),),
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

//==
class ColorGroup extends StatelessWidget {
  const ColorGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class ColorChip extends StatelessWidget {
  const ColorChip({
    super.key,
    required this.color,
    required this.label,
    this.onColor,
  });

  final Color color;
  final Color? onColor;
  final String label;

  static Color contrastColor(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    switch (brightness) {
      case Brightness.dark:
        return Colors.white;
      case Brightness.light:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor = onColor ?? contrastColor(color);

    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: labelColor))),
          ],
        ),
      ),
    );
  }
}
