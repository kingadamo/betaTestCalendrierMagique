import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

/// La classe @dayView prend en charge l'affichage les événements quotidiens
/// Les événements sont affichés dans un tableau à intervalles de 30 minutes
/// et comportent une heure de début, une heure de fin, un titre, une
/// description et une couleur de background générée aléatoirement.

class dayView extends StatefulWidget {
  var eventsDetailled = [];
  var dateToShow;
  dayView(this.eventsDetailled, this.dateToShow);
  @override
  _dayViewState createState() => _dayViewState(this.eventsDetailled, this.dateToShow);
}

class _dayViewState extends State<dayView> {
  DayViewController _controller = DayViewController();
  var eventsDetailled = [];
  var dateToShow;
  _dayViewState(this.eventsDetailled, this.dateToShow);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    HourMinute _heureActuelle = HourMinute.now();
    HourMinute _heureMinimum = _heureActuelle.subtract(HourMinute(hour: 1, minute: 0));
    return Container(
      child: DayView(
        controller: _controller,
        date: dateToShow,
        userZoomable: true,
        minimumTime: _heureMinimum,
        inScrollableWidget: true,
        hoursColumnStyle: HoursColumnStyle(
            interval: Duration(minutes: 30),
            textStyle: TextStyle(color: Colors.white, fontSize: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFFCF000F), const Color(0xFF0E86D4)],
                //colors: [ const Color(0xFF0E86D4), const Color(0xFF04273D)],
              ),
            )),
        dayBarStyle: DayBarStyle(
            color: Color(0xFFCF000F),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [const Color(0xFFCF000F), const Color(0xFF450005)],
                //colors: [ const Color(0xFF0E86D4), const Color(0xFF04273D)],
              ),
            )),
        events: eventsDetailled,
        style: DayViewStyle.fromDate(
          date: now,
          currentTimeCircleRadius: 8,
          hourRowHeight: 150,
          headerSize: 25,
          backgroundRulesColor: Color(0xFF04273D),
          currentTimeRuleColor: Color(0xFF04273D),
          currentTimeRuleHeight: 3,
          currentTimeCircleColor: Color(0xFF04273D),
        ),
      ),
    );
  }
}
