import 'package:equatable/equatable.dart';


class Photo extends Equatable{
  final int taskId; // ID of the associated task
  String photoPath; // File path or reference to the photo
  bool isUploaded;

  Photo({required this.taskId, required this.photoPath, required this.isUploaded});

  @override
  List<Object> get props => [photoPath];

  // Custom getter for a unique identifier
  String get uniqueIdentifier => '$taskId/$photoPath';
  
}