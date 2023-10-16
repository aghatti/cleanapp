import 'package:equatable/equatable.dart';

class Task extends Equatable {
  Task({
    required this.id,
    required this.tName,
    required this.tDesc,
    required this.tZone,
    required this.tZoneQr,
    required this.tObject,
    required this.tAddress,
    required this.tStatusId,
    required this.tStatus,
    required this.tDate,
    this.tDateEnd,
    this.tDateFact,
    this.tDateEndFact,
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
  final String tZoneQr;
  final String tObject;
  final String tAddress;
  int tStatusId;
  String tStatus;
  final DateTime tDate;
  final DateTime? tDateEnd;
  final DateTime? tDateFact;
  final DateTime? tDateEndFact;

  @override
  List<Object> get props => [id];

  static var empty = Task(
    id: 0,
    tName: ' ',
    tDesc: ' ',
    tZone: ' ',
    tZoneQr: ' ',
    tObject: ' ',
    tAddress: ' ',
    tStatusId: 0,
    tStatus: ' ',
    tDate: DateTime.now(),
    tDateEnd: null,
    tDateFact: null,
    tDateEndFact: null,
  );

  bool isEmpty()  {return this.id == 0;}

  void setStartedState() {
    this.tStatus = 'started';
    this.tStatusId = 3;
  }

}
