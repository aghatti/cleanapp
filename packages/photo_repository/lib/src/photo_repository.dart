import 'dart:async';
import 'dart:math';
import 'package:photo_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class PhotoRepository {
  static final PhotoRepository _instance = PhotoRepository._internal();
  factory PhotoRepository() {
    return _instance;
  }
  PhotoRepository._internal();

  // Store current task photos
  List<Photo> _currentPhotos = [];

  // Future async?
  Future<List<Photo>> getCurrentPhotos(int taskId) async {   	
	return _currentPhotos;
  }
  
  Future<void> captureAndStorePhoto(int taskId) async {  
  	final image = await ImagePicker().getImage(source: ImageSource.camera);
		if (image == null) return; // User canceled the capture
			// Store the photo in a directory
		final photoPath = await savePhotoLocally(image, taskId);
			// Store the association in the database
		final photo = Photo(taskId: taskId, photoPath: photoPath, isUploaded: false);
		//await insertPhoto(photo);
  }

	Future<String> savePhotoLocally(PickedFile pickedFile, int taskId) async {
	  // Get the directory for storing photos
	  final directory = await getApplicationDocumentsDirectory();
	  final String photoDirectory = directory.path;

	  // Generate a unique filename for the photo (you can customize this)
	  final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
	  final String fileName = '${taskId}_$timestamp.jpg';
	  
	  // Construct the full path to save the photo
	  final String filePath = '$photoDirectory/$fileName';

	  // Create a File object from the PickedFile and copy it to the local directory
	  final File localFile = File(filePath);
	  await localFile.writeAsBytes(File(pickedFile.path).readAsBytesSync());

	  return filePath;	  
	}
	
	Future<List<Photo>> getPhotosForTask(int taskId) async {
	  final directory = await getApplicationDocumentsDirectory();
	  final photoDirectory = directory.path;

	  final List<FileSystemEntity> files = Directory(photoDirectory)
		  .listSync()
		  .where((entity) =>
			  entity is File &&
			  entity.path.startsWith('$photoDirectory/$taskId'))
		  .toList();
		// Create a list of Photo objects from the files
		final List<Photo> photos = files.map((file) {
			return Photo(
				taskId: taskId,
				photoPath: file.path,
				isUploaded: false
			);
		}).toList();
		return photos;
	}

}
