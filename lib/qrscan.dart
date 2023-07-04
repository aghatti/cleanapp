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
           OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xFF85C3FF),
                  side: BorderSide(width: 1.0, color: Color(0xFF85C3FF)),
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
                        style: TextStyle(color: Color(0xFF7B7B7B))
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


        ],
      ),



    );
  }
}

