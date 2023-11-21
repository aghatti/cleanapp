//import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:intl/intl.dart';
import 'package:tasks_repository/tasks_repository.dart';
//import 'package:user_repository/user_repository.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'supplemental/screenarguments.dart';
import 'common_widgets/customappbar.dart';
import 'common_widgets/simplenotification.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  //UserRepository _userRepo = UserRepository();
  final TasksRepository _tasksRepo = TasksRepository();
  final MobileScannerController _scannerController = MobileScannerController(detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    detectionTimeoutMs: 500,
      //torchEnabled: true,
  ); // Create a controller
  bool shouldShowDialog = false;

  @override
  void initState() {

    /*_userRepo.getUser().then(
            (User usr) => setState(() {_usr = usr;})
    );*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Color selectedColor = Theme.of(context).primaryColor;
    /*ThemeData lightTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.light,
    );*/
    //ColorScheme colorScheme = lightTheme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(autoLeading: true, context: context),
      backgroundColor: Colors.black,
      body:
      Stack(
        alignment: FractionalOffset.center,
        children: <Widget>[
          MobileScanner(
            // fit: BoxFit.contain,
            controller: _scannerController,
            startDelay: true,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              //final Uint8List? image = capture.image;
              Task task = Task.empty;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
                if(barcode.rawValue==null) {
                  showSimpleDialog2(
                    context,
                    AppLocalizations.of(context)!.wrongQr,
                    'assets/icons/error.png',
                    Colors.red,
                  );
                  /*ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No QR found.'),
                      )
                  );*/
                } else {
                  task = _tasksRepo.getTaskByQr(barcode.rawValue!);
                  if(task.isEmpty()) {
                    /*ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No task found for QR: ' + (barcode.rawValue ?? '')),
                        )
                    );*/
                    showSimpleDialog2(
                      context,
                      AppLocalizations.of(context)!.wrongQr,
                      'assets/icons/error.png',
                      Colors.red,
                    );
                  }
                  else  {
                    Navigator.pushReplacementNamed(context, '/task', arguments: ScreenArguments(task, 'entertaskbyqr'));
                    break;
                  }
                }

                /*ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('QR: ' + (barcode.rawValue ?? '')),
                )
            );*/
              }
              Future.delayed(const Duration(seconds: 2), () {});
            },
          ),

          Padding(
          padding: const EdgeInsets.all(24),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                const SizedBox(height: 30),
                Center(
                child:
                          Text(
                              AppLocalizations.of(context)!.scanQrMessage,
                              style: const TextStyle(color: Color(0xFFFFFFFF)),
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
                      foregroundColor: const Color(0xFFFFFFFF),
                      side: const BorderSide(width: 2.0, color: Color(0xFFFFFFFF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(100, 56),
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
                            AppLocalizations.of(context)!.reportIssue,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon( // <-- Icon
                          Icons.error_outline,
                          size: 24.0,
                        ),
                      ],
                    ),
                  ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFFFFF),
                  side: const BorderSide(width: 2.0, color: Color(0xFFFFFFFF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(100, 56),
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
          ),

      ],),

    );
  }

  void showSimpleDialog2(BuildContext context,
      String textLabel,
      String imageAssetPath,
      Color color) {
    shouldShowDialog = true;
    // Pause the scanner
    _scannerController.stop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // Prevent the user from dismissing the dialog with the back button
            return false;
          },
          child: SimpleNotificationDialog(
            textLabel: textLabel,
            imageAssetPath: imageAssetPath,
            color: color,
          ),
        );
      },
    ).then((_) {
      shouldShowDialog = false;
      // Resume the scanner when the dialog is closed
      _scannerController.start();
    });

    // Close the dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (shouldShowDialog && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        shouldShowDialog = false;
        // Resume the scanner after closing the dialog
        _scannerController.start();
      }
    });
  }
}