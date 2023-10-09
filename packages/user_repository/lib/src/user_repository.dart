import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRepository {
  User? _user;

  Future <void> getUserAPI({
    required String auth_token,
  }) async {

    final response = await http.get(
      Uri.parse('https://teamcoord.ru:8190/user'),
      headers: <String, String>{
        "Authorization": "Bearer " + auth_token,
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      String name = json['name'];
      String surname = json['surname'];
      String company = json['company'];
      String company_id = json['company_id'].toString();

      final storage = new FlutterSecureStorage();
      await storage.write(key: 'uName', value: name);
      await storage.write(key: 'uSurname', value: surname);
      await storage.write(key: 'uCompany', value: company);
      await storage.write(key: 'uCompanyId', value: company_id);
    } else {
      // TODO show error
      throw Exception('Failed to get user profile.');
    }
  }

  Future<User> getUser() async {
    if (_user != null) return _user!;
    final storage = new FlutterSecureStorage();
    String _uToken = await storage.read(key: 'uToken') ?? '';
    String _uName = await storage.read(key: 'uName') ?? '';
    String _uSurname = await storage.read(key: 'uSurname') ?? '';
    String _uCompany = await storage.read(key: 'uCompany') ?? '';
    String _uCompanyId_str = await storage.read(key: 'uCompanyId') ?? '';

    int _uCompanyId = int.parse(_uCompanyId_str);

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
