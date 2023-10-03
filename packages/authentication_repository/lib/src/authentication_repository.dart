import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    // TODO web api auth
    if(username == 'user' && password == '123') {
      String _uName = 'Вячеслав';
      String _uSurname = 'Простаков';
      String _uCompany = 'Тимкорд';
      String _uCompanyId = '1';
      String _access_token = '0asdf14';
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'uName', value: _uName);
      await storage.write(key: 'uSurname', value: _uSurname);
      await storage.write(key: 'uCompany', value: _uCompany);
      await storage.write(key: 'uCompanyId', value: _uCompanyId);
      await storage.write(key: '_access_token', value: _access_token);
      await Future.delayed(
        const Duration(milliseconds: 300),
            () => _controller.add(AuthenticationStatus.authenticated),
      );
    }
    else  {
      final storage = new FlutterSecureStorage();
      await storage.delete(key: 'uName');
      await storage.delete(key: 'uSurname');
      await storage.delete(key: 'uCompany');
      await storage.delete(key: 'uCompanyId');
      await storage.delete(key: '_access_token');
    }
  }

  Future<String> checkSession() async {
// Create storage
    final storage = new FlutterSecureStorage();
// Read value
    String _uToken = await storage.read(key: 'uToken') ?? '';
    if(!_uToken.isEmpty)
      _controller.add(AuthenticationStatus.authenticated);
    return _uToken;
    /*await Future.delayed(
      const Duration(milliseconds: 300),
          () => _controller.add(AuthenticationStatus.authenticated),
    );*/
  }
  Future<void> logOut() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'uToken');
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
