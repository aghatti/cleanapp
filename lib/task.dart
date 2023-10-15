
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'common_widgets/customappbar.dart';
import 'common_widgets/customdialog.dart';
import 'utils/utils.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:photo_repository/photo_repository.dart';
import 'package:provider/provider.dart';
import 'constants/constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';

class TaskPage extends StatefulWidget {
  TaskPage({super.key, required this.task, required this.par});

  final Task task;
  final String par;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with AutomaticKeepAliveClientMixin {
  final UserRepository _userRepo = UserRepository();
  final TasksRepository _tasksRepo = TasksRepository();

  List<Photo> cachedPhotos = [];

  User _usr = User.empty;
  Color statusBg = Color(0xFFEBE8FB);
  Color statusColor = Color(0xFF0B1F33);
  IconData statusIcon = Icons.drafts_outlined;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    cachedPhotos.clear();
    _userRepo.getUser().then(
            (User usr) =>
            setState(() {
              _usr = usr;
            })
    );
    if (!widget.task.isEmpty()) {
      statusBg =
          Color(TaskStatusList.StatusesMap[widget.task.tStatus]!.statusBg);
      statusColor =
          Color(TaskStatusList.StatusesMap[widget.task.tStatus]!.statusColor);
      statusIcon = TaskStatusList.GetIconByStatus(widget.task.tStatus);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      /*return WillPopScope(
      onWillPop: () async {
        // Set the flag to true when returning from the image gallery
        setState(() {
          //shouldFetchPhotos = true;
        });

        // Set the result to true if changes were made; otherwise, set it to false
        //bool changesMadeInGallery = /* determine if changes were made */;
        Navigator.of(context).pop(true);

        return true;
      },
      child: */
      return Scaffold(
        appBar: CustomAppBar(autoLeading: true, context: context),
        body:
        Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // == Task header (begin)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  color: this.statusBg,
                  constraints: BoxConstraints(minHeight: 80),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child:
                    Row(
                        children: [
                          Text(Utils.getTimeFromDate(widget.task.tDate),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
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
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                  color: this.statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),),
                          Visibility(
                            visible: widget.task.tStatus != 'planned',
                            child:
                            Icon(statusIcon,
                                color: statusColor),
                          ),
                        ]
                    ),),),
              ),
              // == Task header (end)
              SizedBox(height: 15),

              // Task content (begin)
              Expanded(
                child:
                    // TODO comment 5 lines
                /*CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,*/
                    SingleChildScrollView(
                        child:
                      Column(
                          children: [
                            if(widget.task.tStatus == 'stopped' ||
                                widget.task.tStatus == 'failed') ...[
                              Padding(
                                padding: EdgeInsets.all(16),
                                child:
                                Center(
                                  child:
                                  Text(
                                    AppLocalizations.of(context)!.taskCanceled,
                                    style: TextStyle(fontSize: 20),),
                                ),
                              ),
                              Divider(thickness: 1,
                                height: 1,
                                color: Color(0xFFC2E1FF),
                                indent: 16,
                                endIndent: 16,),
                            ],
                            if(widget.task.tStatus == 'reqstop' ||
                                widget.task.tStatus == 'reqnoqr') ...[
                              Padding(
                                padding: EdgeInsets.all(16),
                                child:
                                Center(
                                  child:
                                  Text(AppLocalizations.of(context)!
                                      .taskWaitAction,
                                    style: TextStyle(fontSize: 20),),
                                ),
                              ),
                              Divider(thickness: 1,
                                height: 1,
                                color: Color(0xFFC2E1FF),
                                indent: 16,
                                endIndent: 16,),
                            ],
                            Visibility(
                              visible: widget.task.tStatus == 'finished',
                              child:
                              Padding(
                                padding: EdgeInsets.all(16),
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.access_time_outlined,
                                      color: Color(0xFF85C3FF),),
                                    SizedBox(width: 16),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(AppLocalizations.of(context)!
                                              .leadTime, style: TextStyle(
                                              fontWeight: FontWeight.bold),),
                                          Text(Utils.getTimeFromDate(
                                              widget.task.tDate) + ' - ' +
                                              Utils.getTimeFromDate(
                                                  widget.task.tDate.add(
                                                      Duration(minutes: 15)))),
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.task.tStatus == 'finished',
                              child:
                              Divider(thickness: 1,
                                height: 1,
                                color: Color(0xFFC2E1FF),
                                indent: 16,
                                endIndent: 16,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_pin, size: 28,
                                    color: Color(0xFF85C3FF),),
                                  SizedBox(width: 16),
                                  Expanded(child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.location,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      Text(widget.task.tAddress + '\n' +
                                          widget.task.tZone),
                                    ],),
                                  ),
                                ],
                              ),
                            ),
                            Divider(thickness: 1,
                              height: 1,
                              color: Color(0xFFC2E1FF),
                              indent: 16,
                              endIndent: 16,),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.person_outline, size: 28,
                                    color: Color(0xFF85C3FF),),
                                  SizedBox(width: 16),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.performer,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      Text(_usr!.uName.toString() + ' ' +
                                          _usr!.uSurname.toString()),
                                    ],),
                                ],
                              ),
                            ),
                            Divider(thickness: 1,
                              height: 1,
                              color: Color(0xFFC2E1FF),
                              indent: 16,
                              endIndent: 16,),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.description, size: 28,
                                    color: Color(0xFF85C3FF),),
                                  SizedBox(width: 16),

                                  Flexible(child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(AppLocalizations.of(context)!
                                          .description, style: TextStyle(
                                          fontWeight: FontWeight.bold),),
                                      Text(widget.task.tDesc),
                                    ],),
                                  ),
                                ],
                              ),
                            ),
                            // PHOTO SECTION
                            if(widget.task.tStatus == 'started' ||
                                widget.task.tStatus == 'finished') ... [
                              Divider(thickness: 1,
                                height: 1,
                                color: Color(0xFFC2E1FF),
                                indent: 16,
                                endIndent: 16,),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.view_cozy_rounded, size: 28,
                                      color: Color(0xFF85C3FF),),
                                    SizedBox(width: 16),

                                    Flexible(child:
                                      Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                      Text(AppLocalizations.of(context)!.photos, style: TextStyle(fontWeight: FontWeight.bold),),
                                      SizedBox(height: 8),

                                    Consumer<PhotoRepository>(
                                      builder: (context, photoRepository, child) {
                                        // You can access photoRepository here, which is an instance of PhotoRepository
                                          print('Consumer builder called');
                                          return displayPhotosForTask(widget.task, context);
                                      },
                                    ),
                                    ]),),
                                    //displayPhotosForTask(widget.task.id, context),

                                    Visibility(
                                      visible: widget.task.tStatus == 'started',
                                      child:
                                      // == Add photo button
                                      IconButton.filled(
                                        icon: const Icon(Icons.add_a_photo),
                                        style: IconButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12),
                                          ),
                                          backgroundColor: Color(0xFF7E7BF4),
                                        ),
                                        //color: Colors.white,
                                        onPressed: () {
                                          Provider.of<PhotoRepository>(
                                              context, listen: false)
                                              .captureAndStorePhoto(
                                              widget.task.id);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            SizedBox(height: 10),
                          ]),


                    ),
                          // TODO comment 2 lines
                  /*],
                ),*/

              ),
              // Task content (end)

              //const CurrentTaskCard(),
              // == Task action buttons (begin)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if(widget.task.tStatus == 'finished') ...[]
                      else
                        if(widget.par == 'entertaskbyqr' &&
                            widget.task.tStatus == 'planned') ... [
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
                              showCustomDialog(
                                context,
                                AppLocalizations.of(context)!.taskWaitAction,
                                'assets/icons/tick-square.png',
                                    (BuildContext context) async {
                                  // Ensure the futureHandler returns a Future<String>
                                  await Future.delayed(Duration(seconds: 2));
                                  await Provider.of<UserRepository>(
                                      context, listen: false)
                                      .getAuthToken()
                                      .then((auth_token) {
                                    if (auth_token.isNotEmpty) {
                                      Provider.of<TasksRepository>(
                                          context, listen: false).startTask(
                                          auth_token: auth_token,
                                          task_id: widget.task.id).then((
                                          auth_token) {
                                        //Navigator.of(context).popUntil((route) => route.settings.name == '/tasklist');
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, '/tasklist',
                                            ModalRoute.withName('/home'));
                                        return 'NoNav';
                                      });
                                    }
                                  });
                                  return 'Callback finished';
                                },
                              );
                            },
                            //child: Text(AppLocalizations.of(context)!.reportProblem),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.beginTask,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                  //style: TextStyle(color: Color(0xFF7B7B7B))
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          // == Cancel planned task if entered with QR
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Color(0xFF85C3FF),
                              side: BorderSide(width: 2.0, color: Color(
                                  0xFF85C3FF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: Size(100, 56),
                              //elevation: 5.0,
                            ),
                            onPressed: () {
                              showCustomDialog(
                                context,
                                AppLocalizations.of(context)!.taskWaitAction,
                                'assets/icons/tick-square.png',
                                    (BuildContext context) async {
                                  // Ensure the futureHandler returns a Future<String>
                                  await Future.delayed(Duration(seconds: 2));
                                  await Provider.of<UserRepository>(
                                      context, listen: false)
                                      .getAuthToken()
                                      .then((auth_token) {
                                    if (auth_token.isNotEmpty) {
                                      Provider.of<TasksRepository>(
                                          context, listen: false).stopTask(
                                          auth_token: auth_token,
                                          task_id: widget.task.id).then((
                                          auth_token) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, '/tasklist',
                                            ModalRoute.withName('/home'));
                                        return 'NoNav';
                                      });
                                    }
                                  });
                                  return 'Callback finished';
                                },
                              );
                            },
                            //child: Text(AppLocalizations.of(context)!.reportProblem),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.cancelTask,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                      color: Color(0xFF7B7B7B),
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                        else
                          if(widget.par == 'entertask' &&
                              widget.task.tStatus == 'planned') ... [
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
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white,
                                        fontWeight: FontWeight.bold),
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
                                side: BorderSide(
                                    width: 2.0, color: Color(0xFF85C3FF)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: Size(100, 56),
                                //elevation: 5.0,
                              ),
                              onPressed: () {
                                showCustomDialog(
                                  context,
                                  AppLocalizations.of(context)!.taskWaitAction,
                                  'assets/icons/tick-square.png',
                                      (BuildContext context) async {
                                    // Ensure the futureHandler returns a Future<String>
                                    await Future.delayed(Duration(seconds: 2));
                                    await Provider.of<UserRepository>(
                                        context, listen: false)
                                        .getAuthToken()
                                        .then((auth_token) {
                                      if (auth_token.isNotEmpty) {
                                        Provider.of<TasksRepository>(
                                            context, listen: false)
                                            .startTaskNoQr(
                                            auth_token: auth_token,
                                            task_id: widget.task.id)
                                            .then((auth_token) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context, '/tasklist',
                                              ModalRoute.withName('/home'));
                                        });
                                        return 'NoNav';
                                      }
                                    });
                                    return 'Callback finished';
                                  },
                                );
                              },
                              //child: Text(AppLocalizations.of(context)!.reportProblem),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.beginTaskNoQR,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                        color: Color(0xFF7B7B7B),
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                          else
                            if(widget.task.tStatus == 'stopped' ||
                                widget.task.tStatus == 'failed' ||
                                widget.task.tStatus == 'reqstop' ||
                                widget.task.tStatus == 'reqnoqr') ... [
                              // TODO report problem
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Color(0xFF85C3FF),
                                  side: BorderSide(
                                      width: 2.0, color: Color(0xFF85C3FF)),
                                  minimumSize: Size(100, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  //elevation: 5.0,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/report_problem');
                                },
                                //child: Text(AppLocalizations.of(context)!.reportProblem),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .reportProblem,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                          color: Color(0xFF7B7B7B),
                                          fontWeight: FontWeight.bold
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
                            else
                              if(widget.task.tStatus == 'started') ... [
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
                                    showCustomDialog(
                                      context,
                                      AppLocalizations.of(context)!
                                          .taskFinishAction,
                                      'assets/icons/tick-square.png',
                                          (BuildContext context) async {
                                        // Ensure the futureHandler returns a Future<String>
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        await Provider.of<UserRepository>(
                                            context, listen: false)
                                            .getAuthToken()
                                            .then((auth_token) {
                                          if (auth_token.isNotEmpty) {
                                            Provider.of<TasksRepository>(
                                                context, listen: false)
                                                .finishTask(
                                                auth_token: auth_token,
                                                task_id: widget.task.id)
                                                .then((auth_token) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context, '/tasklist',
                                                  ModalRoute.withName('/home'));
                                            });
                                            return 'NoNav';
                                          }
                                        });
                                        return 'Callback finished';
                                      },
                                    );
                                  },
                                  //child: Text(AppLocalizations.of(context)!.reportProblem),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .confirmCompletion,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                        //style: TextStyle(color: Color(0xFF7B7B7B))
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                // == Cancel started task
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Color(0xFF85C3FF),
                                    side: BorderSide(
                                        width: 2.0, color: Color(0xFF85C3FF)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: Size(100, 56),
                                    //elevation: 5.0,
                                  ),
                                  onPressed: () {
                                    showCustomDialog(
                                      context,
                                      AppLocalizations.of(context)!
                                          .taskWaitAction,
                                      'assets/icons/tick-square.png',
                                          (BuildContext context) async {
                                        // Ensure the futureHandler returns a Future<String>
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        await Provider.of<UserRepository>(
                                            context, listen: false)
                                            .getAuthToken()
                                            .then((auth_token) {
                                          if (auth_token.isNotEmpty) {
                                            Provider.of<TasksRepository>(
                                                context, listen: false)
                                                .stopTask(
                                                auth_token: auth_token,
                                                task_id: widget.task.id)
                                                .then((auth_token) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context, '/tasklist',
                                                  ModalRoute.withName('/home'));
                                            });
                                            return 'NoNav';
                                          }
                                        });
                                        return 'Callback finished';
                                      },
                                    );
                                  },
                                  //child: Text(AppLocalizations.of(context)!.reportProblem),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .cancelTask,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                            color: Color(0xFF7B7B7B),
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                              else
                                ... [],
                    ]),),
              // == Task action buttons (end)
            ]),

      );
    //);
  }


  Widget displayPhotosForTask(Task task, BuildContext context) {
    return FutureBuilder<List<Photo>>(
      future: Provider.of<PhotoRepository>(context, listen: false).getCurrentPhotos(task.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          return Text('No photos available for this task.');
        } else {
          //Provider.of<PhotoRepository>(context, listen: false).notifyListeners();
          cachedPhotos = snapshot.data!;
          return
            /*Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.photos,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),*/


                Wrap(
                  children: snapshot.data!.map((photo) {
                    return GestureDetector(
                      onTap: () {
                        openImageGallery(context, snapshot.data!,
                            snapshot.data!.indexOf(photo));
                      },
                      onLongPress: () {
                        // Show a confirmation dialog
                        showDeleteConfirmationDialog(context, photo, snapshot);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Stack(
                          children: [
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(),
                                child: FittedBox(
                                  child: Image.file(File(photo.photoPath)),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            if (photo.isUploaded) // Show the checkmark if isUploaded is true
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );


              /*],
            ),
          );*/
        }
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, Photo photo, AsyncSnapshot<List<Photo>> snapshot) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this photo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss the dialog
                await Provider.of<PhotoRepository>(context, listen: false).deletePhoto(photo);
                //snapshot.data!.remove(photo);
                /*imageCache!.clear();
                imageCache!.clearLiveImages();
                PaintingBinding.instance.imageCache.clear();*/
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  void openImageGallery(BuildContext context, List<Photo> photos,
      int initialIndex) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop(
                true); // Return 'false' indicating no changes were made
            return true; // Allow the back button press
          },
          child: PhotoViewGallery.builder(
            itemCount: photos.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(photos[index].photoPath)),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(initialPage: initialIndex),
          ),
        );
      },
    ));
  }
}
