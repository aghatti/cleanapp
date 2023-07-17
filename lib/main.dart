import 'package:flutter/material.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';


void main() {
  //runApp(const CleaningApp());

  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => AuthenticationRepository()),
      Provider(create: (context) => UserRepository()),
      Provider(create: (context) => TasksRepository()),
    ],
    child: const CleaningApp(),
  ),);
}

