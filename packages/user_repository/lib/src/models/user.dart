import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.id, this.uName, this.uSurname, this.uCompany);

  final String id;
  final String uName;
  final String uSurname;
  final String uCompany;

  @override
  List<Object> get props => [id];

  static const empty = User('-', '', '', '');
}
