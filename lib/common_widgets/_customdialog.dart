import 'package:flutter/material.dart';

void showCustomDialog (
    BuildContext context,
    String textLabel,
    String imageAssetPath,
    final Future Function(BuildContext) futureHandler,
    ) {
  showDialog(
    context: context,
    builder: (context) {
      return FutureBuilder<void>(
        future: futureHandler(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CustomDialogWidget(
              textLabel: textLabel,
              imageAssetPath: imageAssetPath,
              futureHandler: futureHandler,
            );
          } else {
            // Return your main UI here, or null if you don't want to display anything
            return Container();
          }
        },
      );
    },
  );
}

class CustomDialogWidget extends StatelessWidget {
  final String textLabel;
  final String imageAssetPath;
  final Future Function(BuildContext) futureHandler;

  const CustomDialogWidget({super.key,
    required this.textLabel,
    required this.imageAssetPath,
    required this.futureHandler,
  });

  @override
  Widget build(BuildContext context) {
   /* return FutureBuilder(
      future: futureHandler(context),
      builder: (context, snapshot) {
        //if (snapshot.connectionState == ConnectionState.done) {
        //  builderCallback(context, snapshot);*/
          return Align(
            alignment: Alignment.center,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(imageAssetPath),
                      const SizedBox(height: 20),
                      Text(textLabel,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          );
       /* } else {
          // You can return a loading indicator or other UI here
          return CircularProgressIndicator();
        }*/

      //},
    //);
  }
}