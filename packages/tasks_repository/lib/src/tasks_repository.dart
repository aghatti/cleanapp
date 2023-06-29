import 'dart:async';
import 'package:tasks_repository/src/models/models.dart';

class TasksRepository {
  Task? _currentTask = Task.empty;

  Future<Task> getCurrentTask() async {
    String _id = '123';
    String _tName = 'Уборка';

    return Future.delayed(
      const Duration(milliseconds: 300),
          () => _currentTask = Task(_id, _tName, 'коридор', 'в процессе', DateTime.now()),

    );
  }
  Future<int> getNumTasks(DateTime dt) async  {
    return 18;
  }
}
