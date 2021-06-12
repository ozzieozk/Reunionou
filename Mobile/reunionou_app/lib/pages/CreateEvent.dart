import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:reunionou_app/models/Auth.dart';
import 'package:reunionou_app/pages/Home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart';
import 'package:geolocation/geolocation.dart';

class CreateEvent extends StatefulWidget {
  static const routeName = '/createEvent';
  static const routeIndex = 3;

  final Auth loggedUser;

  CreateEvent(this.loggedUser);

  @override
  _CreateEventState createState() => new _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String nom;
  String description;
  DateTime date;
  DateTime hour;
  String nomLieu;
  double lat;
  double long;



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formCreateEventKey = GlobalKey<FormState>();
    GlobalKey _scaffoldKey = GlobalKey();
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Créer un évènement",
                style: TextStyle(
                    color: Colors.black
                ),
              )
            ],
          )
      ),
      body: Form(
        key: _formCreateEventKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 48.0,
              child: Image.asset('assets/images/logo_1024x1024.png'),
            ),
            SizedBox(height: 48.0),
            TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                labelText: "Intitulé de l'évènement",
                contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
              ),
              onSaved: (String value){nom=value;},
            ),
            SizedBox(height: 12.0),
            TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                labelText: "Description",
                contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
              ),
              onSaved: (String value){description=value;},
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              child: Icon(Icons.timelapse),
              onPressed: (){
                Future<TimeOfDay> selectedTime = showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );
              },
            ),
            SizedBox(height: 12.0),
            TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                labelText: "Intitulé du lieu",
                contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
              ),
              onSaved: (String value){nomLieu=value;},
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  /*final FormState form = _formKey.currentState;
                  if(form.validate()){
                    form.save();
                    print("ajouté l'event");
                  }*/
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                ),
                child: Text('Log In', style: TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              onPressed: () {
                print("mot de passe oublié");
              },
            ),
            TextButton(
              child: Text(
                'Create New Account',
                style: TextStyle(
                    color: Colors.black87,
                    decoration: TextDecoration.underline),
              ),
              onPressed: () {
                print("Signin");
              },
            ),
          ],
        ),
      ),
    );
  }
}
