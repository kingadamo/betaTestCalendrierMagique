import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:numberpicker/numberpicker.dart';
import './tabMonthCalendar.dart';
import './tabPrincipal.dart';
import './tabSettings.dart';
import './pageAddEvent.dart';
import './pageAddEventManually.dart';
import './dayView.dart';
import './AfterSplashPage.dart';

class SplashPage extends StatefulWidget {
  SplashPage();
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 2,
        navigateAfterSeconds: new AfterSplashPage(),
        title: new Text(
          'Bienvenue :)\nChargement en cours...',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        image: new Image.asset('assets/icons/logotextonly.png'),
        //backgroundColor: Colors.white,

        gradientBackground: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.0, 2),
          colors: [const Color(0xFF0E86D4), const Color(0xFF800028)],
        ),
        styleTextUnderTheLoader: new TextStyle(),
        loadingText: new Text(
          'Ichi byou keika - Ni byou keika...',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 15,
              color: Colors.grey[300]),
        ),
        photoSize: 80.0,
        loaderColor: Colors.indigo[500]);
  }
}