import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  String? _access_token='';
  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<String> getToken() async {
    final storage = new FlutterSecureStorage();
    String _access_token = await storage.read(key: '_access_token') ?? '';
    return _access_token;
  }

  Future<void> logInAPI({
    required String username,
    required String password,
  }) async {
    // TODO web api auth and datastore (remember me)
    var map = new Map<String, dynamic>();
    map['grant_type'] = '';
    map['username'] = username;
    map['password'] = password;
    map['scope'] = '';
    map['client_id'] = '';
    map['client_secret'] = '';

    final response = await http.post(
      Uri.parse('https://teamcoord.ru:8190/token'),
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: map,
    );

    if (response.statusCode == 200) {
      final storage = new FlutterSecureStorage();
      String _access_token = jsonDecode(response.body)['access_token'];
      await storage.write(key: '_access_token', value: _access_token);
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // TODO show error
      throw Exception('Failed to get token.');
    }
    await Future.delayed(
      const Duration(milliseconds: 300),
          () => _controller.add(AuthenticationStatus.authenticated),
    );
  }

  Future<String> checkSession() async {
// Create storage
    final storage = new FlutterSecureStorage();
// Read value
    String _access_token = await storage.read(key: '_access_token') ?? '';
    if(!_access_token.isEmpty)
      _controller.add(AuthenticationStatus.authenticated);
    return _access_token;
    /*await Future.delayed(
      const Duration(milliseconds: 300),
          () => _controller.add(AuthenticationStatus.authenticated),
    );*/
  }
  Future<void> logOut() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'uName');
    await storage.delete(key: 'uSurname');
    await storage.delete(key: 'uCompany');
    await storage.delete(key: 'uCompanyId');
    await storage.delete(key: '_access_token');
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
