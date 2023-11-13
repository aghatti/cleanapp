import 'package:TeamCoord/common_widgets/_customdialog.dart';
import 'package:TeamCoord/common_widgets/combobox.dart';
import 'package:TeamCoord/models/comboboxitem.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String issueName = '';
  String issueDesc = '';

  late ComboBoxItem _curIssueType;

  UserRepository _userRepo = UserRepository();
  User _usr = User.empty;

  List<ComboBoxItem> issue_types = [];

  @override
  void initState() {
    _userRepo.getUser().then(
            (User usr) => setState(() {_usr = usr;})
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    issue_types = [
      ComboBoxItem(AppLocalizations.of(context)!.orgIssue, '2'),
      ComboBoxItem(AppLocalizations.of(context)!.techIssue, '1'),
    ];
    _curIssueType = issue_types[0];
    return Scaffold(
      appBar: CustomAppBar(autoLeading: true, context: context),
      //backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
          padding: EdgeInsets.all(16),
          child:
          Form(key: _formKey,
            child:
          Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Combobox(
              items: issue_types,
              onItemSelected: (ComboBoxItem? selectedValue) {
                if (selectedValue != null) {
                  _curIssueType = selectedValue;
                }
              },
              selectedItem: issue_types[0],
              label: AppLocalizations.of(context)!.issueType,
            ),
            SizedBox(height: 10),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  issueName = value;
                });
              },
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
                labelText: AppLocalizations.of(context)!.issueName,
                //errorText: issueName.trim().isEmpty ? AppLocalizations.of(context)!.fieldValueRequired: null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.fieldValueRequired;
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            LimitedBox(
              maxHeight: 200,
              child:
              TextFormField(
                  onChanged: (value) {
                    setState(() {
                      issueDesc = value;
                    });
                  },
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
                  labelText: AppLocalizations.of(context)!.issueDesc,
                  //errorText: issueDesc.trim().isEmpty ? AppLocalizations.of(context)!.fieldValueRequired: null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.fieldValueRequired;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 10),
            //SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFF7E7BF4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(100, 56),
                  //elevation: 5.0,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showCustomDialog(
                      context,
                      AppLocalizations.of(context)!.issueReported,
                      'assets/icons/tick-square.png',
                          (BuildContext context) async {
                        // Ensure the futureHandler returns a Future<String>
                        await Future.delayed(Duration(seconds: 2));

                        final auth_token = await Provider.of<UserRepository>(context, listen: false).getAuthToken();
                          if (auth_token.isNotEmpty) {
                            final result = await Provider.of<UserRepository>(
                                context, listen: false).regIssue(
                                auth_token: auth_token,
                                description: issueDesc, name: issueName, type: int.parse(_curIssueType.value));
                            if(result==0) {
                              try {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                return 'NoNav';
                              }
                              catch (e) {
                                throw Exception('Cannot navigate back: $e');
                              }
                            }
                          }

                        return 'Callback started';
                      },
                    );
                  }
                },
                //child: Text(AppLocalizations.of(context)!.reportProblem),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context)!.reportIssue,
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
            ),
          ]
        ),
      ),
      ),

    );
  }
}

