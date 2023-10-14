import 'dart:async';
import 'dart:math';
import 'package:photo_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';

class PhotoRepository with ChangeNotifier {
  static final PhotoRepository _instance = PhotoRepository._internal();
  factory PhotoRepository() {
    return _instance;
  }
  PhotoRepository._internal();

  int _currentTaskId = 0;
  List<Photo> _currentPhotos = [];

  // Future async?
  /*Future<List<Photo>> getCurrentPhotos(int taskId) async {
	return _currentPhotos;
  }*/
  
  Future<void> captureAndStorePhoto(int taskId) async {
		final ImagePicker _picker = ImagePicker();
		final XFile? image = await _picker.pickImage(source: ImageSource.camera);
		//final image = await ImagePicker().getImage(source: ImageSource.camera);
		if (image == null) return; // User canceled the capture
			// Store the photo in a directory
		final photoPath = await savePhotoLocally(image, taskId);
			// Store the association in the database
		final photo = Photo(taskId: taskId, photoPath: photoPath, isUploaded: false);
		_currentPhotos.add(photo);
		notifyListeners();
		//await insertPhoto(photo);
  }

	Future<String> savePhotoLocally(XFile pickedFile, int taskId) async {
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
//	  await localFile.writeAsBytes(File(pickedFile.path).readAsBytesSync());
		await localFile.writeAsBytes(await pickedFile.readAsBytes());
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

	Future<void> deletePhoto(Photo photo) async {
		// Delete the photo file from the device
		final File file = File(photo.photoPath);
		await file.delete();

		// Delete the photo from the database or wherever you store photo data
		// For example, if you have a list of photos, you can remove the photo like this:
		this._currentPhotos.remove(photo);

		// Notify listeners to update the UI
		print("notifyListeners of deletephoto was called");
		notifyListeners();
	}

	Future<List<Photo>> getCurrentPhotos(int taskId) async {
		if(this._currentTaskId != taskId) {
			this._currentTaskId = taskId;
			this._currentPhotos = await getPhotosForTask(taskId);
		}
		//notifyListeners();
		//print("notifyListeners of getcurrentphotos was called");
		return this._currentPhotos;
	}


}
