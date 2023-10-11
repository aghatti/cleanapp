import 'package:flutter/material.dart';

class TaskStatus {
  final int code;
  final String name;
  final int statusBg;
  final int statusColor;
  final int listIconColor;
  final int listColor;
  final int statusIcon;
  TaskStatus(this.code, this.name, this.statusBg, this.statusColor, this.listIconColor, this.listColor, this.statusIcon);
}

class TaskStatusList {
  /*static final List<TaskStatus> TaskStatuses = [
    TaskStatus(1, 'не выполнено', 0xFFEBE8FB,0xFF0B1F33,0xe835),
    TaskStatus(2, 'начато', 0xFF85C3FF,0xFFFFFFFF,0xf476),
    TaskStatus(3, 'завершено', 0xFF9FA6AD,0xFFFFFFFF,0xef46),
    TaskStatus(4, 'отменено', 0xFFDC0000,0xFFFFFFFF,0xef28),
    TaskStatus(5, 'ожидание', 0xFFFF8585,0xFFFFFFFF,0xf269)
  ];*/
  static Map<String, TaskStatus> StatusesMap = {
    /*'не выполнено': TaskStatus(1, 'не выполнено', 0xFFEBE8FB,0xFF0B1F33,0xFF0B1F33,0xFF000000,0xe158),
    'начато': TaskStatus(2, 'начато', 0xFF85C3FF,0xFFFFFFFF,0xFF85C3FF,0xFF000000,0xf476),
    'завершено': TaskStatus(3, 'завершено', 0xFF9FA6AD,0xFFFFFFFF,0xFF9FA6AD,0x55000000,0xef46),
    'отменено': TaskStatus(4, 'отменено', 0xFFDC0000,0xFFFFFFFF,0xFFDC0000,0x55000000,0xef28),
    'ожидание': TaskStatus(5, 'ожидание', 0xFFFF8585,0xFFFFFFFF,0xFFFF8585,0xFF000000,0xf269),*/
    'planned': TaskStatus(2, 'не выполнено', 0xFFEBE8FB,0xFF0B1F33,0xFF0B1F33,0xFF000000,0xe158),
    'started': TaskStatus(3, 'начато', 0xFF85C3FF,0xFFFFFFFF,0xFF85C3FF,0xFF000000,0xf476),
    'finished': TaskStatus(6, 'завершено', 0xFF9FA6AD,0xFFFFFFFF,0xFF9FA6AD,0x55000000,0xef46),
    'stopped': TaskStatus(5, 'отменено', 0xFFDC0000,0xFFFFFFFF,0xFFDC0000,0x55000000,0xef28),
    'failed': TaskStatus(8, 'отменено', 0xFFDC0000,0xFFFFFFFF,0xFFDC0000,0x55000000,0xef28),
    'reqstop': TaskStatus(4, 'ожидание', 0xFFFF8585,0xFFFFFFFF,0xFFFF8585,0xFF000000,0xf269),
    'reqnoqr': TaskStatus(7, 'ожидание', 0xFFFF8585,0xFFFFFFFF,0xFFFF8585,0xFF000000,0xf269),
  };


  static GetIconByStatus(String status_code) {
    IconData res = Icons.drafts_outlined;
    switch(status_code) {
      case 'planned':
        res = Icons.check_box_outline_blank;
        break;
      case 'started':
        res = Icons.update_outlined;
        break;
      case 'finished':
        res = Icons.check_box_outlined;
        break;
      case 'stopped':
        res = Icons.cancel_outlined;
        break;
      case 'failed':
        res = Icons.cancel_outlined;
        break;
      case 'reqstop':
        res = Icons.pending_outlined;
        break;
      case 'reqnoqr':
        res = Icons.pending_outlined;
        break;
    }
    return res;
  }
/*TaskStatusList() {
    _TaskStatuses.add(TaskStatus(1, 'не выполнено', 0xFFEBE8FB,0xFF0B1F33,0xe835));
    _TaskStatuses.add(TaskStatus(2, 'начато', 0xFF85C3FF,0xFFFFFFFF,0xf476));
    _TaskStatuses.add(TaskStatus(3, 'завершено', 0xFF9FA6AD,0xFFFFFFFF,0xef46));
    _TaskStatuses.add(TaskStatus(4, 'отменено', 0xFFDC0000,0xFFFFFFFF,0xef28));
    _TaskStatuses.add(TaskStatus(5, 'ожидание', 0xFFFF8585,0xFFFFFFFF,0xf269));
  }*/
}


/*const Map<int, TaskStatus> TaskStatusMap = {
    1: TaskStatus(const 1,const '',const 1,const 1,const 56),
};*/


