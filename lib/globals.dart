library com.example.calendrier_test.globals;
import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

/// Le fichier @globals sert a stocker des variables qui sont partagés à travers
/// tout le programme et qui pourrait être corrompu à force de les importer.
/// La librairie est importé dans les classes qui ont en besoin.

Map<DateTime, List<dynamic>> events=  {};


var eventsDetailled = [
  FlutterWeekViewEvent(
    title: 'Changer les pneus de la Tesla',
    description: 'Changement saisonnier',
    start: DateTime.parse("2021-05-18 12:20:00Z"),
    end: DateTime.parse("2021-05-18 13:15:00Z"),
  ),
  FlutterWeekViewEvent(
    title: 'Étude examen de math',
    description: 'étude de groupe',
    start: DateTime.parse("2021-05-18 16:30:00Z"),
    end: DateTime.parse("2021-05-18 18:30:00Z"),
    backgroundColor: Colors.green[800],
  ),
  FlutterWeekViewEvent(
    title: 'Exemple 3',
    description: 'Description ex3',
    start: DateTime.parse("2021-05-20 16:30:00Z"),
    end: DateTime.parse("2021-05-20 18:30:00Z"),
    backgroundColor: Colors.green[800],
  )
];