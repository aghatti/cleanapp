import 'dart:async';
import 'dart:math';
import 'package:tasks_repository/src/models/models.dart';

class TasksRepository {
  Task? _currentTask = Task.empty;
  List<Task> _tasks = [];

  Future<Task> getCurrentTask() async {
    var _task = Task.empty;
    if(_tasks.length > 0) {
      // DEMO
      var rng = Random();

      /*return Future.delayed(
        const Duration(milliseconds: 300),
            //() => _currentTask = Task(_id, _tName, 'коридор', 'в процессе', DateTime.now()),
            () => _currentTask = _tasks[rng.nextInt(_tasks.length-1)],
      );*/
      _task = _tasks[rng.nextInt(_tasks.length-1)];
    }
    _currentTask = _task;
    return _task;
  }

  Future<Task> getTaskByQr(String qr_code) async {
    Task _foundTask = Task.empty;
    for(Task task in _tasks)  {
      if(task.id == qr_code)  {
        _foundTask = task;
      }
    }
    return _foundTask;
  }

  Future<void> generateDemoTasks() async {
    List<Task> _v_tasks = [
      Task(
      id: '1',
      tName: 'Уборка холла',
      tDesc: 'Филевский б-р, 1, Коридор 1 этаж',
      tStatus: 'не выполнено',
      tDate: DateTime.parse('2023-06-01 10:15:00Z'),
      ),
      Task(
      id: '2',
      tName: 'Уборка холла',
      tDesc: 'Филевский б-р, 1, Коридор 2 этаж',
      tStatus: 'не выполнено',
      tDate: DateTime.parse('2023-06-01 10:25:00Z'),
      ),
    Task(
    id: '3',
    tName: 'Уборка холла',
    tDesc: 'Филевский б-р, 1, Коридор 3 этаж',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 10:35:00Z'),
    ),
    Task(
    id: '4',
    tName: 'Уборка холла',
    tDesc: 'Филевский б-р, 1, Коридор 4 этаж',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 10:45:00Z'),
    ),
    Task(
    id: '5',
    tName: 'Уборка холла',
    tDesc: 'Филевский б-р, 1, Коридор 5 этаж',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 10:55:00Z'),
    ),
    Task(
    id: '6',
    tName: 'Уборка холла',
    tDesc: 'Филевский б-р, 1, Коридор 6 этаж',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 11:05:00Z'),
    ),
    Task(
    id: '7',
    tName: 'Уборка холла',
    tDesc: 'Филевский б-р, 1, Коридор 7 этаж',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 11:15:00Z'),
    ),
    Task(
    id: '8',
    tName: 'Уборка холла',
    tDesc: 'Филевский б-р, 1, Коридор 8 этаж',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 11:25:00Z'),
    ),
    Task(
    id: '9',
    tName: 'Уборка холла',
    tDesc: 'Филевский б-р, 1, Коридор 9 этаж',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 11:35:00Z'),
    ),
    Task(
    id: '10',
    tName: 'Уборка холла',
    tDesc: 'Филевский б-р, 1, Коридор 10 этаж',
    tStatus: 'не выполнено',
    tDate: DateTime.parse('2023-06-01 11:45:00Z'),
    ),];
    _tasks = _tasks..addAll(_v_tasks);
  }

  Future<int> getNumTasks(DateTime dt) async  {
    return _tasks.length;
  }
}
