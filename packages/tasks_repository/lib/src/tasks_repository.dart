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

  Task getTaskByQr(String qr_code) {
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
    _tasks = _tasks..addAll(_v_tasks);
  }

  Future<List<Task>> getTasks() async {
    return _tasks;
  }

  /*Future<int> getNumTasks(DateTime dt) async  {
    return _tasks.length;
  }*/

  Future<int> getNumTasks() async  {
    return _tasks.length;
  }
}
