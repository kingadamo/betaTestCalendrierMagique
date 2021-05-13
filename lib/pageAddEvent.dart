import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';

class pageAddEvent extends StatefulWidget {
  var _events = {};
  var _selectedEvents = [];
  var _controller = CalendarController();
  pageAddEvent();
  @override
  _pageAddEventState createState() => _pageAddEventState();
}

class _pageAddEventState extends State<pageAddEvent> {
  var _events = {};
  var txt;
  var _selectedEvents = [];
  var _controller = CalendarController();
  _pageAddEventState();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Examen (4 séances)';
  String dureeTotaleString = "0";
  var dureeTotale;

  final nameTacheController = TextEditingController();
  final nombreSeanceController = TextEditingController();
  final descriptionTacheController = TextEditingController();

  final List<String> _autoOptionsNom = <String>[
    'Examen de ',
    'Travail de ',
    'Laboratoire de ',
    'Rédaction de ',
  ];
  String userTaskName;

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
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajouter une tâche"),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child:
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, 2),
                  colors: [const Color(0xFF04273D), const Color(0xFF0E86D4)],
                  //colors: [ const Color(0xFF0E86D4), const Color(0xFF04273D)],
                ),
                border: Border.all(
                  color: Color(0xFF001227),
                  width: 4,
                ),
              ),
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Nom de tache
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(
                                  top: 10.0, left: 10, bottom: 10.0, right: 10),
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
                              margin: const EdgeInsets.only(bottom: 5.0, left:10),
                              //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                              child: Text(
                                'Description :',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            margin:
                                const EdgeInsets.only(bottom: 5.0, left: 10),
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

                      // Presets de tache
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.all(10),
                              //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                              child: Text(
                                'Preset :',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blueGrey[200]),
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Examen (4 séances)',
                                'Examen (7 séances)',
                                'Travail (1 séance)',
                                'Travail (2 séances)',
                                "Lecture Livre (14 séances)"
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      // Nombres de seances
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(
                                  top: 10.0, left: 10, bottom: 10.0, right: 10),
                              //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                              child: Text(
                                "Nombre de séances :",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: TextFormField(
                              controller: nombreSeanceController,
                              onSaved: (String value) {},
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Ce champs est requis';
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Nombre',
                                labelText: 'Nombre',
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
                              margin: const EdgeInsets.all(10),
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
                                            child:
                                                Text('Selectionner une durée')),
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  10,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              child: CupertinoTimerPicker(
                                                onTimerDurationChanged:
                                                    (value) {
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
                                                    style: TextStyle(
                                                        color: Colors.red),
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

                      // Date Limite
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.all(10),
                              //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                              child: Text(
                                'Date Limite :',
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
                              SizedBox(
                                height: 0.0,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10.0),
                                color: Colors.blue[700],
                                child: IconButton(
                                  icon: Icon(Icons.calendar_today_sharp),
                                  onPressed: () => _selectDate(context),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFCF000F),
                              const Color(0xFF450005)
                            ],
                            //colors: [ const Color(0xFF0E86D4), const Color(0xFF04273D)],
                          ),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            //returns true if the form is valid, or false if otherwise.
                            if (_formKey.currentState.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Processing Data (correct!)')));
                            }
                          },
                          child: Text('Planifier'),
                        ),
                      ),
                    ]),
              ),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, 2),
                    colors: [const Color(0xFFCF000F), const Color(0xFF450005)],
                    //colors: [ const Color(0xFF0E86D4), const Color(0xFF04273D)],
                  ),
                ),
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go back!'),
                ),
              ),
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
}
