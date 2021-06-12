import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reunionou_app/models/Event.dart';
import 'package:reunionou_app/pages/EventPage.dart';

class EventPreview extends StatelessWidget{

  final Event event;
  EventPreview(this.event);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, EventPage.routeName, arguments: event);
      },
      child: Card(
        child: ListTile(
          leading: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(FontAwesomeIcons.calendarAlt),
          ),
          title: Text(
            this.event.title,
            style: TextStyle(
                fontFamily: 'Knewave', color: Colors.black
            ),
          ),
        ),
      ),
    );
  }
}