import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'utils/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'supplemental/screenarguments.dart';
import 'common_widgets/customappbar.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  UserRepository _userRepo = UserRepository();
  TasksRepository _tasksRepo = TasksRepository();
  User _usr = User.empty;
  DateTime _curDt = DateTime.now();
  final String _curDtStr = DateFormat('MMMM dd').format(DateTime.now());
  int _numTasks = 0;
  Task _curTask = Task.empty;

  @override
  void initState() {
    _tasksRepo.generateDemoTasks();
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
      appBar: CustomAppBar(autoLeading: true, context: context),
      //backgroundColor: Theme.of(context).primaryColor,
      body:
      Stack(
        alignment: FractionalOffset.center,
        children: <Widget>[
          MobileScanner(
            // fit: BoxFit.contain,
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
              facing: CameraFacing.back,
              detectionTimeoutMs: 500,
              //torchEnabled: true,
            ),
            startDelay: true,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              Task task = Task.empty;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
                if(barcode.rawValue==null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No QR found.'),
                      )
                  );
                } else {
                  task = _tasksRepo.getTaskByQr(barcode.rawValue!);
                  if(task.isEmpty()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No task found for QR: ' + (barcode.rawValue ?? '')),
                        )
                    );
                  }
                  else  {
                    Navigator.pushReplacementNamed(context, '/task', arguments: ScreenArguments(task!, 'entertaskbyqr'));
                    break;
                  }
                }

                /*ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('QR: ' + (barcode.rawValue ?? '')),
                )
            );*/
              }
            },
          ),

          Padding(
          padding: EdgeInsets.all(16),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                SizedBox(height: 30),
                Center(
                child:
                          Text(
                              AppLocalizations.of(context)!.scanQrMessage,
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                              textAlign: TextAlign.center,
                          ),
                ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  //color: Colors.orange,
                ),
              ),

              OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFFFFFFFF),
                      side: BorderSide(width: 1.0, color: Color(0xFFFFFFFF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      //elevation: 5.0,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/report_problem');
                    },
                    //child: Text(AppLocalizations.of(context)!.reportProblem),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            AppLocalizations.of(context)!.reportProblem,
                            style: TextStyle(color: Color(0xFFFFFFFF))
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
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xFFFFFFFF),
                  side: BorderSide(width: 1.0, color: Color(0xFFFFFFFF)),
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
                    Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(color: Color(0xFFFFFFFF))
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
          ),

      ],),

    );
  }
}

