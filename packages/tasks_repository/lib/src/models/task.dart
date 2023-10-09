import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({
    required this.id,
    required this.tName,
    required this.tDesc,
    required this.tZone,
    required this.tObject,
    required this.tAddress,
    required this.tStatusId,
    required this.tStatus,
    required this.tDate,
    required this.tDateEnd,
    required this.tDateFact,
    required this.tDateEndFact,
  });
  /*Task.empty():
        id = '',
        tName = '',
        tDesc = '';
        tStatus = '';*/

  final int id;
  final String tName;
  final String tDesc;
  final String tZone;
  final String tObject;
  final String tAddress;
  final int tStatusId;
  final String tStatus;
  final DateTime tDate;
  final DateTime tDateEnd;
  final DateTime tDateFact;
  final DateTime tDateEndFact;

  @override
  List<Object> get props => [id];

  static var empty = Task(
    id: 0,
    tName: ' ',
    tDesc: ' ',
    tZone: ' ',
    tObject: ' ',
    tAddress: ' ',
    tStatusId: 0,
    tStatus: ' ',
    tDate: null,
    tDateEnd: null,
    tDateFact: null,
    tDateEndFact: null,
  );

  bool isEmpty()  {return this.id == 0;}
}
