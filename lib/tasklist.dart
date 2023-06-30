import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:cleanapp/utils/utils.dart';
import 'package:user_repository/user_repository.dart';

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
  final String _curDtStr = DateFormat('MMMM dd').format(DateTime.now());


  @override
  void initState() {
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child:Text(_usr!.uName.toString() + ' ' + _usr!.uSurname.toString(), textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyLarge,),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
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
        SizedBox(height: 10),
      Expanded(
        child:
      ListView.separated(
        itemCount: _numTasks,
        scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context,int index){
            return GestureDetector(
              onTap: (){
                print('Tapped on item #$index');
                Navigator.pushNamed(context, '/task', arguments: _tasks[index]);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Row(
                      //crossAxisAlignment: CrossAxisAlignment.baseline,
                      //textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(Utils.getTimeFromDate(_tasks[index].tDate), style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child:
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_tasks[index].tName, style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(_tasks[index].tDesc),
                                ],
                              ),
                            ),
                          ),
                          /*Padding(
                            padding: const EdgeInsets.all(16),
                            child:
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              //color: Colors.white,
                              onPressed: () {},
                            ),
                          ),*/
                        ]),
                  ],
                ),
              ),
            );
          },
         separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),),
    ]),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/qrscan');
        },
        child: const Icon(Icons.qr_code),
      ),
    );
  }
}