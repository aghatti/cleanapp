import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task(this.id,
              this.tName,
               this.tDesc,
               this.tStatus,
               this.tDate);
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

  static var empty = Task('-', ' ', ' ', ' ', DateTime.now());

  bool isEmpty()  {return this.id=='-';}
}
