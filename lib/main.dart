//import 'package:TeamCoord/task.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:photo_repository/photo_repository.dart';


void main() {
  //runApp(const CleaningApp());

  if (kReleaseMode) {
    CustomImageCache();
  }
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => AuthenticationRepository()),
      Provider(create: (context) => UserRepository()),
      ChangeNotifierProvider<TasksRepository>(create: (context) => TasksRepository()),
      ChangeNotifierProvider<PhotoRepository>(create: (context) => PhotoRepository()),
    ],
    /*child: MaterialApp(
      home: CleaningApp(),
    ),*/
    child: const CleaningApp(),
  ),);
}



class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    // Set your image cache size
    imageCache.maximumSizeBytes = 1024 * 1024 * 200; // 100 MB
    return imageCache;
  }
}
