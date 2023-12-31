
import 'dart:io';

import 'package:flutter/foundation.dart';
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
//import 'package:flutter/painting.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.task, required this.par});

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
  Color statusBg = const Color(0xFFEBE8FB);
  Color statusColor = const Color(0xFF0B1F33);
  IconData statusIcon = Icons.drafts_outlined;

  @override
  bool get wantKeepAlive => true;

  void reinitializeVars() {
    if (!widget.task.isEmpty()) {
      statusBg =
          Color(TaskStatusList.statusesMap[widget.task.tStatus]!.statusBg);
      statusColor =
          Color(TaskStatusList.statusesMap[widget.task.tStatus]!.statusColor);
      statusIcon = TaskStatusList.getIconByStatus(widget.task.tStatus);
    }
  }

  @override
  void initState() {
    super.initState();
    cachedPhotos.clear();
    _userRepo.getUser().then(
            (User usr) =>
            setState(() {
              _usr = usr;
            })
    );
    reinitializeVars();
  }

  @override
  Widget build(BuildContext context) {
      super.build(context);
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
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  color: statusBg,
                  constraints: const BoxConstraints(minHeight: 80),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child:
                    Row(
                        children: [
                          Text(Utils.getTimeFromDate(widget.task.tDate),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //SizedBox(width: 16),
                          Expanded(
                            child:
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child:
                              Text(widget.task.tName,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                  color: statusColor,
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
              const SizedBox(height: 15),

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
                                padding: const EdgeInsets.all(16),
                                child:
                                Center(
                                  child:
                                  Text(
                                    AppLocalizations.of(context)!.taskCanceled,
                                    style: const TextStyle(fontSize: 20),),
                                ),
                              ),
                              const Divider(thickness: 1,
                                height: 1,
                                color: Color(0xFFC2E1FF),
                                indent: 16,
                                endIndent: 16,),
                            ],
                            if(widget.task.tStatus == 'reqstop' ||
                                widget.task.tStatus == 'reqnoqr') ...[
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child:
                                Center(
                                  child:
                                  Text(AppLocalizations.of(context)!
                                      .taskWaitAction,
                                    style: const TextStyle(fontSize: 20),),
                                ),
                              ),
                              const Divider(thickness: 1,
                                height: 1,
                                color: Color(0xFFC2E1FF),
                                indent: 16,
                                endIndent: 16,),
                            ],
                            Visibility(
                              visible: widget.task.tStatus == 'finished',
                              child:
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.access_time_outlined,
                                      color: Color(0xFF85C3FF),),
                                    const SizedBox(width: 16),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(AppLocalizations.of(context)!
                                              .leadTime, style: const TextStyle(
                                              fontWeight: FontWeight.bold),),
                                          Text('${Utils.getTimeFromDate(
                                              widget.task.tDate)} - ${Utils.getTimeFromDate(
                                                  widget.task.tDate.add(
                                                      const Duration(minutes: 15)))}'),
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.task.tStatus == 'finished',
                              child:
                              const Divider(thickness: 1,
                                height: 1,
                                color: Color(0xFFC2E1FF),
                                indent: 16,
                                endIndent: 16,),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_pin, size: 28,
                                    color: Color(0xFF85C3FF),),
                                  const SizedBox(width: 16),
                                  Expanded(child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.location,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      Text('${widget.task.tAddress}\n${widget.task.tZone}'),
                                    ],),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(thickness: 1,
                              height: 1,
                              color: Color(0xFFC2E1FF),
                              indent: 16,
                              endIndent: 16,),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.person_outline, size: 28,
                                    color: Color(0xFF85C3FF),),
                                  const SizedBox(width: 16),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.performer,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      Text('${_usr.uName} ${_usr.uSurname}'),
                                    ],),
                                ],
                              ),
                            ),
                            const Divider(thickness: 1,
                              height: 1,
                              color: Color(0xFFC2E1FF),
                              indent: 16,
                              endIndent: 16,),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.group, size: 28,
                                    color: Color(0xFF85C3FF),),
                                  const SizedBox(width: 16),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.coperformers,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      Text(widget.task.tCoperformers),
                                    ],),
                                ],
                              ),
                            ),
                            const Divider(thickness: 1,
                              height: 1,
                              color: Color(0xFFC2E1FF),
                              indent: 16,
                              endIndent: 16,),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.description, size: 28,
                                    color: Color(0xFF85C3FF),),
                                  const SizedBox(width: 16),

                                  Flexible(child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(AppLocalizations.of(context)!
                                          .description, style: const TextStyle(
                                          fontWeight: FontWeight.bold),),
                                      Text(widget.task.tDesc),
                                    ],),
                                  ),
                                ],
                              ),
                            ),
// [PHOTO SECTION (begin)]
                            if(widget.task.tStatus == 'started' ||
                                widget.task.tStatus == 'finished') ... [
                              const Divider(thickness: 1,
                                height: 1,
                                color: Color(0xFFC2E1FF),
                                indent: 16,
                                endIndent: 16,),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16,16,16,0),
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.view_cozy_rounded, size: 28,
                                      color: Color(0xFF85C3FF),),
                                    const SizedBox(width: 16),
                                    Flexible(child:
                                      Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                      Text(AppLocalizations.of(context)!.photos, style: const TextStyle(fontWeight: FontWeight.bold),),
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
                                          backgroundColor: const Color(0xFF7E7BF4),
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
                              Consumer<PhotoRepository>(
                                builder: (context, photoRepository, child) {
                                  // You can access photoRepository here, which is an instance of PhotoRepository
                                  debugPrint('Consumer builder called');
                                  return displayPhotosForTask(widget.task, context);
                                },
                              ),
                              /*Padding(
                              padding: EdgeInsets.fromLTRB(0,0,0,0),
                              child: ),*/

                            ],
