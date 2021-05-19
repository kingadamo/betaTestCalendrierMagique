import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import './AfterSplashPage.dart';

/// La classe @SplashPage sert à afficher un écran de bienvenue au déamrrage de
/// l'application.
/// L'écran est appelé à chaque démarrage

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