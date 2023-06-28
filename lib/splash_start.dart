import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage(
      {Key? key, required this.primaryColor, required this.secondaryColor})
      : super(key: key);

  final Color primaryColor;
  final Color secondaryColor;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();



    /*Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.pushReplacementNamed(context, '/'),
    );*/
    _controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this)
          ..repeat(reverse: true);
    _colorTween =
        ColorTween(begin: widget.primaryColor, end: widget.secondaryColor)
            .animate(_controller);
    //CurvedAnimation(parent: _controller, curve: Curves.easeOutSine));
    //_controller.forward();
    Future.delayed(
        const Duration(seconds: 3),
        (){
    Provider.of<AuthenticationRepository>(context, listen: false)
        .checkSession()
        .then((value) {
      if (value.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*return Container(
      color: _colorTween.value,
    );*/

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
        child: AnimatedBuilder(
          animation: _colorTween,
          builder: (BuildContext _, Widget? __) {
            return Container(
              width: 160,
              height: 160,
              child: //Image.asset('assets/3.0x/cleanapp_logo_transparent.png'),
                  SvgPicture.asset(
                'assets/cleanapp_logo_big.svg',
                color: _colorTween.value,
              ),
            );
          },
        ),
      ),
    );
  }
}
