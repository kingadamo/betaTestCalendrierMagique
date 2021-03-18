import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendrier Bouks',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    initPrefs();
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
    return newMap;
  }

  // Décodage map
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
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
                      initialCalendarFormat: CalendarFormat.week,
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
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        formatButtonShowsNext: false,
                      ),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: (date, events, holidays) {
                        setState(() {
                          _selectedEvents = events;
                        });
                      },
                      builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) =>
                            Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                        todayDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      calendarController: _controller,
                    ),
                    ..._selectedEvents.map((event) => ListTile(
                          title: Text(event),
                        )),
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
