import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:cleanapp/utils/utils.dart';

class TaskPage extends StatelessWidget {
  TaskPage({super.key, required this.task});

  Task task = Task.empty;

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
      body:
        Padding(
        padding:
    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
    child:
    //Expanded(child:
    Column(
    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    SizedBox(height: 10),

      Row(
        //crossAxisAlignment: CrossAxisAlignment.baseline,
        //textBaseline: TextBaseline.alphabetic,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(Utils.getTimeFromDate(task.tDate), style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child:
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.tName, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ]),
      ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.description, color: Color(0xFF85C3FF),),
            ],
          ),
        title: Text(task.tDesc)
      ),
      SizedBox(height: 10),
      /*Flexible(
        child: Container(
          width: double.infinity,
          //color: Colors.orange,
        ),
      ),*/
      //const CurrentTaskCard(),
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
        ]),
      ),
    );
  }
}