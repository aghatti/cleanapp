import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'utils/utils.dart';
import 'supplemental/screenarguments.dart';
import 'common_widgets/customappbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserRepository _userRepo = UserRepository();
  final TasksRepository _tasksRepo = TasksRepository();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  late String authToken = '';
  late Timer _timer;

  User _usr = User.empty;
  DateTime _curDt = DateTime.now();
  String localeName = Platform.localeName; //Localizations.localeOf(context).languageCode;

  final String _curDtStr = DateFormat.MMMMd(Platform.localeName).format(DateTime.now());
  int _numTasks = 0;
  Task _curTask = Task.empty;

  bool _isFetching = false;
  // Update data for UI and then run by timer repeatedly
  Future<void> fetchAndRefresh() async {
    //if (_isFetching) {
    //  return; // Function is already running
    //}

    if (!mounted || _isFetching) {
      return; // Avoid running when the widget is not mounted
    }

    _isFetching = true;
    if(authToken.isEmpty) authToken = await _userRepo.getAuthToken();

    if (authToken.isNotEmpty) {
      final int numTasks = await _tasksRepo.getTasksAPI(auth_token: authToken);
      // Add a delay of 500 milliseconds before updating the UI
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _numTasks = numTasks;
          _curTask = _tasksRepo.getCurrentTask();
        });
      }
      _timer = Timer.periodic(Duration(seconds: 10), (timer) {
        // Fetch and update the task data periodically
        fetchAndRefresh();
      });
    }
    _isFetching = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void initState() {
    super.initState();


    _userRepo.getUser().then((User usr) {
      if (mounted) {
        setState(() {
          _usr = usr;
        });
      }
    });
    fetchAndRefresh();
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

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Theme.of(context).primaryColor;
    ThemeData lightTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.light,
    );
    ColorScheme colorScheme = lightTheme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(autoLeading: false, context: context),

      /*AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      ),*/
      //backgroundColor: Theme.of(context).primaryColor,
      body:
        /*  Consumer<TasksRepository>(builder: (context, taskRepository, child) {
        _curTask = _tasksRepo.getCurrentTask();
        _numTasks = _tasksRepo.getNumTasks();*/
        /*_userRepo.getAuthToken().then((String value) => setState(()
          {
            if(value.isNotEmpty) {

              _tasksRepo.getTasksAPI(auth_token: value).then((int val) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  // Add a delay of 500 milliseconds before updating the UI
                  if (mounted) {
                    setState(() {
                      _numTasks = val;
                      _curTask = _tasksRepo.getCurrentTask();
                    });
                  }
                });
              });

            }
          }
          ));*/

        CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //SizedBox(height: 10),
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
                              _usr!.uName.toString() +
                                  ' ' +
                                  _usr!.uSurname.toString(),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 19),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
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
                    SizedBox(height: 17),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: ColorGroup(children: [
                        ColorChip(
                          label: AppLocalizations.of(context)!.currentTask,
                          color: Color(0xFF85C3FF), //colorScheme.primary,
                          onColor: colorScheme.onPrimary,
                        ),
// == No active tasks
                        Visibility(
                            visible: _curTask.isEmpty(),
                            child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.baseline,
                                //textBaseline: TextBaseline.alphabetic,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .noActiveTasks,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ])),
// == Current task info
                        Visibility(
                          visible: !_curTask.isEmpty(),
                          child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.baseline,
                              //textBaseline: TextBaseline.alphabetic,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                      Utils.getTimeFromDate(_curTask.tDate),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_curTask.tName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Text(_curTask.tAddress,
                                            style: TextStyle(
                                                color: Color(0xFF66727F),
                                                fontSize: 16)),
                                        Text(_curTask.tZone,
                                            style: TextStyle(
                                                color: Color(0xFF66727F),
                                                fontSize: 16)),
                                        //Text(_curTask.tDesc, style: TextStyle(color: Color(0xFF66727F))),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: true,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      //color: Colors.white,
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/task',
                                            arguments: ScreenArguments(
                                                _curTask, 'entertask'));
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                        ),
// == Current task widget operations
                        Visibility(
                          visible: _numTasks > 0,
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              child: Divider(color: Color(0xFFC2E1FF)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 8, 16),
                              child: Align(alignment: AlignmentDirectional.centerStart, child: Text('${AppLocalizations.of(context)!.tasksCompletedPercent} ${_tasksRepo.getTasksCompletedPercent()}',
                                style: TextStyle(
                                    color: Color(0xFF66727F),
                                    fontSize: 16)),),
                            ),
                            /*Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Divider(color: Color(0xFFC2E1FF)),
                            ),*/
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          width: 2.0,
                                          color: Color.fromRGBO(126, 123, 244,
                                              _numTasks == 0 ? 0.1 : 1.0)),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      minimumSize: Size(100, 56),
                                      //elevation: 5.0,
                                    ),
                                    //onPressed: _curTask.isEmpty() ? null : () => Navigator.pushNamed(context, '/tasklist'),
                                    onPressed: _numTasks == 0
                                        ? null
                                        : () => Navigator.pushNamed(context, '/tasklist'),

                                    //child: Text(AppLocalizations.of(context)!.reportProblem),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .allTasks,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          // <-- Icon
                                          Icons.arrow_forward_ios,
                                          size: 24.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(height: 18),
                        /*ColorChip(
                  label: 'onPrimary',
                  color: colorScheme.onPrimary,
                  onColor: colorScheme.primary),*/
                        /*ColorChip(
                label: 'primaryContainer',
                color: colorScheme.primaryContainer,
                onColor: colorScheme.onPrimaryContainer,
              ),
              ColorChip(
                label: 'onPrimaryContainer',
                color: colorScheme.onPrimaryContainer,
                onColor: colorScheme.primaryContainer,
              ),*/
                      ]),
                    ),
