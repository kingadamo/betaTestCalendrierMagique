import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendrier Bouks',
      //theme: ThemeData(
      // primarySwatch: Colors.pink,
      // ),
      home: HomePage(),
    );
  }
}

class AfterSplashPage extends StatefulWidget {
  AfterSplash createState() => AfterSplash();
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new AfterSplashPage(),
        title: new Text(
          'Bienvenue :)\nChargement en cours...',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        image: new Image.asset('assets/images/dogecoin.png'),
        //backgroundColor: Colors.white,

        gradientBackground: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.0, 2),
          colors: [const Color(0xFF0E86D4), const Color(0xFF800028)],
        ),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 50.0,
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

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    initPrefs();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  // Méthode Init stockage de données via SharedPref
  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.pink[800],
        accentColor: Colors.deepPurple[200],
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: Colors.red,
              tabs: [
                // Tab #1
                Tab(icon: Icon(Icons.home)),

                // Tab #2
                Tab(icon: Icon(Icons.calendar_today)),

                // Tab #3
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: Text('Calendrier Bouks'),
          ),
          body: TabBarView(
            children: [
              // Tab #1
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TableCalendar(
                      events: _events,
                      initialCalendarFormat: CalendarFormat.month,
                      formatAnimation: FormatAnimation.slide,
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      calendarStyle: CalendarStyle(
                          canEventMarkersOverflow: true,
                          todayColor: Colors.orange,
                          selectedColor: Theme.of(context).primaryColor,
                          todayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white)),
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.deepPurple[300],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        formatButtonShowsNext: false,
                      ),
                      onDaySelected: (date, events, holidays) {
                        setState(() {
                          _selectedEvents = events;
                        });
                      },

                      builders: CalendarBuilders(
                          selectedDayBuilder: (context, date, events) => Container(
                                  margin: const EdgeInsets.all(4.0),
                                  padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                                  color: Colors.deepOrange[300],
                                  width: 100,
                                  height: 100,
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle().copyWith(fontSize: 16.0),
                                  ),
                              ),

                          todayDayBuilder: (context, date, events) => Container(
                                margin: const EdgeInsets.all(4.0),
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 6.0),
                                color: Colors.red[100],
                                width: 100,
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${date.day}',
                                      style:
                                          TextStyle().copyWith(fontSize: 16.0),
                                    ),
                                    Icon(
                                      Icons.arrow_circle_down_rounded,
                                      size: 20.0,
                                    ),
                                  ],
                                ),
                              )),


                      calendarController: _controller,
                    ),



                    // Affichage en bas de la page
                    ..._selectedEvents.map((event) => ListTile(
                          title: Text('$event',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                             color: Colors.pink),
                          ),
                        )
                    ),

                  ],
                ),
              ),

              // Tab #2
              Icon(Icons.calendar_today),

              // Tab #3
              Icon(Icons.settings),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _showAddDialog,
          ),
        ),
      ),
    );
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
                  child: Text("Save"),
                  onPressed: () {
                    if (_eventController.text.isEmpty) return;
                    if (_events[_controller.selectedDay] != null) {
                      _events[_controller.selectedDay]
                          .add(_eventController.text);
                    } else {
                      _events[_controller.selectedDay] = [
                        _eventController.text
                      ];
                    }
                    prefs.setString("events", json.encode(encodeMap(_events)));
                    _eventController.clear();
                    Navigator.pop(context);
                  },
                )
              ],
            ));
    setState(() {
      _selectedEvents = _events[_controller.selectedDay];
    });
  }
}
