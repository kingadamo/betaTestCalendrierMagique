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
import './SplashPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // WIDGET BUILD---
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planr',
      debugShowCheckedModeBanner: true,
      //theme: ThemeData(
      // primarySwatch: Colors.pink,
      // ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new SplashPage()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new OnBoardPage()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }
}

class OnBoardPage extends StatefulWidget {
  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SplashPage()),
    );
  }

/* Pour utiliser un fullscreen Page
  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/icons/planificationmanuelle.png',
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
  }
*/
  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/icons/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const boxDecoration = BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue,
        Colors.white,
      ],
    ));
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      //pageColor: Colors.blue,
      boxDecoration: boxDecoration,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('logotextonly.png', 50),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            "Sauter l'introduction",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Bienvenue sur Planr",
          body: "Un outil d'aide à la planification du temps.",
          image: _buildImage('logotextonly.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Gestion du temps",
          body:
              "Laissez Planr s'occuper de la gestion du temps avec la planification automatique.\n\n Planr proposera un horaire basé sur vos disponibilités et vos préférences.",
          image: _buildImage('oldforeground2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Utilisation de l'interface",
          body:
              "Retrouvez votre information sur différents onglets.\n\n Le premier vous permet d'avoir une vue journalière pour les évènements qui se passent le jour même. \n\n Glissez au deuxième onglet pour avoir accès à une vue générale du mois.",
          image: _buildImage('onglets.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Planification automatique",
          body:
              "Remplissez un court formulaire et laisser Planr établir soit même l'heure la plus appropriée pour effectuer la tache à faire.\n\nUtilisez des préconfigurations pour vous faciliter la tache ou remplissez manuellement tous les champs exigés.",
          image: _buildImage('planificationautomatique.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Pas compris?",
          body: "Appuyez ici pour revenir en arrière",
          image: _buildImage('nani.png'),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'Revenir en arrière.',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Prêt à partir?",
          bodyWidget: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Appuyez sur ", style: bodyStyle),
                Icon(Icons.add),
                Text(" pour ajouter une \n tache manuellement.",
                    style: bodyStyle),
              ],
            ),
            Text("\nAppuyez sur 'Terminer' pour quitter l'introduction.")
          ]),
          decoration: pageDecoration.copyWith(
            bodyFlex: 3,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('doge.png'),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Sauter'),
      next: const Icon(Icons.arrow_forward),
      done:
          const Text('Terminer', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

