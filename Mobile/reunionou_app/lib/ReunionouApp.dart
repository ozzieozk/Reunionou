import 'package:flutter/material.dart';
import 'package:reunionou_app/models/Auth.dart';
import 'package:reunionou_app/pages/Auth/Login.dart';
import 'package:reunionou_app/pages/Auth/Signin.dart';
import 'package:reunionou_app/pages/CreateEvent.dart';
import 'package:reunionou_app/pages/EventPage.dart';
import 'package:reunionou_app/pages/Home.dart';
import 'package:hexcolor/hexcolor.dart';

class ReunionouApp extends StatefulWidget {

  @override
  _ReunionouAppState createState() => _ReunionouAppState();
}

class _ReunionouAppState extends State<ReunionouApp>{
  Auth userAuth = Auth();

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'ReunionOu',
      home: (userAuth.token != null) ? Home(userAuth) : Login(userAuth: userAuth),
      theme: ThemeData(
        primaryColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: HexColor('#AC3A3A'),
            onPrimary: Colors.white,
          )
        ),
      ),
      routes: {
        //attention peu importe la route initial, quand l'app se lance elle passe toujours par la route "/"
        //on fait donc la vérification user connected dans la route "/"
        '/home': (context) => (userAuth.token != null) ? Home(userAuth) : Login(userAuth: userAuth),
        '/login': (context) => Login(userAuth: userAuth),
        '/signin': (context) => Signin(),
        '/event': (context) => EventPage(userAuth),
        '/createEvent': (context) => CreateEvent(userAuth),
      },
    );
  }
}