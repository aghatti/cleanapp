import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'common_widgets/customappbar.dart';
import 'utils/utils.dart';

class TaskPage extends StatelessWidget {
  TaskPage({super.key, required this.task, required this.par});

  Task task = Task.empty;
  String par = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(autoLeading: true, context: context),
      body:
        Padding(
        padding:
    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    child:
    //Expanded(child:
    Column(
    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(height: 10),

      Card(
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.black,

        elevation: 5,
        child: Column(
            children: [
              Container(
                color: Color(0xDD7ACB82),
                child:
                    Padding(
                      padding: EdgeInsets.all(16),
                      child:
              Row(
                children: [
                  SizedBox(height: 10),
                  Text(Utils.getTimeFromDate(task.tDate), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child:
                  Text(task.tName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
                    ),
              ),
            ]
        ),
      ),

      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.all(10),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_pin, color: Color(0xFF85C3FF),),
            SizedBox(width: 10),
            Text(task.tAddress + '\n' + task.tZone),
          ],
        ),
      ),
          Padding(
              padding: EdgeInsets.all(10),
              child:
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.description, color: Color(0xFF85C3FF),),
          SizedBox(width: 10),
          Text(task.tDesc)
        ],
      ),
          ),

/*      ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.description, color: Color(0xFF85C3FF),),
            ],
          ),
        title: Text(task.tDesc)
      ),*/
      SizedBox(height: 10),
      /*Flexible(
        child: Container(
          width: double.infinity,
          //color: Colors.orange,
        ),
      ),*/
      //const CurrentTaskCard(),
      Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
        child:
        Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
      if(par=='entertaskbyqr')
      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Color(0xFF7ACB82),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          //elevation: 5.0,
        ),
        onPressed: () {
        },
        //child: Text(AppLocalizations.of(context)!.reportProblem),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.beginTask,
              //style: TextStyle(color: Color(0xFF7B7B7B))
            ),
          ],
        ),
      ),
      if(par=='entertaskbyqr')
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
        },
        //child: Text(AppLocalizations.of(context)!.reportProblem),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                AppLocalizations.of(context)!.cancelTask,
                style: TextStyle(color: Color(0xFF7B7B7B))
            ),
          ],
        ),
      ),
      if(par=='entertask')
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Color(0xFF7ACB82),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            //elevation: 5.0,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/qrscan');
          },
          //child: Text(AppLocalizations.of(context)!.reportProblem),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.beginTaskQR,
                //style: TextStyle(color: Color(0xFF7B7B7B))
              ),
              SizedBox(
                width: 10,
              ),
              Icon( // <-- Icon
                Icons.qr_code_scanner,
                size: 24.0,
              ),
            ],
          ),
        ),
      if(par=='entertask')
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
          },
          //child: Text(AppLocalizations.of(context)!.reportProblem),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  AppLocalizations.of(context)!.beginTaskNoQR,
                  style: TextStyle(color: Color(0xFF7B7B7B))
              ),
            ],
          ),
        ),
    ]),),
        ]),
      ),
    );
  }
}