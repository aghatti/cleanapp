import 'package:TeamCoord/common_widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'utils/utils.dart';
import 'package:user_repository/user_repository.dart';
import 'supplemental/screenarguments.dart';

class TasksList extends StatefulWidget {

  TasksList({Key? key}) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  UserRepository _userRepo = UserRepository();
  TasksRepository _tasksRepo = TasksRepository();
  int _numTasks = 0;
  List<Task> _tasks = [];

  User _usr = User.empty;
  DateTime _curDt = DateTime.now();
  final String _curDtStr = DateFormat.MMMMd(Platform.localeName).format(DateTime.now());


  @override
  void initState() {
    _userRepo.getUser().then(
            (User usr) => setState(() {
          _usr = usr;
        })
    );
    _tasksRepo.generateDemoTasks();
    _tasksRepo.getTasks().then(
        (List<Task> tasks) => setState(() {_tasks = tasks;})
    );
    _tasksRepo.getNumTasks().then(
            (int numTasks) => setState(() {_numTasks = numTasks;})
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
      body:
        //Expanded(child:
        Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child:Container(
                  color: Color(0xFFECEBFB),
                  constraints: BoxConstraints(minHeight: 80),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child:
                    Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFF85C3FF),
                            foregroundColor: Colors.white,
                            child: Text(_userRepo.getUserLabel(), style: TextStyle(fontSize: 19)),
                          ),
                          SizedBox(width: 16),
                          Text(_usr!.uName.toString() + ' ' + _usr!.uSurname.toString(), textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal, fontSize: 19)
                            ,),
                        ]
                    ),),),
              ),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child:
                Container(
                  child: Text(_curDtStr),
                ),
              ),
              Expanded(
                flex: 3,
                child:
                Text(AppLocalizations.of(context)!.today,  textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, ),),
              ),
              Expanded(
                flex: 3,
                child:
                Container(
                  child: Text(AppLocalizations.of(context)!.tasks + ': ' + _numTasks.toString(), softWrap: false, textAlign: TextAlign.right,),
                ),
              ),
            ],
          ),
        ),
              SizedBox(height: 17),
              Divider(color: Color(0xFFC2E1FF), height: 1, thickness: 1),
        SizedBox(height: 0),
      Expanded(
        child:
            Container(
              color: Color(0xFFF5F5FD),
              child:
      ListView.separated(
        itemCount: _numTasks,
        scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context,int index){
            return GestureDetector(
              onTap: (){
                print('Tapped on item #$index');
                Navigator.pushNamed(context, '/task', arguments: ScreenArguments(_tasks[index], 'entertask'));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                child:
              Card(
                color: Color(0xFFFFFFFF),
                shadowColor: Color(0xFF000000),
                surfaceTintColor: Color(0xFFFFFFFF),
                //elevation: 0,
                child:
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Row(
                      //crossAxisAlignment: CrossAxisAlignment.baseline,
                      //textBaseline: TextBaseline.alphabetic,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16,0,16,0),
                            child: Text(Utils.getTimeFromDate(_tasks[index].tDate), style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child:
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_tasks[index].tName, style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(_tasks[index].tAddress + '\n' + _tasks[index].tZone, style: TextStyle(color: Color(0xFF66727F), fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,16,0),
                            child:
                            IconButton.filled(
                              icon: const Icon(Icons.qr_code_scanner),
                              style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Color(0xFF7ACB82),
                              ),
                              //color: Colors.white,
                              onPressed: () {Navigator.pushNamed(context, '/qrscan');},
                            ),
                          ),
                        ]),
                  ],
                ),
                    ),
              ),
              ),
            );
          },
         separatorBuilder: (BuildContext context, int index) {
          //return const Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Divider(color: Color(0xFFC2E1FF)));
           return const Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: SizedBox(height: 5));
        },
      ),),),
    ]),

      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/qrscan');
        },
        child: const Icon(Icons.qr_code),
      ),*/
    );
  }
}