import 'dart:async';
import 'dart:math';
import 'package:tasks_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class TasksRepository with ChangeNotifier {
  static final TasksRepository _instance = TasksRepository._internal();
  factory TasksRepository() {
    return _instance;
  }
  TasksRepository._internal();

  Task _currentTask = Task.empty;
  List<Task> _tasks = [];

  Future<List<Task>> getTasks() async {
    return _tasks;
  }

  Future<int> getTasksAPI({required String auth_token,}) async  {
      _tasks.clear();
      _currentTask = Task.empty;
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
          _tasks = _tasks..addAll(_v_tasks);
          if(curTaskItr>=0 && _tasks.length>0 && curTaskItr<_tasks.length) {
            _currentTask = _tasks[curTaskItr];
          }
          res = _tasks.length;
        }
      } else {
        // TODO show error
        throw Exception('Failed to get user profile.');
      }
      return res;
  }

  Future<int> getNumTasks() async  {
    return _tasks.length;
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

  Future<Task> getCurrentTask() async {
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

  Future<void> generateDemoTasks() async {
   /*List<Task> _v_tasks = [
      Task(
        id: '3',
        tName: 'Уборка холла',
        tDesc: '• Очистить урны\n• Вымыть пол',
        tZone: 'Коридор 3 этаж',
        tAddress: 'Филевский б-р, 1',
        tStatus: 'завершено',
        tDate: DateTime.parse('2023-06-01 10:00:00Z'),
      ),
      Task(
        id: '4',
        tName: 'Уборка холла',
        tDesc: '• Очистить урны\n• Вымыть пол',
        tZone: 'Коридор 4 этаж',
        tAddress: 'Филевский б-р, 1',
        tStatus: 'отменено',
        tDate: DateTime.parse('2023-06-01 10:15:00Z'),
      ),
      Task(
        id: '5',
        tName: 'Уборка холла',
        tDesc: '• Очистить урны\n• Вымыть пол',
        tZone: 'Коридор 5 этаж',
        tAddress: 'Филевский б-р, 1',
        tStatus: 'ожидание',
        tDate: DateTime.parse('2023-06-01 10:30:00Z'),
      ),
      Task(
      id: '1',
      tName: 'Уборка холла',
      tDesc: """• Очистить урны\n• Вымыть унитазы\n• Вымыть раковины\n• Вымыть пол\n• Вынести мусор
• Протереть стены\n• Протереть лампы\n• Протереть стекла\n• Вымыть кабину грузового лифта
• Вымыть кабину пассажирского лифта и зеркала внутри\n• Снять рекламные объявления со стен\n• Покормить кота\n• Полить цветы\n• Выкинуть рекламную корреспонденцию со столика
• Заказать пиццу на день рождения старшей консьержки\n• Вызвать мастера для проверки лифтов
          """,
      tZone: 'Первый этаж / Левое крыло',
      tAddress: 'БЦ Белая Площадь',
      tStatus: 'начато',
      tDate: DateTime.parse('2023-06-01 10:45:00Z'),
      ),

      Task(
      id: '2',
      tName: 'Уборка холла',
      tDesc: '• Очистить урны\n• Вымыть пол',
      tZone: 'Коридор 1 этаж',
      tAddress: 'Филевский б-р, 1',
      tStatus: 'не выполнено',
      tDate: DateTime.parse('2023-06-01 11:00:00Z'),
      ),


    Task(
    id: '6',
    tName: 'Уборка холла',
    tDesc: '• Очистить урны\n• Вымыть пол',
    tZone: 'Коридор 6 этаж',
    tAddress: 'Филевский б-р, 1',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 11:15:00Z'),
    ),
    Task(
    id: '7',
    tName: 'Уборка холла',
    tDesc: '• Очистить урны\n• Вымыть пол',
    tZone: 'Коридор 7 этаж',
    tAddress: 'Филевский б-р, 1',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 11:30:00Z'),
    ),
    Task(
    id: '8',
    tName: 'Уборка холла',
    tDesc: '• Очистить урны\n• Вымыть пол',
    tZone: 'Коридор 8 этаж',
    tAddress: 'Филевский б-р, 1',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 11:45:00Z'),
    ),
    Task(
    id: '9',
    tName: 'Уборка холла',
    tDesc: '• Очистить урны\n• Вымыть пол',
    tZone: 'Коридор 9 этаж',
    tAddress: 'Филевский б-р, 1',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 12:00:00Z'),
    ),
    Task(
    id: '10',
    tName: 'Уборка холла',
    tDesc: '• Очистить урны\n• Вымыть пол',
    tZone: 'Коридор 10 этаж',
    tAddress: 'Филевский б-р, 1',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 12:15:00Z'),
    ),];
    _tasks = _tasks..addAll(_v_tasks);*/
  }


}
