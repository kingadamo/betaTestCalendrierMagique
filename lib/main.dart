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

class AfterSplashPage extends StatefulWidget {
  AfterSplash createState() => AfterSplash();
}

class SplashPage extends StatefulWidget {
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

class AfterSplash extends State<AfterSplashPage> with TickerProviderStateMixin {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  AnimationController _animationController;
  SharedPreferences prefs;
  static var eventsDetailled;
  static var tabIndex;
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    tabIndex = 0;
    initPrefs();
    eventsDetailled = [
      FlutterWeekViewEvent(
        title: 'Changer les pneus de la Tesla',
        description: 'changement saisonnier',
        start: DateTime.parse("2021-04-29 20:18:00Z"),
        end: DateTime.parse("2021-04-29 22:00:00Z"),
      ),
      FlutterWeekViewEvent(
        title: 'Regarder Jojo<s bizarre adventure',
        description: 'A description 2',
        start: DateTime.parse("2021-04-29 21:30:00Z"),
        end: DateTime.parse("2021-04-29 23:30:00Z"),
        backgroundColor: Colors.green[800],
      )
    ];
    eventsDetailled.add(FlutterWeekViewEvent(
      title: 'mada',
      description: 'changement saisonnier',
      start: DateTime.parse("2021-04-28 20:18:00Z"),
      end: DateTime.parse("2021-04-28 22:00:00Z"),
    ));
    eventsDetailled.add(FlutterWeekViewEvent(
      title: 'BINKS',
      description: 'A description 2',
      start: DateTime.parse("2021-05-06 21:30:00Z"),
      end: DateTime.parse("2021-05-06 23:30:00Z"),
      backgroundColor: Colors.green[800],
    ));
    print(eventsDetailled[1].title);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _handleTabIndex() {
    setState(() {});
  }

  // Méthode Init stockage de données via SharedPref
  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
    _convertDayCalendarToMonthCalendar();
  }

  // Encodage Map
  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    newMap.removeWhere((key, value) => key == null || value == null);
    return newMap;
  }

  // Décodage map
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    newMap.removeWhere((key, value) => key == null || value == null);
    return newMap;
  }

  // WIDGET BUILD ----------
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF001227),
        accentColor: Color(0xFF04273D),
      ),
      home: DefaultTabController(
        length: 3,
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                indicatorColor: Color(0xFF0E86D4),
                tabs: [
                  // Tab #1
                  Tab(icon: Icon(Icons.home)),

                  // Tab #2
                  Tab(icon: Icon(Icons.calendar_today)),

                  // Tab #3
                  Tab(icon: Icon(Icons.settings)),
                ],
              ),
              title: Image.asset('assets/icons/logotextonly.png',
                  width: 90, height: 40, fit: BoxFit.scaleDown),
            ),
            body: TabBarView(
              children: [
                // Tab #1
                tabPrincipal(
                    _events, _selectedEvents, _controller, eventsDetailled),

                // Tab #2
                tabMonthCalendar(_events, _selectedEvents, _controller),

                // Tab #3
                tabSettings(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                tabIndex = DefaultTabController.of(context).index;
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return pageAddEventManually(_controller);
                    });
                // Dialogue  pour ajouter un evenement dans le calendrier day type
                //_showAddDialog();
                print(tabIndex);
              },
            ),
          );
        }),
      ),
    );
  }

  _convertDayCalendarToMonthCalendar() {
    int numberOfEvents = eventsDetailled.length;
    setState(() {
      for (var i = 0; i < numberOfEvents; i++) {
        if (_events[DateTime.utc(
                eventsDetailled[i].start.year,
                eventsDetailled[i].start.month,
                eventsDetailled[i].start.day,
                12,
                00,
                00)] !=
            null) {
          _events[DateTime.utc(
                  eventsDetailled[i].start.year,
                  eventsDetailled[i].start.month,
                  eventsDetailled[i].start.day,
                  12,
                  00,
                  00)]
              .add(eventsDetailled[i].title);
          //print("XXXXXXXXXXXXXXXXXS");
        } else {
          print("mon print:");
          print(_events[eventsDetailled[i].start.day]);
          print(i);
          print(eventsDetailled[i].title);
          print(DateTime.utc(
              eventsDetailled[i].start.year,
              eventsDetailled[i].start.month,
              eventsDetailled[i].start.day,
              12,
              00,
              00));
          _events[DateTime.utc(
              eventsDetailled[i].start.year,
              eventsDetailled[i].start.month,
              eventsDetailled[i].start.day,
              12,
              00,
              00)] = [eventsDetailled[i].title];
          // _events= {
          //   DateTime.utc(eventsDetailled[i].start.year, eventsDetailled[i].start.month,eventsDetailled[i].start.day, 12, 00,00) : [eventsDetailled[i].title],
          // };
          print(_events);
        }
      }
    });
  }

  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _eventController,
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context, false);
                      });
                    },
                    child: Text("Annuler")),
                FlatButton(
                  child: Text("Sauvegarder"),
                  onPressed: () {
                    if (tabIndex == 0) {
                      print(tabIndex);
                    } else if (tabIndex == 1) {
                      if (_eventController.text.isEmpty) {
                        print('0');
                        print(_controller.selectedDay);
                        return;
                      }
                      setState(() {
                        if (_events[_controller.selectedDay] != null) {
                          print('1');
                          _events[_controller.selectedDay]
                              .add(_eventController.text);
                          _events[DateTime.utc(
                                  eventsDetailled[1].start.year,
                                  eventsDetailled[1].start.month,
                                  eventsDetailled[1].start.day,
                                  12,
                                  00,
                                  00)]
                              .add(_eventController.text);
                        } else {
                          _events[_controller.selectedDay] = [
                            _eventController.text
                          ];
                          _events[DateTime.utc(
                              eventsDetailled[1].start.year,
                              eventsDetailled[1].start.month,
                              eventsDetailled[1].start.day,
                              12,
                              00,
                              00)] = [_eventController.text];

                          print('2');
                        }
                        //print('dsadasds');
                        //print(_events[_controller.selectedDay]);
                        //print(_controller.selectedDay);
                        print(DateTime.utc(
                            eventsDetailled[1].start.year,
                            eventsDetailled[1].start.month,
                            eventsDetailled[1].start.day,
                            12,
                            00,
                            00));

                        prefs.setString(
                            "events", json.encode(encodeMap(_events)));
                        _eventController.clear();
                        Navigator.pop(context, true);
                      });
                    } else if (tabIndex == 2) {
                      print(tabIndex);
                    }
                  },
                )
              ],
            ));
    //if (tabIndex == 1) {
    //  setState(() {
    //    _selectedEvents = _events[_controller.selectedDay];
    //  });
    //}
  }
}
