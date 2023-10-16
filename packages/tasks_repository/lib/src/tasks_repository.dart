import 'dart:async';
import 'dart:math';
import 'package:tasks_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:authentication_repository/authentication_repository.dart';

class TasksRepository with ChangeNotifier {
  static final TasksRepository _instance = TasksRepository._internal();
  factory TasksRepository() {
    return _instance;
  }
  TasksRepository._internal();

  Task _currentTask = Task.empty;
  List<Task> _tasks = [];
  bool runningGetTasksAPI = false;

  Future<List<Task>> getTasks() async {
    return _tasks;
  }


  Future<int> getTasksAPI({required String auth_token,}) async  {
      if(runningGetTasksAPI) return _tasks.length;
      runningGetTasksAPI = true;
      //_tasks.clear();
      //_currentTask = Task.empty;
      List<Task> t_tasks = [];
      int res = 0;
      final response = await http.get(
        Uri.parse('https://teamcoord.ru:8190/tasks'),
        headers: <String, String>{
          "Authorization": "Bearer " + auth_token,
        },
      );

      if (response.statusCode == 200) {
        var jsonArray = jsonDecode(utf8.decode(response.bodyBytes));
        if(jsonArray.length > 0) {
          List<Task> _v_tasks = [];
          List<String> activeStatuses = ["planned", "started", "reqstop", "reqnoqr"];
          int curTaskItr = -1;
          int cnt = 0;
          for (var jsonObject in jsonArray) {
            String state = jsonObject['state'];
            DateTime dtstart = DateTime.parse(jsonObject['dtstart']);
            int id = jsonObject['id'];
            if(activeStatuses.contains(state) && curTaskItr == -1) {
              curTaskItr = cnt;
            }
            cnt++;
            _v_tasks.add(Task(
              id: id,
              tName: jsonObject['name'],
              tDesc: jsonObject['description'],
              tZone: jsonObject['zone'],
              tZoneQr: jsonObject['zone_qr'],
              tObject: jsonObject['object'],
              tAddress: jsonObject['address'],
              tStatusId: jsonObject['state_id'],
              tStatus: state,
              tDate: dtstart,
              tDateEnd: jsonObject['dtend'] != null ? DateTime.tryParse(jsonObject['dtend']) : null,
              tDateFact: jsonObject['dtstart_fact'] != null ? DateTime.tryParse(jsonObject['dtstart_fact']) : null,
              tDateEndFact: jsonObject['dtend_fact'] != null ? DateTime.tryParse(jsonObject['dtend_fact']) : null,
            ));
          }
          t_tasks..addAll(_v_tasks);
          if(curTaskItr>=0 && t_tasks.length>0 && curTaskItr<t_tasks.length) {
            _currentTask = t_tasks[curTaskItr];
          }
          else {
            _currentTask = Task.empty;
          }
          _tasks = t_tasks;
          res = _tasks.length;
        }
      } else {
        //_tasks.clear();
        //_currentTask = Task.empty;
        runningGetTasksAPI = false;
        // TODO show error
        throw Exception('Failed to get task list.');
      }
      runningGetTasksAPI = false;
      return res;
  }

  int getNumTasks()  {
    return _tasks.length;
  }

