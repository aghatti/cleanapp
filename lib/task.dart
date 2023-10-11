
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'common_widgets/customappbar.dart';
import 'common_widgets/customdialog.dart';
import 'utils/utils.dart';
import 'package:user_repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'constants/constants.dart';


class TaskPage extends StatefulWidget {
  TaskPage({super.key, required this.task, required this.par});

  Task task = Task.empty;
  String par = '';

  @override
  State<TaskPage> createState() => _TaskPageState();
}



class _TaskPageState extends State<TaskPage> {
  UserRepository _userRepo = UserRepository();
  TasksRepository _tasksRepo = TasksRepository();

  User _usr = User.empty;
  Color statusBg = Color(0xFFEBE8FB);
  Color statusColor = Color(0xFF0B1F33);
  IconData statusIcon = Icons.drafts_outlined;

  // TODO REMOVE
  final List<PhotoItem> _items = [
    PhotoItem(
        "assets/photos/photo1.png",
        "photo1"),
    PhotoItem(
        "assets/photos/photo2.png",
        "photo2"),
  ];

  @override
  void initState() {
    _userRepo.getUser().then(
            (User usr) => setState(() {
          _usr = usr;
        })
    );
    if(!widget.task.isEmpty()) {
      statusBg = Color(TaskStatusList.StatusesMap[widget.task.tStatus]!.statusBg);
      statusColor = Color(TaskStatusList.StatusesMap[widget.task.tStatus]!.statusColor);
      statusIcon = TaskStatusList.GetIconByStatus(widget.task.tStatus);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(autoLeading: true, context: context),
      body:
    //Expanded(child:
    Column(
    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // OLD CARD
      Visibility(
        visible: false,
        child:
      Card(
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.black,
        elevation: 0,
        child: Column(
            children: [
              Container(
                color: this.statusBg,
                constraints: BoxConstraints(minHeight: 100),
                child:
                    Padding(
                      padding: EdgeInsets.all(16),
                      child:
              Row(
                children: [
                  SizedBox(height: 10),
                  //Text(Utils.getTimeFromDate(task.tDate), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(Utils.getTimeFromDate(widget.task.tDate),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: this.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child:
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child:
                  Text(widget.task.tName,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: this.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                  ),
                    Icon(statusIcon, color: statusColor),
                ],
              ),
                    ),
              ),
            ]
        ),
      ),),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child:Container(
          color: this.statusBg,
          constraints: BoxConstraints(minHeight: 80),
          child: Padding(
            padding: EdgeInsets.all(16),
            child:
            Row(
                children: [
                  Text(Utils.getTimeFromDate(widget.task.tDate),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: this.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //SizedBox(width: 16),
          Expanded(
            child:
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child:
                  Text(widget.task.tName,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: this.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),),
                  Visibility(
                    visible: widget.task.tStatus!='planned',
                    child:
                  Icon(statusIcon,
                      color: statusColor),
                  ),
                ]
            ),),),
      ),
      SizedBox(height: 15),

      Expanded(
            child:
          CustomScrollView(
            shrinkWrap: true,
              slivers: [
              SliverFillRemaining(
              hasScrollBody: false,
              child:
                  Column(
    children: [
      if(widget.task.tStatus=='stopped' || widget.task.tStatus=='failed') ...[
      Padding(
        padding: EdgeInsets.all(16),
        child:
        Center(
            child:
                Text(AppLocalizations.of(context)!.taskCanceled, style: TextStyle(fontSize: 20),),
          ),
      ),
      Divider(thickness: 1, height: 1, color: Color(0xFFC2E1FF), indent: 16, endIndent: 16,),
      ],
      if(widget.task.tStatus=='reqstop' || widget.task.tStatus=='reqnoqr') ...[
        Padding(
          padding: EdgeInsets.all(16),
          child:
          Center(
            child:
            Text(AppLocalizations.of(context)!.taskWaitAction, style: TextStyle(fontSize: 20),),
          ),
        ),
        Divider(thickness: 1, height: 1, color: Color(0xFFC2E1FF), indent: 16, endIndent: 16,),
      ],
      Visibility(
        visible: widget.task.tStatus=='finished',
        child:
      Padding(
        padding: EdgeInsets.all(16),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.access_time_outlined, color: Color(0xFF85C3FF),),
            SizedBox(width: 16),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(AppLocalizations.of(context)!.leadTime, style: TextStyle(fontWeight: FontWeight.bold),),
              Text(Utils.getTimeFromDate(widget.task.tDate) + ' - ' + Utils.getTimeFromDate(widget.task.tDate.add(Duration(minutes: 15)))),
            ]),
          ],
        ),
      ),
      ),
      Visibility(
          visible: widget.task.tStatus=='finished',
          child:
          Divider(thickness: 1, height: 1, color: Color(0xFFC2E1FF), indent: 16, endIndent: 16,),
      ),
      Padding(
        padding: EdgeInsets.all(16),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_pin, size: 28, color: Color(0xFF85C3FF),),
            SizedBox(width: 16),
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.location, style: TextStyle(fontWeight: FontWeight.bold),),
              Text(widget.task.tAddress + '\n' + widget.task.tZone),
              ],),
          ],
        ),
      ),
      Divider(thickness: 1, height: 1, color: Color(0xFFC2E1FF), indent: 16, endIndent: 16,),
      Padding(
        padding: EdgeInsets.all(16),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.person_outline, size: 28, color: Color(0xFF85C3FF),),
            SizedBox(width: 16),
          Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.performer, style: TextStyle(fontWeight: FontWeight.bold),),
            Text(_usr!.uName.toString() + ' ' + _usr!.uSurname.toString()),
            ],),
          ],
        ),
      ),
      Divider(thickness: 1, height: 1, color: Color(0xFFC2E1FF), indent: 16, endIndent: 16,),
          Padding(
              padding: EdgeInsets.all(16),
              child:
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.description, size: 28, color: Color(0xFF85C3FF),),
          SizedBox(width: 16),

          Flexible(child:
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(AppLocalizations.of(context)!.description, style: TextStyle(fontWeight: FontWeight.bold),),
          Text(widget.task.tDesc),
            ],),
          ),
        ],
      ),
          ),
      // PHOTO SECTION
      if(widget.task.tStatus=='started' || widget.task.tStatus=='finished') ... [
      Divider(thickness: 1, height: 1, color: Color(0xFFC2E1FF), indent: 16, endIndent: 16,),
      Padding(
        padding: EdgeInsets.all(16),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.view_cozy_rounded, size: 28, color: Color(0xFF85C3FF),),
            SizedBox(width: 16),

            Flexible(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(AppLocalizations.of(context)!.photos, style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 8),

                Wrap(
                  children: [
                    Padding(padding: EdgeInsets.all(0),
                    child:
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(),
                        child: FittedBox(
                          child: Image.asset('assets/photos/photo2.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),),
                    Padding(padding: EdgeInsets.all(0),
                      child:
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(),
                          child: FittedBox(
                            child: Image.asset('assets/photos/photo1.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),),
                    Padding(padding: EdgeInsets.all(0),
                      child:
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(),
                          child: FittedBox(
                            child: Image.asset('assets/photos/photo1.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),),
                    Padding(padding: EdgeInsets.all(0),
                      child:
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(),
                          child: FittedBox(
                            child: Image.asset('assets/photos/photo1.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),),
                  ],
                ),

                //Text(widget.task.tDesc),
              ],),
            ),
            Visibility(
              visible: widget.task.tStatus=='started',
              child:
                  // == Add photo button
            IconButton.filled(
              icon: const Icon(Icons.add_a_photo),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Color(0xFF7E7BF4),
              ),
              //color: Colors.white,
              onPressed: () {},
            ),
            ),
          ],
        ),
      ),],
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
          ]),
        ),
      //),
      ],
    ),
          ),
      /*Flexible(
        child: Container(
          width: double.infinity,
          //color: Colors.orange,
        ),
      ),*/
      //const CurrentTaskCard(),
      Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child:
        Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
      if(widget.task.tStatus=='finished') ...[]
      else if(widget.par=='entertaskbyqr' && widget.task.tStatus=='planned') ... [
        // == Begin task with QR
        FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Color(0xFF7ACB82),
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(100, 56),
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
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold
              ),
              //style: TextStyle(color: Color(0xFF7B7B7B))
            ),
          ],
        ),
      ),
        SizedBox(height: 10),
        // == Cancel task button
        OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF85C3FF),
          side: BorderSide(width: 2.0, color: Color(0xFF85C3FF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(100, 56),
          //elevation: 5.0,
        ),
        onPressed: ()
        {
          // TODO make component (icon, textlabel, future handler)
          showGeneralDialog(
            context: context,
            barrierColor: Colors.black54,
            barrierDismissible: true,
            barrierLabel: 'Label',
            pageBuilder: (_, __, ___) {
              return
                FutureBuilder(
                  //future: Future.delayed(Duration(seconds: 3)).then((value) => true),
                  future: Provider.of<UserRepository>(context, listen: false).getAuthToken().then((auth_token){
                    if(auth_token.isNotEmpty) {
                      Provider.of<TasksRepository>(context, listen: false).stopTask(auth_token: auth_token, task_id: widget.task.id).then((auth_token){
                        Navigator.of(context!).pushNamedAndRemoveUntil(
                            '/tasklist', (Route<dynamic> route) => false);
                      });
                    }
                  }),
                  builder: (context, snapshot) {
                    //if (snapshot.hasData) {
                    //Navigator.of(context).pop();
                    //Navigator.pushNamedAndRemoveUntil(context, '/tasklist', (_) => false);
                    //}
                    return
                      Align(
                        alignment: Alignment.center,
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child:
                            SizedBox(
                              width: 180,
                              height: 180,
                              child:
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Image.asset('assets/icons/tick-square.png'),
                                    SizedBox(height: 20),
                                    Text(AppLocalizations.of(context)!.taskWaitAction, textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          ),
                        ),
                      );
                  },
                );
            },
          ); // -> move to component
        },
        //child: Text(AppLocalizations.of(context)!.reportProblem),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                AppLocalizations.of(context)!.cancelTask,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Color(0xFF7B7B7B), fontWeight: FontWeight.bold
                ),
            ),
          ],
        ),
      ),
      ]
      else if(widget.par=='entertask' && widget.task.tStatus=='planned') ... [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Color(0xFF7ACB82),
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size(100, 56),
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
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
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
        SizedBox(height: 10),
        // == Request start of task with no QR
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFF85C3FF),
            side: BorderSide(width: 2.0, color: Color(0xFF85C3FF)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size(100, 56),
            //elevation: 5.0,
          ),
          onPressed: () {
            // TODO make component (icon, textlabel, future handler)
            Future.delayed(Duration(seconds: 5), () {
            showCustomDialog(
              context,
              AppLocalizations.of(context)!.taskWaitAction, // Pass text label
              'assets/icons/tick-square.png', // Pass image asset path
                  (context) async {
                    Provider.of<UserRepository>(context, listen: false).getAuthToken().then((auth_token){
                      if(auth_token.isNotEmpty) {


                          Navigator.of(context).pop();
                          //Navigator.of(context!).pushNamedAndRemoveUntil('/tasklist', (Route<dynamic> route) => false);

                        //Provider.of<TasksRepository>(context, listen: false).startTaskNoQr(auth_token: auth_token, task_id: widget.task.id).then((auth_token){

                        //});
                      }
                    }); });
              },
            );
            /*showGeneralDialog(
              context: context,
              barrierColor: Colors.black54,
              barrierDismissible: true,
              barrierLabel: 'Label',
              pageBuilder: (_, __, ___) {
                return
                  FutureBuilder(
                    //future: Future.delayed(Duration(seconds: 3)).then((value) => true),
                      future: Provider.of<UserRepository>(context, listen: false).getAuthToken().then((auth_token){
                        if(auth_token.isNotEmpty) {
                          Provider.of<TasksRepository>(context, listen: false).startTaskNoQr(auth_token: auth_token, task_id: widget.task.id).then((auth_token){
                            Navigator.of(context!).pushNamedAndRemoveUntil(
                                '/tasklist', (Route<dynamic> route) => false);
                          });
                        }
                      }),
                    builder: (context, snapshot) {
                      //if (snapshot.hasData) {
                        //Navigator.of(context).pop();
                        //Navigator.pushNamedAndRemoveUntil(context, '/tasklist', (_) => false);
                      //}
                      return
                        Align(
                          alignment: Alignment.center,
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child:
                              SizedBox(
                                width: 180,
                                height: 180,
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Image.asset('assets/icons/tick-square.png'),
                                      SizedBox(height: 20),
                                      Text(AppLocalizations.of(context)!.taskWaitAction, textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                    ]),
                              ),
                            ),
                          ),
                        );
                    },
                  );
              },
            ); // -> move to component*/

          },
          //child: Text(AppLocalizations.of(context)!.reportProblem),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  AppLocalizations.of(context)!.beginTaskNoQR,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Color(0xFF7B7B7B), fontWeight: FontWeight.bold
                  ),
              ),
            ],
          ),
        ),
      ]
      else if(widget.task.tStatus=='stopped' ||  widget.task.tStatus=='failed' ||  widget.task.tStatus=='reqstop' ||  widget.task.tStatus=='reqnoqr') ... [
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF85C3FF),
              side: BorderSide(width: 2.0, color: Color(0xFF85C3FF)),
              minimumSize: Size(100, 56),
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
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Color(0xFF7B7B7B), fontWeight: FontWeight.bold
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
      else if(widget.task.tStatus=='started') ... [
        FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFF7E7BF4),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(100, 56),
                ),
                onPressed: () {
                },
                //child: Text(AppLocalizations.of(context)!.reportProblem),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.confirmCompletion,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold
                      ),
                      //style: TextStyle(color: Color(0xFF7B7B7B))
                    ),
                  ],
                ),
              ),
        SizedBox(height: 10),
        // == Cancel task button
        OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xFF85C3FF),
                  side: BorderSide(width: 2.0, color: Color(0xFF85C3FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(100, 56),
                  //elevation: 5.0,
                ),
                onPressed: () {
                  // TODO make component (icon, textlabel, future handler)
                  showGeneralDialog(
                    context: context,
                    barrierColor: Colors.black54,
                    barrierDismissible: true,
                    barrierLabel: 'Label',
                    pageBuilder: (_, __, ___) {
                      return
                        FutureBuilder(
                          //future: Future.delayed(Duration(seconds: 3)).then((value) => true),
                          future: Provider.of<UserRepository>(context, listen: false).getAuthToken().then((auth_token){
                            if(auth_token.isNotEmpty) {
                              Provider.of<TasksRepository>(context, listen: false).stopTask(auth_token: auth_token, task_id: widget.task.id).then((auth_token){
                                Navigator.of(context!).pushNamedAndRemoveUntil(
                                    '/tasklist', (Route<dynamic> route) => false);
                              });
                            }
                          }),
                          builder: (context, snapshot) {
                            //if (snapshot.hasData) {
                            //Navigator.of(context).pop();
                            //Navigator.pushNamedAndRemoveUntil(context, '/tasklist', (_) => false);
                            //}
                            return
                              Align(
                                alignment: Alignment.center,
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child:
                                    SizedBox(
                                      width: 180,
                                      height: 180,
                                      child:
                                      Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Image.asset('assets/icons/tick-square.png'),
                                            SizedBox(height: 20),
                                            Text(AppLocalizations.of(context)!.taskWaitAction, textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold)),
                                          ]),
                                    ),
                                  ),
                                ),
                              );
                          },
                        );
                    },
                  ); // -> move to component

                },
                //child: Text(AppLocalizations.of(context)!.reportProblem),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        AppLocalizations.of(context)!.cancelTask,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Color(0xFF7B7B7B), fontWeight: FontWeight.bold
                        ),
                    ),
                  ],
                ),
              ),
      ]
      else ... [],
    ]),),
        ]),

    );
  }
}

// TODO REMOVE
class PhotoItem {
  final String image;
  final String name;
  PhotoItem(this.image, this.name);
}