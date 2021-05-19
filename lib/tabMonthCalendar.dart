import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import './dayView.dart';
import './dayViewOther.dart';
import './globals.dart' as globals;

/// Le ficheir @tabMonthCalendar s'occupe d'afficher le contenu du deuxième
/// onglet (affichage mensuel).
/// L'affichage inclus le table_calendar, récapitulatif du mois.

class tabMonthCalendar extends StatefulWidget {
  var events = {};
  var selectedEvents = [];
  var controller = CalendarController();
  tabMonthCalendar(this.events, this.selectedEvents, this.controller);
  @override
  _tabMonthCalendarState createState() =>
      _tabMonthCalendarState(this.events, this.selectedEvents, this.controller);
}

class _tabMonthCalendarState extends State<tabMonthCalendar>
    with TickerProviderStateMixin {
  var events = {};
  var selectedEvents = [];
  var controller = CalendarController();
  _tabMonthCalendarState(this.events, this.selectedEvents, this.controller);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // Décoration de la section englobant le header et le TableCalendar
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, 2),
                  colors: [const Color(0xFF04273D), const Color(0xFF0E86D4)],
                  //colors: [ const Color(0xFF0E86D4), const Color(0xFF04273D)],
                ),
              ),
              child: TableCalendar(
                events: events,
                initialCalendarFormat: CalendarFormat.month,
                formatAnimation: FormatAnimation.slide,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                daysOfWeekStyle: DaysOfWeekStyle(decoration: BoxDecoration()),
                calendarStyle: CalendarStyle(
                    markersColor: Color(0xFF540B0E),
                    canEventMarkersOverflow: true,
                    todayColor: Colors.orange,
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white)),
                headerStyle: HeaderStyle(
                  headerMargin:
                      EdgeInsets.only(top: 15, bottom: 20, left: 2, right: 2),
                  centerHeaderTitle: true,
                  // DECO COULEURS
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.0, 7),
                      colors: [
                        const Color(0xFFCF000F),
                        const Color(0xFF450005)
                      ],
                    ),
                  ),
                  formatButtonDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.0, 2),
                      colors: [
                        const Color(0xFF0E86D4),
                        const Color(0xFF074166)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonShowsNext: false,
                ),
                onDaySelected: (date, events, holidays) {
                  setState(() {
                    selectedEvents = events;
                  });
                },
                builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF0E86D4),
                                const Color(0xFF450005)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: 100,
                          height: 100,
                          child: Text(
                            '${date.day}',
                            style: TextStyle().copyWith(fontSize: 18.0),
                          ),
                        ),
                    todayDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF002969),
                                const Color(0xFF450005)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          width: 100,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${date.day}',
                                style: TextStyle().copyWith(fontSize: 18.0),
                              ),
                              Icon(
                                Icons.arrow_circle_down_rounded,
                                size: 18.0,
                              ),
                            ],
                          ),
                        )),
                calendarController: controller,
              ),
            ),

            // Affichage en bas de la page
            ...selectedEvents.map( (event) => ListTile(
                title: Text(
                  '$event',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                trailing:
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    showModalBottomSheet<void>(
                        transitionAnimationController: AnimationController(
                            duration: const Duration(milliseconds: 500),
                            vsync: this),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment(0.0, 2),
                                colors: [const Color(0xFF0E86D4), const Color(0xFF04273D)],
                                //colors: [ const Color(0xFF0E86D4), const Color(0xFF04273D)],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 28, right: 20, bottom: 25),
                              child: dayViewOther(globals.eventsDetailled, controller.selectedDay),
                            ),
                          );
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
