import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

  String dropdownValue = 'One';
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
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    height: 120,
                    child: Form(
                      key:_formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                                    child: Text(
                                      'Nom de tâche :',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16),
                                    )
                                ),
                                Container(
                                 width:150,
                                  child: TextFormField(
                                    autofillHints: [AutofillHints.name],
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                    ),
                                  ),
                                ),

                                Container(
                                  color: Color(0xFF04273D),
                                  width: 200,
                                  child: Autocomplete(
                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<String>.empty();
                                      }
                                      userTaskName = textEditingValue.text;
                                      return _autoOptionsNom.where((String option) {
                                        //Edit les majuscules
                                        return option.toLowerCase().contains(
                                            textEditingValue.text.toLowerCase());
                                      });
                                    },
                                    onSelected: (String selection) {
                                      print('Valeur pre-choisis :  $selection');
                                      print(userTaskName);
                                    },

                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  color: Color(0xFF04273D),
                                  width: 200,
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueGrey
                                    ),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.white,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: <String>['One', 'Two', 'Three', 'Four']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),

                          ]
                      ),
                    ),
                  ),
                  Container(
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
                ]),
          ),
        ),
      ),
    );
  }
}
