import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({required this.id,
    required this.tName,
    required this.tDesc,
    required this.tStatus,
    required this.tDate});
  /*Task.empty():
        id = '',
        tName = '',
        tDesc = '';
        tStatus = '';*/

  final String id;
  final String tName;
  final String tDesc;
  final String tStatus;
  final DateTime tDate;

  @override
  List<Object> get props => [id];

  static var empty = Task(id: '-', tName: ' ', tDesc: ' ', tStatus: ' ', tDate: DateTime.now());

  bool isEmpty()  {return this.id=='-';}
}
