import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:cleanapp/common_widgets/topbar.dart';

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({Key? key}) : super(key: key);

  @override
  _ReportProblemState createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblemPage> {
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
      body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child:
            LimitedBox(
              maxHeight: 200,
              child:
              TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
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
                  alignLabelWithHint: true,
                  labelText: AppLocalizations.of(context)!.problemDescription,
                ),
              ),
            ),
            ),
            //SizedBox(height: 10),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Color(0xFF7E7BF4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                //elevation: 5.0,
              ),
              onPressed: () {
                  Navigator.pop(context);
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

