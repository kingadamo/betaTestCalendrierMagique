import 'package:flutter/material.dart';

class tabSettings extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Container(
        decoration : BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment(0.0, 2),
            colors: [ const Color(0xFF04273D), const Color (0xFF0E86D4) ],
            //colors: [ const Color(0xFF0E86D4), const Color(0xFF04273D)],
          ),
        ),

        child: Icon(Icons.settings)
    );

  }
}