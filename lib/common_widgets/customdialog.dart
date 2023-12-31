import 'package:flutter/material.dart';

// [dialog with handler]
void showCustomDialog (
    BuildContext context,
    String textLabel,
    String imageAssetPath,
    final Future<String> Function(BuildContext) futureHandler,
    ) {
  showDialog(
    context: context,
    barrierDismissible: false,
    //barrierColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
            return MyFutureBuilder(
              textLabel: textLabel,
              imageAssetPath: imageAssetPath,
              futureHandler: futureHandler,
            );
    },
  );
}

class MyFutureBuilder extends StatefulWidget {
  final String textLabel;
  final String imageAssetPath;
  final Future<String> Function(BuildContext context) futureHandler;

  const MyFutureBuilder(
      {super.key, required this.textLabel, required this.imageAssetPath, required this.futureHandler,}
  );

  @override
  State<MyFutureBuilder> createState() => MyFutureBuilderState();
}

class MyFutureBuilderState extends State<MyFutureBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: widget.futureHandler(context), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
                  Card(
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
                          Image.asset(widget.imageAssetPath),
                          const SizedBox(height: 20),
                          Text(widget.textLabel,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
            ];
            if (mounted && snapshot.data!='NoNav') {
              Future.delayed(const Duration(seconds: 2)).then((_) {
                if(mounted) {
                  Navigator.of(context).pop();
                }
              });
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              /*Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),*/
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}