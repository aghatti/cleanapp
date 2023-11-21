import 'package:flutter/material.dart';

// [simple notification dialog]
class SimpleNotificationDialog extends StatelessWidget {
  final String textLabel;
  final String imageAssetPath;
  final Color color;

  const SimpleNotificationDialog({
    Key? key,
    required this.textLabel,
    required this.imageAssetPath,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(0),
          // TODO test
          //child: Container(
          child: SizedBox(
          height: 130, // Adjust the height as needed
          width: 130,
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 1),
              Image.asset(imageAssetPath),
              const SizedBox(height: 1),
              Text(
                textLabel,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),),
        ),
      ),
    );
  }
}