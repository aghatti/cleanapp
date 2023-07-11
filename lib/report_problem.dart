import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'common_widgets/customappbar.dart';

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
      appBar: CustomAppBar(autoLeading: true, context: context),
      //backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            //SizedBox(height: 10),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Color(0xFF7E7BF4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(100, 56),
                //elevation: 5.0,
              ),
              onPressed: () {
                  Navigator.pop(context);
              },
              //child: Text(AppLocalizations.of(context)!.reportProblem),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.reportProblem,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold
                    ),
                  ),
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

    );
  }
}

