import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import './globals.dart' as globals;
import './pageAddEventManually.dart';
import './tabMonthCalendar.dart';
import './tabPrincipal.dart';
import './tabSettings.dart';

class AfterSplashPage extends StatefulWidget {
  _AfterSplashPageState createState() => _AfterSplashPageState();

}

class _AfterSplashPageState extends State<AfterSplashPage> with TickerProviderStateMixin {
  CalendarController _controller;
  //Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  AnimationController _animationController;
  SharedPreferences prefs;

  static var tabIndex;
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    //_events = {};
    _selectedEvents = [];
    tabIndex = 0;
    initPrefs();

    globals.eventsDetailled.add(FlutterWeekViewEvent(
      title: 'Exemple Event',
      description: 'Description Event 1',
      start: DateTime.parse("2021-05-28 20:18:00Z"),
      end: DateTime.parse("2021-05-28 22:00:00Z"),
    ));
    globals.eventsDetailled.add(FlutterWeekViewEvent(
      title: 'Exemple Event 2',
      description: 'Description event 2',
      start: DateTime.parse("2021-05-18 21:30:00Z"),
      end: DateTime.parse("2021-05-18 23:30:00Z"),
      backgroundColor: Colors.green[800],
    ));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _handleTabIndex() {
    setState(() {});
  }

  /// Méthode Init stockage de données via SharedPref
  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
    _convertDayCalendarToMonthCalendar();
  }

  /// Encodage Map
  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    newMap.removeWhere((key, value) => key == null || value == null);
    return newMap;
  }

  /// Décodage map
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    newMap.removeWhere((key, value) => key == null || value == null);
    return newMap;
  }

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
                    globals.events, _selectedEvents, _controller, globals.eventsDetailled),

                // Tab #2
                tabMonthCalendar(globals.events, _selectedEvents, _controller),

                // Tab #3
                tabSettings(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                tabIndex = DefaultTabController.of(context).index;
                showModalBottomSheet<void>(
                  transitionAnimationController: AnimationController(duration: const Duration(milliseconds: 500), vsync: this),
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return pageAddEventManually(_controller);
                    });
                // Dialogue  pour ajouter un evenement dans le calendrier day type (DISABLED)
                //_showAddDialog();
              },
            ),
          );
        }),
      ),
    );
  }

 /// La méthode @_convertDayCalendarToMonthCalendar() sert à transférer les
 /// événements contenus dans la matrice remplis de flutter_week_view events (vue quotidienne)
 /// dans la matrice d'évenements table_calendar (vue mensuelle)
  _convertDayCalendarToMonthCalendar() {
    int numberOfEvents = globals.eventsDetailled.length;
    setState(() {
      for (var i = 0; i < numberOfEvents; i++) {
        if (globals.events[DateTime.utc(globals.eventsDetailled[i].start.year, globals.eventsDetailled[i].start.month, globals.eventsDetailled[i].start.day, 12, 00, 00)] != null) {
          globals.events[DateTime.utc(globals.eventsDetailled[i].start.year, globals.eventsDetailled[i].start.month, globals.eventsDetailled[i].start.day, 12, 00, 00)].add(globals.eventsDetailled[i].title);
        } else {
          globals.events[DateTime.utc(globals.eventsDetailled[i].start.year, globals.eventsDetailled[i].start.month, globals.eventsDetailled[i].start.day, 12, 00, 00)] = [globals.eventsDetailled[i].title];
        }
      }
    });
  }

 /// La méthode @_showAddDialog() sert afficher une fenetre qui permet d'ajouter
 /// evenement dans le table_calendar (calendrier mensuel)
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
                } else if (tabIndex == 1) {
                  setState(() {
                    if (globals.events[_controller.selectedDay] != null) {
                      globals.events[_controller.selectedDay].add(_eventController.text);
                      globals.events[DateTime.utc(globals.eventsDetailled[1].start.year,globals.eventsDetailled[1].start.month,globals.eventsDetailled[1].start.day,12,00,00)].add(_eventController.text);
                    } else {
                      globals.events[_controller.selectedDay] = [_eventController.text];
                      globals.events[DateTime.utc(globals.eventsDetailled[1].start.year,globals.eventsDetailled[1].start.month,globals.eventsDetailled[1].start.day,12,00,00)]= [_eventController.text];
                    }
                    prefs.setString("events", json.encode(encodeMap(globals.events)));
                    _eventController.clear();
                    Navigator.pop(context, true);
                  });
                } else if (tabIndex == 2) {
                }
              },
            )
          ],
        ));
  }
}
