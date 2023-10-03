import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  User? _user;

  Future<User> getUser() async {
    if (_user != null) return _user!;
    final storage = new FlutterSecureStorage();
    String _uToken = await storage.read(key: 'uToken') ?? '';
    String _uName = await storage.read(key: 'uName') ?? '';
    String _uSurname = await storage.read(key: 'uSurname') ?? '';
    String _uCompany = await storage.read(key: 'uCompany') ?? '';
    String _uCompanyId = await storage.read(key: 'uCompanyId') ?? '';

    //await storage.write(key: 'uToken', value: _uToken);

    return Future.delayed(
      const Duration(milliseconds: 300),
      //() => _user = User(const Uuid().v4()),
          () => _user = User(_uName, _uSurname, _uCompany, _uCompanyId),
    );
  }

  String getUserLabel() {
    String res='';
    if(_user == null) return 'A';
    else {
      if(_user!=null && !_user!.uName.isEmpty) res += _user!.uName[0];
      if(_user!=null && !_user!.uSurname.isEmpty) res += _user!.uSurname[0];
      return res;
    }
  }
}
