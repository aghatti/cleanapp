import 'package:flutter/material.dart';


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
            return FutureBuilderExample(
              textLabel: textLabel,
              imageAssetPath: imageAssetPath,
              futureHandler: futureHandler,
            );
    },
  );
}

class FutureBuilderExample extends StatefulWidget {
  final String textLabel;
  final String imageAssetPath;
  final Future<String> Function(BuildContext context) futureHandler;

  const FutureBuilderExample(
      {super.key, required this.textLabel, required this.imageAssetPath, required this.futureHandler,}
  );

  @override
  State<FutureBuilderExample> createState() => _FutureBuilderExampleState();
}

class _FutureBuilderExampleState extends State<FutureBuilderExample> {
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
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Image.asset(widget.imageAssetPath),
                          SizedBox(height: 20),
                          Text(widget.textLabel,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
            ];
            if (context != null && mounted && snapshot.data!='NoNav') {
              Future.delayed(Duration(seconds: 2)).then((_) {
                if(mounted)
                  Navigator.of(context).pop();
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