  bool areListsEqual(List<Task> list1, List<Task> list2) {
    // Check if the lists have the same length
    if (list1.length != list2.length) {
      return false;
    }

    // Sort the lists based on a common property (e.g., id or name) for consistent comparison
    list1.sort((a, b) => a.id.compareTo(b.id));
    list2.sort((a, b) => a.id.compareTo(b.id));

    // Compare each element in the lists
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id || list1[i].tStatus != list2[i].tStatus) {
        return false;
      }
    }
    return true;
  }

  Future<List<String>> getObjects() async {
    final Set<String>objs = Set();
    List<Task> _filteredTasks = List.from(_tasks);
    _filteredTasks.retainWhere((x) => objs.add(x.tAddress));
    //final List<String> res = objs.toList();
    final List<String> res =
        objs?.map((dynamic item) => item.toString()).toList() ?? [];
    //objs?.map((String item) => item.toString()).toList() ?? [];
    res.insert(0, "-- no filter --");
    return res;
  }

  Task getCurrentTask() {
    // DEMO
    /*var _task = Task.empty;
    if(_tasks.length > 0) {

      //var rng = Random();
      //_task = _tasks[rng.nextInt(_tasks.length-1)];
    }
    _currentTask = _task;
    return _task;*/
    return _currentTask;
  }


  Future<int> startTask({required String auth_token, required int task_id}) async {
    //_tasks.clear();
    //_currentTask = Task.empty;
    int res = 0;
    final response = await http.post(
      Uri.parse('https://teamcoord.ru:8190/tasks/start' + '?task_id=' + task_id.toString()),
      headers: <String, String>{
        "Authorization": "Bearer " + auth_token,
      },
      //body: {'task_id': task_id.toString()},
    );

    if (response.statusCode == 200) {
      return 0;
    } else {
      // TODO show error
      throw Exception('Failed to make request to start task.');
    }
    return res;
  }

  Future<int> startTaskNoQr({required String auth_token, required int task_id}) async {
    //_tasks.clear();
    //_currentTask = Task.empty;
    int res = 0;
    final response = await http.post(
      Uri.parse('https://teamcoord.ru:8190/tasks/reqnoqr' + '?task_id=' + task_id.toString()),
      headers: <String, String>{
        "Authorization": "Bearer " + auth_token,
      },
      //body: {'task_id': task_id.toString()},
    );

    if (response.statusCode == 200) {
      return 0;
    } else {
      // TODO show error
      throw Exception('Failed to make request to start task with no QR.');
    }
    return res;
  }

  Future<int> stopTask({required String auth_token, required int task_id}) async {
    //_tasks.clear();
    //_currentTask = Task.empty;
    int res = 0;
    final response = await http.post(
      Uri.parse('https://teamcoord.ru:8190/tasks/reqstop' + '?task_id=' + task_id.toString()),
      headers: <String, String>{
        "Authorization": "Bearer " + auth_token,
      },
      //body: {'task_id': task_id.toString()},
    );
    if (response.statusCode == 200) {
      return 0;
    } else {
      // TODO show error
      throw Exception('Failed stop task.');
    }
    return res;
  }

  Future<int> finishTask({required String auth_token, required int task_id}) async {
    //_tasks.clear();
    //_currentTask = Task.empty;
    int res = 0;
    final response = await http.post(
      Uri.parse('https://teamcoord.ru:8190/tasks/finish' + '?task_id=' + task_id.toString()),
      headers: <String, String>{
        "Authorization": "Bearer " + auth_token,
      },
      //body: {'task_id': task_id.toString()},
    );
    if (response.statusCode == 200) {
      return 0;
    } else {
      // TODO show error
      throw Exception('Failed finish task.');
    }
    return res;
  }

  Task getTaskByQr(String qr_code) {
    Task _foundTask = Task.empty;
    for(Task task in _tasks)  {
      if(task.tZoneQr == qr_code && task.tStatus == 'planned')  {
        _foundTask = task;
        break;
      }
    }
    return _foundTask;
  }




}

class TasksUpdateService {

  // Private constructor
  TasksUpdateService._internal();

  // The single instance of PhotoUploadService
  static final TasksUpdateService _instance = TasksUpdateService._internal();

  factory TasksUpdateService() {
    return _instance;
  }

  Timer? _timer;
  final AuthenticationRepository _authRepo = AuthenticationRepository();
  final TasksRepository _tasksRepo = TasksRepository();

  Future<void> updateTasks() async {
    final auth_token = await _authRepo.checkSession();
    if(auth_token != null) await _tasksRepo.getTasksAPI(auth_token: auth_token);
  }

  void startTasksUpdateTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      updateTasks();
        //uploadPhotos();
      });
    }
  }

  void stopTasksUpdateTimer() {
    _timer?.cancel();
  }
}