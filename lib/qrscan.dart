import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:cleanapp/utils/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.front,
          torchEnabled: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
          }
        },
      ),

    );
  }
}

