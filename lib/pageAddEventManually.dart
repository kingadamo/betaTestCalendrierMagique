import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import './main.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/services.dart';

class pageAddEventManually extends StatefulWidget {
  var _events = {};
  var _selectedEvents = [];
  var _controller = CalendarController();
  pageAddEventManually(this._controller);
  @override
  _pageAddEventManuallyState createState() =>
      _pageAddEventManuallyState(this._controller);
}

class _pageAddEventManuallyState extends State<pageAddEventManually> {
  var _events = {};
  var txt;
  var _selectedEvents = [];
  var _controller = CalendarController();

  _pageAddEventManuallyState(this._controller);

  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Examen (4 séances)';
  String dureeTotaleString = "0";
  var dureeTotale;

  final nameTacheController = TextEditingController();
  //final nombreSeanceController = TextEditingController();
  final descriptionTacheController = TextEditingController();

  String userTaskName;

  Widget build(BuildContext context) {
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
        padding:
            const EdgeInsets.only(left: 20, top: 28, right: 20, bottom: 25),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Nom de tache
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 10, top: 10, right: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment(0.0, 1),
                        colors: [
                          const Color(4280302932),
                          const Color(0xFF04273D)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "Planification manuelle",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, right: 10),
                        //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                        child: Text(
                          'Nom de tâche :',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextFormField(
                        controller: nameTacheController,
                        onSaved: (String value) {},
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Ce champs est requis';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Name',
                          labelText: 'Entrer un nom de tache',
                        ),
                      ),
                    ),
                  ],
                ),

                // Description de tache
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                        child: Text(
                          'Description :',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      margin: const EdgeInsets.only(bottom: 5.0, left: 10),
                      child: TextFormField(
                        controller: descriptionTacheController,
                        onSaved: (String value) {},
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Ce champs est requis';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Description',
                          labelText: 'Entrer une description de tache',
                        ),
                      ),
                    ),
                  ],
                ),

                // Duree Totale
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        //margin: const EdgeInsets.all(10),
                        //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                        child: Text(
                      'Durée Totale :',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    )),
                    Container(
                      child: Text(
                        "${dureeTotaleString}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[0]),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      color: Colors.blue[700],
                      child: IconButton(
                          icon: Icon(Icons.access_alarm_rounded),
                          onPressed: () {
                            print('timer');
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  backgroundColor: Color(0xFF001227),
                                  title: Center(
                                      child: Text('Selectionner une durée')),
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                10,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: CupertinoTimerPicker(
                                          onTimerDurationChanged: (value) {
                                            print(value.toString());
                                            setState(() {
                                              dureeTotaleString =
                                                  value.toString();
                                              dureeTotale = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Annuler',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              // Todo save the selected duration to the ViewModel
                                              Navigator.pop(context);
                                            },
                                            child: Text('Soumettre')),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                    )
                                  ],
                                );
                              },
                            );
                          }),
                    ),
                  ],
                ),

                // Date Selectionne
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                        child: Text(
                          'D/H de début:',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                        )),
                    Container(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[0]),
                          ),
                        ),
                        Container(
                          child: Text(
                            " à ${selectedDate.toLocal().hour}h${selectedDate.minute}m",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[0]),
                          ),
                        ),
                        SizedBox(
                          height: 0.0,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          color: Colors.blue[700],
                          child: IconButton(
                            icon: Icon(Icons.calendar_today_sharp),
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now().subtract(Duration(days: 14)),
                                  maxTime: DateTime(2050, 1, 1),
                                  onChanged: (date) {
                                setState(() {
                                  selectedDate = date;
                                });
                              }, onConfirm: (date) {
                                setState(() {
                                  selectedDate = date;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.fr);
                              // _selectDate(context);
                            },
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),

                // Deux boutons bottom page
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF04273D),
                              shadowColor: Color(0xFF04273D),
                              elevation: 16,
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Annuler')),
                        ElevatedButton.icon(
                          icon: Icon(Icons.check_circle),
                          label: Text('Valider'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF5F1A1E),
                            shadowColor: Color(0xFF04273D),
                            elevation: 16,
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Planification manuelle ajoutée (valide!)',)
                              )
                              );
                              setState(() {
                                ajoutEventDetailledManuel();
                                Navigator.pop(context);
                              });

                            }
                            //Navigator.pop(context);
                          },
                        ),
                      ]),
                ),
              ]),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  // Fonction planification manuelle (ajout dans la matrice)
  void ajoutEventDetailledManuel() {
    var name = nameTacheController.text;
    var description = descriptionTacheController.text;
setState(() {
  AfterSplash.eventsDetailled.add(FlutterWeekViewEvent(
    title: '$name',
    description: '$description',
    start: selectedDate,
    end: selectedDate.add(dureeTotale),
    backgroundColor:
    Colors.primaries[Random().nextInt(Colors.primaries.length)],
  ));
});

  }
}