// == % of completed tasks
                    /*Visibility(
                      visible: _numTasks > 0,
                      child:
                      Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                              child: Text(
                                '${AppLocalizations.of(context)!.tasksCompletedPercent} ${_tasksRepo.getTasksCompletedPercent()}'),
                            ),
                    ),*/

                    Flexible(
                      child: Container(
                        width: double.infinity,
                        //color: Colors.orange,
                      ),
                    ),
                    //const CurrentTaskCard(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Color(0xFF7ACB82),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                minimumSize: Size(100, 56),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                    //style: TextStyle(color: Color(0xFF7B7B7B))
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    // <-- Icon
                                    Icons.qr_code_scanner,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
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
                                Navigator.pushNamed(context, '/report_problem');
                              },
                              //child: Text(AppLocalizations.of(context)!.reportProblem),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.reportIssue,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Color(0xFF7B7B7B),
                                            fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    // <-- Icon
                                    Icons.error_outline,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFF7B7B7B),
                                minimumSize: Size(100, 56),
                                //elevation: 5.0,
                              ),
                              onPressed: () {
                                try {
                                  Provider.of<AuthenticationRepository>(context,
                                          listen: false)
                                      .logOut();
                                  //Navigator.pushReplacementNamed(context, '/');
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (_) => false);
                                } catch (_) {}
                              },
                              child: Text(
                                AppLocalizations.of(context)!.logOut,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Color(0xFF7B7B7B),
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
            //),
          ],
        ),
      // }), Consumer
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/qrscan');
        },
        child: const Icon(Icons.qr_code),
      ),*/
    );
  }
}

//==
class ColorGroup extends StatelessWidget {
  const ColorGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // if you need this
          side: BorderSide(
            color: Color(0xFF85C3FF),
            width: 1,
          ),
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class ColorChip extends StatelessWidget {
  const ColorChip({
    super.key,
    required this.color,
    required this.label,
    this.onColor,
  });

  final Color color;
  final Color? onColor;
  final String label;

  static Color contrastColor(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    switch (brightness) {
      case Brightness.dark:
        return Colors.white;
      case Brightness.light:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor = onColor ?? contrastColor(color);

    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
                child: Text(label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: labelColor, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
