import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import './pageAddEvent.dart';

class tabPrincipal extends StatefulWidget {
  var _events = {};
  var _selectedEvents = [];
  var _controller = CalendarController();
  tabPrincipal(this._events, this._selectedEvents, this._controller);
  @override
  _tabPrincipalState createState() =>
      _tabPrincipalState(this._events, this._selectedEvents, this._controller);
}

class _tabPrincipalState extends State<tabPrincipal> {
  var _events = {};
  var txt;
  var _selectedEvents = [];
  var _controller = CalendarController();
  _tabPrincipalState(this._events, this._selectedEvents, this._controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.0, 2),
          colors: [const Color(0xFF04273D), const Color(0xFF0E86D4)],
          //colors: [ const Color(0xFF0E86D4), const Color(0xFF04273D)],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF04273D),
            ),
            padding: const EdgeInsets.only(top: 20.0, left: 10, bottom: 20.0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Menu principal",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xff64B6FF), fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pageAddEvent()),
                );
                setState(() {
                  txt = 'FlatButton tapped';
                  print(txt);
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                      colors: [
                        const Color(0xFFCF000F),
                        const Color(0xFF450005)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Planifier une tâche",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ),
          ),


          Container(
            padding: const EdgeInsets.only(top: 20.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  txt = 'FlatButton 2 tapped';
                  print(txt);
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                      colors: [
                        const Color(0xFFCF000F),
                        const Color(0xFF450005)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Bouks",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ),
          ),
          Container(),

        ]
        ),
      ),
    );
  }
}
