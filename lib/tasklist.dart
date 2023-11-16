import 'dart:async';

import 'package:TeamCoord/common_widgets/combobox.dart';
import 'package:TeamCoord/common_widgets/customappbar.dart';
import 'package:TeamCoord/models/comboboxitem.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'utils/utils.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'supplemental/screenarguments.dart';
import 'constants/constants.dart';

class TasksList extends StatefulWidget {
  TasksList({Key? key}) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final UserRepository _userRepo = UserRepository();
  final TasksRepository _tasksRepo = TasksRepository();

  final _tasksController = StreamController<List<Task>>();

  late Timer _timer;

  late int _numTasks;
  late List<Task> _tasks;
  late List<Task> _filteredTasks;

  List<ComboBoxItem> _objects = [];
  late ComboBoxItem _curObject;

  User _usr = User.empty;
  final String _curDtStr =
      DateFormat.MMMMd(Platform.localeName).format(DateTime.now());
  String localeName =
      Platform.localeName; //Localizations.localeOf(context).languageCode;

  bool _isFetching = false;
  void fetchAndRefresh() async {
    if (_isFetching) {
      return; // Function is already running
    }
    if (mounted) {
      _isFetching =
          true; // Set the flag to indicate that the function is running
      final String auth_token = await _userRepo.getAuthToken();

      if (auth_token.isNotEmpty) {
        final int val = await _tasksRepo.getTasksAPI(auth_token: auth_token);

        // Add a delay of 500 milliseconds before updating the UI
        //await Future.delayed(Duration(milliseconds: 500));

        final List<Task> tasks = await _tasksRepo.getTasks();
        final List<String> s_objects = await _tasksRepo.getObjects();
        List<ComboBoxItem> objects = [];
        for (String sObject in s_objects) {
          // Create a ComboBoxItem with the same text and value
          ComboBoxItem comboBoxItem = ComboBoxItem(sObject, sObject);
          // Add the ComboBoxItem to the list of objects
          objects.add(comboBoxItem);
        }
        _tasksController.sink.add(tasks);

        final Map<String, dynamic> stateChanges = {};

        if (mounted) {
          if (!_tasksRepo.areListsEqual(_tasks, tasks)) {
            stateChanges['_tasks'] = tasks;
            stateChanges['_numTasks'] = tasks.length;
            stateChanges['_filteredTasks'] = tasks;
          }
        }

        if (mounted) {
          if (!compareComboBoxLists(_objects, objects)) {
            stateChanges['_objects'] = objects;
            stateChanges['_curObject'] = objects.isNotEmpty
                ? objects[0]
                : ComboBoxItem(AppLocalizations.of(context)!.withoutFilter,AppLocalizations.of(context)!.withoutFilter);
          }
        }
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          setState(() {
            stateChanges.forEach((key, value) {
              switch (key) {
                case '_tasks':
                  _tasks = value;
                  break;
                case '_numTasks':
                  _numTasks = value;
                  break;
                case '_filteredTasks':
                  _filteredTasks = value;
                  break;
                case '_objects':
                  _objects = value;
                  break;
                case '_curObject':
                  _curObject = value;
                  break;
              }
            });
          });
        }
      }
      /*_timer = Timer.periodic(Duration(seconds: 15), (timer) {
        // Fetch and update the task data periodically
        fetchAndRefresh();
      });*/
      _isFetching = false;
    }
  }

  /*Future<void> fetchAndRefresh() async {
    _userRepo.getAuthToken().then((String value) {
      if (value.isNotEmpty) {
          _tasksRepo.getTasksAPI(auth_token: value).then((int val) {
            // Add a delay of 500 milliseconds before updating the UI
            //if (mounted) {
              _tasksRepo.getTasks().then((List<Task> tasks) {
                if (mounted) {
                  if(!await _tasksRepo.areListsEqual(_tasks, tasks)) {
                    setState(() {
                      _tasks = tasks;
                      _numTasks = _tasks.length;
                      _filteredTasks = tasks;
                    });
                  }
                }
              });
              _tasksRepo.getObjects().then((List<String> objects) {
                if(mounted) {
                  if(!Utils.areStringListsEqual(_objects, objects)) {
                    setState(() {
                      _objects = objects;
                      _curObject = _objects.isNotEmpty
                          ? _objects[0]
                          : AppLocalizations.of(context)!.withoutFilter;
                    });
                  }
                }
              });
            //}
          _timer = Timer.periodic(Duration(seconds: 30), (timer) {
            // Fetch and update the task data periodically
            fetchAndRefresh();
          });
        });
      }
    });
  }
*/
  @override
  void initState() {
    super.initState();
    _numTasks = 0;
    _tasks = [];
    _filteredTasks = [];
    _curObject = ComboBoxItem('-- no filter --', '-- no filter --');
    _userRepo.getUser().then((User usr) {
      if (mounted) {
        setState(() {
          _usr = usr;
        });
      }
    });
    fetchAndRefresh();
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      // Fetch and update the task data periodically
      fetchAndRefresh();
    });
    //_tasksRepo.generateDemoTasks();
    // TODO (remove) moved to Future function
    /*_userRepo.getAuthToken().then((String value) => setState(()
      {
        if(value.isNotEmpty) {
          _tasksRepo.getTasksAPI(auth_token: value).then((int val) => setState(()
            {
              _numTasks = val;
              _tasksRepo.getTasks().then(
                      (List<Task> tasks) => setState(() {_tasks = tasks; _filteredTasks = tasks;})
              );
              _tasksRepo.getObjects().then(
                      (List<String> objects) => setState((){_objects = objects; _curObject = _objects.isNotEmpty ? _objects[0] : AppLocalizations.of(context)!.withoutFilter;})
              );
            }
          ));
        }
      }
      ));*/
    /*_tasksRepo.getTasks().then(
        (List<Task> tasks) => setState(() {_tasks = tasks; _filteredTasks = tasks;})
    );
    _tasksRepo.getNumTasks().then(
            (int numTasks) => setState(() {_numTasks = numTasks;})
    );*/
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _isFetching = false;
    super.dispose();
  }

  @override
  void deactivate() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _isFetching = false;
    super.deactivate();
  }

  void filterTasks() {
    if (_curObject.value == AppLocalizations.of(context)!.withoutFilter) {
      // No filter selected, show all tasks
      setState(() {
        _filteredTasks = _tasks;
      });
    } else {
      // Filter tasks based on selected category
      setState(() {
        _filteredTasks =
            _tasks.where((task) => task.tAddress == _curObject.value).toList();
      });
    }
    _numTasks = _filteredTasks.length;
  }

  @override
  Widget build(BuildContext context) {
    //Color selectedColor = Theme.of(context).primaryColor;
    /*ThemeData lightTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.light,
    );*/
    //ColorScheme colorScheme = lightTheme.colorScheme;
    if (_curObject.value == 'no filter')
      _curObject = ComboBoxItem(AppLocalizations.of(context)!.withoutFilter, AppLocalizations.of(context)!.withoutFilter);
    if (_objects.length > 0) {
      _objects[0] = ComboBoxItem(AppLocalizations.of(context)!.withoutFilter,AppLocalizations.of(context)!.withoutFilter);
    }

    return Scaffold(
      appBar: CustomAppBar(autoLeading: true, context: context),
      body:
          //Expanded(child:
          /*Consumer<TasksRepository>(
          builder: (context, taskRepository, child) {
            _userRepo.getAuthToken().then((String value) {
              if (value.isNotEmpty) {
                _tasksRepo.getTasksAPI(auth_token: value).then((int val) {
                  _numTasks = val;
                  Future.delayed(const Duration(milliseconds: 500), () {
                    // Add a delay of 500 milliseconds before updating the UI
                    if (mounted) {
                      _tasksRepo.getTasks().then((List<Task> tasks) {
                        if (mounted) {
                          setState(() {
                            _tasks = tasks;
                            _filteredTasks = tasks;
                          });
                        }
                      });
                      _tasksRepo.getObjects().then((List<String> objects) {
                        if(mounted) {
                          setState(() {
                            _objects = objects;
                            _curObject = _objects.isNotEmpty
                                ? _objects[0]
                                : AppLocalizations.of(context)!.withoutFilter;
                          });
                        }
                      });
                    }
                  });
                });
              }
            });
            return */

          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            color: Color(0xFFECEBFB),
            constraints: BoxConstraints(minHeight: 80),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF85C3FF),
                  foregroundColor: Colors.white,
                  child: Text(_userRepo.getUserLabel(),
                      style: TextStyle(fontSize: 19)),
                ),
                SizedBox(width: 16),
                Text(
                  _usr.uName.toString() + ' ' + _usr.uSurname.toString(),
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.normal, fontSize: 19),
                ),
              ]),
            ),
          ),
        ),
        Container(
          color: Color(0xFFFDFBFE),
          child: SizedBox(height: 15),
        ),
        Container(
          color: Color(0xFFFDFBFE),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Text(_curDtStr),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    AppLocalizations.of(context)!.today,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Text(
                      AppLocalizations.of(context)!.tasks +
                          ': ' +
                          _numTasks.toString(),
                      softWrap: false,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Color(0xFFFDFBFE),
          child: SizedBox(height: 17),
        ),
        Divider(color: Color(0xFFC2E1FF), height: 1, thickness: 1),
        Container(
          color: Color(0xFFF5F5FD),
          child: SizedBox(height: 8),
        ),
        Container(
          color: Color(0xFFF5F5FD),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Combobox(
              items: _objects,
              onItemSelected: (ComboBoxItem? selectedValue) {
                if (selectedValue != null) {
                  _curObject = selectedValue;
                  filterTasks();
                }
              },
              selectedItem: _curObject,
              label: '',
            ),
          ),
        ),
        Container(
          color: Color(0xFFF5F5FD),
          child: SizedBox(height: 8),
        ),
        Expanded(
          child: Container(
            color: Color(0xFFF5F5FD),
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.atEdge) {
                  bool isTop = metrics.pixels == 0;
                  if (isTop) {
                    fetchAndRefresh();
                    //print('At the top');
                  } else {
                    //print('At the bottom');
                  }
                }
                return true;
              },
              child: ListView.separated(
                itemCount: _filteredTasks.length,
                //physics: ClampingScrollPhysics(),
                //shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print('Tapped on item #$index');
                      Navigator.pushNamed(context, '/task',
                          arguments: ScreenArguments(
                              _filteredTasks[index], 'entertask'));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0),
                      child: Card(
                        color: Color(0xFFFFFFFF),
                        shadowColor: Color(0xFF000000),
                        surfaceTintColor: Color(0xFFFFFFFF),
                        //elevation: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  //crossAxisAlignment: CrossAxisAlignment.baseline,
                                  //textBaseline: TextBaseline.alphabetic,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 0),
                                      child: Text(
                                          Utils.isNotCurrentDay(
                                                  _filteredTasks[index].tDate)
                                              ? Utils.getDateFormat(
                                                      _filteredTasks[index]
                                                          .tDate,
                                                      "dd/MM") +
                                                  "\n" +
                                                  Utils.getTimeFromDate(
                                                      _filteredTasks[index]
                                                          .tDate)
                                              : Utils.getTimeFromDate(
                                                  _filteredTasks[index].tDate),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(TaskStatusList
                                                  .StatusesMap[_filteredTasks[index].tStatus]!
                                                  .listColor))),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                _filteredTasks[index].tName +
                                                    "\n(" +
                                                    _filteredTasks[index]
                                                        .tStatus +
                                                    ":" +
                                                    _filteredTasks[index]
                                                        .id
                                                        .toString() +
                                                    ")",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(TaskStatusList
                                                        .StatusesMap[
                                                            _filteredTasks[
                                                                    index]
                                                                .tStatus]!
                                                        .listColor))),
                                            Text(
                                                _filteredTasks[index].tAddress +
                                                    '\n' +
                                                    _filteredTasks[index].tZone,
                                                style: TextStyle(
                                                    color: Color(0xFF66727F),
                                                    fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_filteredTasks[index].tStatus ==
                                        'planned') ...[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 10, 0),
                                        child: IconButton.filled(
                                          icon:
                                              const Icon(Icons.qr_code_scanner),
                                          style: IconButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            backgroundColor: Color(0xFF7ACB82),
                                          ),
                                          //color: Colors.white,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/qrscan');
                                          },
                                        ),
                                      ),
                                    ] else ...[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 5, 20, 5),
                                        child: Icon(
                                          TaskStatusList.GetIconByStatus(
                                              _filteredTasks[index].tStatus),
                                          //  IconData(TaskStatusList.StatusesMap[_tasks[index].tStatus]!.statusIcon, fontFamily: 'MaterialIcons'),
                                          color: Color(TaskStatusList
                                              .StatusesMap[_filteredTasks[index]
                                                  .tStatus]!
                                              .listIconColor),

                                          size: 28,
                                        ),
                                      ),
                                    ],
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
                  return const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(height: 5));
                },
              ),
            ),
          ),
        ),
      ]),
      //}),

      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/qrscan');
        },
        child: const Icon(Icons.qr_code),
      ),*/
    );
  }
}
