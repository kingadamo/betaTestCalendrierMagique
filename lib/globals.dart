library com.example.calendrier_test.globals;


import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

Map<DateTime, List<dynamic>> events=  {};


var eventsDetailled = [
FlutterWeekViewEvent(
title: 'Changer les pneus de la Tesla',
description: 'changement saisonnier',
start: DateTime.parse("2021-05-13 20:18:00Z"),
end: DateTime.parse("2021-05-13 22:00:00Z"),
),
FlutterWeekViewEvent(
title: 'Regarder Jojo<s bizarre adventure',
description: 'A description 2',
start: DateTime.parse("2021-04-29 21:30:00Z"),
end: DateTime.parse("2021-04-29 23:30:00Z"),
backgroundColor: Colors.green[800],
)
];