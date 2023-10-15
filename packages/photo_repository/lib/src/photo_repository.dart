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
				isUploaded: file.path.contains('_upl')
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

	Future<bool> uploadPhoto(File photo, int taskId) async {
		bool uploadSucceeded = false;
		String fileName = photo.uri.pathSegments.last;

		// TODO Logic to upload a photo to a server
		var request = http.MultipartRequest('POST', Uri.parse('https://teamcoord.ru:8190/tasks/uploadphoto' + '?task_id=' + task_id.toString()));
		request.headers.addAll({
			'Authorization': 'Bearer " + auth_token,
			'Content-Type': 'multipart/form-data',
		});

		request.headers.addAll(headers: <String, String>{
			"Authorization": "Bearer " + auth_token,
		},)
		// Add the file as a part of the request
		request.files.add(
			http.MultipartFile(
				'uploaded_file',
				file.readAsBytes().asStream(),
				file.lengthSync(),
				filename: fileName, // The filename you want on the server
			),
		);
		var response = await http.Client().send(request);

		// Process the response
		if (response.statusCode == 200) {
			// Successful response
			//print(await response.stream.bytesToString());
			uploadSucceeded = true;
		} else {
			// Handle the error
			//print('Request failed with status: ${response.statusCode}');
			uploadSucceeded = false;
		}
		if(uploadSucceeded) notifyListeners();
		return uploadSucceeded;
	}

}

class PhotoUploadService {
	// Private constructor
	PhotoUploadService._internal();
	// The single instance of PhotoUploadService
	static final PhotoUploadService _instance = PhotoUploadService._internal();
	factory PhotoUploadService() {
		return _instance;
	}
	Timer? _timer;
	final PhotoRepository _photoRepo;

	Future<void> uploadPhotos() async {
		final directory = await getApplicationDocumentsDirectory();
		final photoDirectory = directory.path;

		// get all photos that are not uploaded yet
		final List<FileSystemEntity> files = Directory(photoDirectory)
				.listSync()
				.where((entity) => entity is File && (entity.path.endsWith('.jpg') || entity.path.endsWith('.png') && !entity.path.endsWith('_upl')))
				.toList();

		for (var file in files) {
			try {
				// Get the taskId from the file name or metadata
				final taskId = extractTaskId(file);

				// Perform the HTTP upload using the PhotoRepository
				final uploadResult = await _photoRepository.uploadPhoto(file, taskId);

				if (uploadResult) {
					// Upload was successful, rename the file with a "_upl" suffix to indicate it's uploaded
					final extension = file.path.split('.').last;
					final fileNameWithoutExtension = file.path.replaceAll(RegExp('\.$extension\$'), ''); // Remove the existing extension
					final newFilePath = '$fileNameWithoutExtension\_upl.$extension';
					await file.rename(newFilePath);

					// Notify the service about the successful upload
					//_photoUploadService.handleSuccessfulUpload(file);
				} else {
					// Handle the case when the upload was not successful
					//_photoUploadService.handleFailedUpload(file);
				}
			} catch (e) {
				// Handle any errors or failures during upload
				//_photoUploadService.handleFailedUpload(file);
			}
		}
	}

	int extractTaskId(File file) {
		// Implement logic to extract the task ID from the file name or metadata
		final fileName = file.uri.pathSegments.last;
		final taskId = int.tryParse(fileName.split('_')[0]) ?? 0;
		return taskId;
	}

	void startPhotoUploadTimer() {
		if (_timer == null || !_timer!.isActive) {
			_timer = Timer.periodic(Duration(seconds: 30), (timer) {
				//uploadPhotos();
			});
		}
	}

	void stopPhotoUploadTimer() {
		_timer?.cancel();
	}

}
