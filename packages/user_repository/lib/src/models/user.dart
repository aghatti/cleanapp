import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.uName, this.uSurname, this.uCompany, this.uCompanyId);

  final String uName;
  final String uSurname;
  final String uCompany;
  final int uCompanyId;

  @override
  List<Object> get props => [id];

  static const empty = User('', '', '', '');
}
