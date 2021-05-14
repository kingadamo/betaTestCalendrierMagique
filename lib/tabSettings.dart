import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

class tabSettings extends StatefulWidget{
  tabSettings();
  @override
  _tabSettingsState createState() => _tabSettingsState();
}


class _tabSettingsState extends State<tabSettings> {
  double _slider = 0.5;
  bool _switch = false;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.blue[800],
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Paramètres"),
      ),
      child: CupertinoSettings(
        items: <Widget>[
          const CSHeader('Luminosité'),
          CSWidget(
            CupertinoSlider(
              value: _slider,
              onChanged: (double value) => setState(() => _slider = value),
            ),
            style: CSWidgetStyle(
              icon: Icon(FontAwesomeIcons.sun),
            ),
            addPaddingToBorder: true,
          ),
          CSControl(
            nameWidget: Text('Auto brightness'),
            contentWidget: CupertinoSwitch(
              value: _switch,
              onChanged: (bool value) => setState(() => _switch = value),
            ),
            style: CSWidgetStyle(
              icon: Icon(FontAwesomeIcons.sun),
            ),
            addPaddingToBorder: false,
          ),
          const CSHeader("Mode d'affichage"),
          CSSelection<int>(
            items: const <CSSelectionItem<int>>[
              CSSelectionItem<int>(text: 'Day mode', value: 0),
              CSSelectionItem<int>(text: 'Night mode', value: 1, subtitle: "Économie d'énergie"),
            ],
            onSelected: (value) => setState(() => _index = value),
            currentSelection: _index,
          ),
          const CSDescription(
            'Using Night mode extends battery life on devices with OLED display',
          ),
          const CSHeader("Info"),
          CSButton(CSButtonType.DEFAULT, "Informations", () {
            _showCreateursDialog();
          }),
          const CSHeader(""),
          CSSecret("Votre horoscope : ", "-.- vraiment?"),
          CSButton(CSButtonType.DESTRUCTIVE, "Delete all data", () {}),
        ],
      ),
    );
  }

  _showCreateursDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Planr 1.0.0'
              '\n\nAdam - Mina - Sophie'
              "\n\nDans le cadre du projet d'intégration"
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                    Navigator.pop(context, true);
              },
            )
          ],
        ));
  }

}