// [PHOTO SECTION (end)]
                            const SizedBox(height: 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                              backgroundColor: const Color(0xFF7ACB82),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(100, 56),
                              //elevation: 5.0,
                            ),
                            onPressed: () {
                              showCustomDialog(
                                context,
                                AppLocalizations.of(context)!.taskStartedAction,
                                'assets/icons/tick-square.png',
                                    (BuildContext context) async {
                                  // Ensure the futureHandler returns a Future<String>
                                  await Future.delayed(const Duration(seconds: 2));
                                  final String auth_token = await _userRepo.getAuthToken();
                                    if (auth_token.isNotEmpty) {
                                      final result = await _tasksRepo.startTask(
                                      auth_token: auth_token,
                                      task_id: widget.task.id);
                                      widget.task.setStartedState();
                                        reinitializeVars();
                                        setState(() {});
                                      return 'NoNav';
                                    }

                                  return 'Callback started';
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
                          const SizedBox(height: 10),
                          // == Cancel planned task if entered with QR
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF85C3FF),
                              side: const BorderSide(width: 2.0, color: Color(
                                  0xFF85C3FF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(100, 56),
                              //elevation: 5.0,
                            ),
                            onPressed: () {
                              showCustomDialog(
                                context,
                                AppLocalizations.of(context)!.taskWaitAction,
                                'assets/icons/tick-square.png',
                                    (BuildContext context) async {
                                  await Future.delayed(const Duration(seconds: 2));
                                  final String auth_token = await _userRepo.getAuthToken();
                                    if (auth_token.isNotEmpty) {

                                      final result = await _tasksRepo.stopTask(
                                          auth_token: auth_token,
                                          task_id: widget.task.id);
                                      if(mounted) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, '/tasklist',
                                            ModalRoute.withName('/home'));
                                      }
                                      return 'NoNav';
                                    }
                                  return 'Callback stopped';
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
                                      color: const Color(0xFF7B7B7B),
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
                                backgroundColor: const Color(0xFF7ACB82),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(100, 56),
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
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon( // <-- Icon
                                    Icons.qr_code_scanner,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            // == Request start of task with no QR
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF85C3FF),
                                side: const BorderSide(
                                    width: 2.0, color: Color(0xFF85C3FF)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(100, 56),
                                //elevation: 5.0,
                              ),
                              onPressed: () {
                                showCustomDialog(
                                  context,
                                  AppLocalizations.of(context)!.taskWaitAction,
                                  'assets/icons/tick-square.png',
                                      (BuildContext context) async {
                                    // Ensure the futureHandler returns a Future<String>
                                    await Future.delayed(const Duration(seconds: 2));
                                    final String auth_token = await _userRepo.getAuthToken();
                                      if (auth_token.isNotEmpty) {
                                        final result = await _tasksRepo.startTaskNoQr(
                                            auth_token: auth_token,
                                            task_id: widget.task.id);
                                          /*Navigator.pushNamedAndRemoveUntil(
                                              context, '/tasklist',
                                              ModalRoute.withName('/home'));*/
                                            return 'NoNav';
                                      }

                                    return 'Callback begin no QR';
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
                                        color: const Color(0xFF7B7B7B),
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
                                  foregroundColor: const Color(0xFF85C3FF),
                                  side: const BorderSide(
                                      width: 2.0, color: Color(0xFF85C3FF)),
                                  minimumSize: const Size(100, 56),
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
                                          .reportIssue,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                          color: const Color(0xFF7B7B7B),
                                          fontWeight: FontWeight.bold
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
                            ]
                            else
                              if(widget.task.tStatus == 'started') ... [
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF7E7BF4),
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: const Size(100, 56),
                                  ),
                                  onPressed: () {
                                    showCustomDialog(
                                      context,
                                      AppLocalizations.of(context)!
                                          .taskFinishAction,
                                      'assets/icons/tick-square.png',
                                          (BuildContext context) async {
                                        // Ensure the futureHandler returns a Future<String>
                                        await Future.delayed(const Duration(seconds: 2));
                                        final String auth_token = await _userRepo.getAuthToken();
                                        if (auth_token.isNotEmpty) {
                                          final result = await _tasksRepo.finishTask(
                                              auth_token: auth_token,
                                              task_id: widget.task.id);
                                          if(mounted) {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context, '/tasklist',
                                                ModalRoute.withName('/home'));
                                          }
                                          return 'NoNav';
                                        }
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
                                const SizedBox(height: 10),
                                // == Cancel started task
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF85C3FF),
                                    side: const BorderSide(
                                        width: 2.0, color: Color(0xFF85C3FF)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: const Size(100, 56),
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
                                        await Future.delayed(const Duration(seconds: 2));
                                        final String auth_token = await _userRepo.getAuthToken();
                                        if (auth_token.isNotEmpty) {
                                          final result = await _tasksRepo.stopTask(
                                              auth_token: auth_token,
                                              task_id: widget.task.id);
                                          if(mounted) {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context, '/tasklist',
                                                ModalRoute.withName('/home'));
                                          }
                                          return 'NoNav';
                                        }
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
                                            color: const Color(0xFF7B7B7B),
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
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          return Text(AppLocalizations.of(context)!
              .noPhotosAvailable);
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
                        padding: const EdgeInsets.all(8),
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
                                decoration: const BoxDecoration(),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.file(File(photo.photoPath)),
                                ),
                              ),
                            ),
                            if (photo.isUploaded || photo.photoPath.contains('_upl')) // Show the checkmark if isUploaded is true
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
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
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this photo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
              child: const Text('Delete'),
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
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(initialPage: initialIndex),
          ),
        );
      },
    ));
  }
}
