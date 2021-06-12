import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reunionou_app/models/Auth.dart';
import 'package:reunionou_app/models/EventAuthor.dart';
import 'package:reunionou_app/models/Location.dart';
import 'package:reunionou_app/pages/Auth/Login.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:reunionou_app/pages/CreateEvent.dart';
import 'package:reunionou_app/pages/EventPage.dart';
import 'package:reunionou_app/utils/layout/topNavBar.dart';
import 'package:reunionou_app/models/Event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:reunionou_app/widgets/EventPreview.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  static const routeIndex = 0;

  final Auth loggedUser;

  const Home(this.loggedUser);

  @override
  _HomeState createState() => new _HomeState();
}
class _HomeState extends State<Home>{

  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    if(this.widget.loggedUser.connected == true)
      _loadEvent();
  }

  void _loadEvent() async{
    List<Event> eventsReturn = [];

    var queryParameters = {
      'token' : this.widget.loggedUser.token,
    };
    final url = Uri(
      scheme: 'http',
      host: 'api.local',
      port: 19080,
      path: '/events',
      queryParameters: queryParameters,
    );
    final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "Token ${this.widget.loggedUser.token}",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        });
    print('donné reçuu : ' + this.widget.loggedUser.token);
    print('status code ${response.statusCode}');
    if(response.statusCode == 200){
      final data = convert.jsonDecode(response.body);
      print(data);
      if(data['error'] == null) {
        print("pas d'erreur dans la reception");
        print('owned : ' + data['owned'].toString());
        data['owned'].forEach((event){
          print("owned");
          EventAuthor author = new EventAuthor(event["author"]["id"], event["author"]["fullname"], event["author"]["email"]);
          Location location = new Location(event["location"]["id"], event["location"]["name"], event["location"]["x"], event["location"]["y"]);
          Event unEvent = new Event(event["id"], author, event["title"], event["description"], event["date"], event["token"], location, true);
          eventsReturn.add(unEvent);
        });
        data['shared'].forEach((event){
          print("shared");
          EventAuthor author = new EventAuthor(event["author"]["id"], event["author"]["fullname"], event["author"]["email"]);
          Location location = new Location(event["location"]["id"], event["location"]["name"], event["location"]["x"], event["location"]["y"]);
          Event unEvent = new Event(event["id"], author, event["title"], event["description"], event["date"], event["token"], location, false);
          eventsReturn.add(unEvent);
        });

        setState(() {
          events = eventsReturn;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: HexColor("#f9fbf2"),
      appBar: topNavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(this.events != null)
                        for(Event unEvent in this.events) EventPreview(unEvent)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: HexColor("#4E1A1A"),
            items: [
              new BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home),
                label: 'Accueil',
              ),
              new BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user),
                label: 'Settings',
              )
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (ctxt) => new CreateEvent(this.widget.loggedUser))
          );

        },
        backgroundColor: HexColor("#4E1A1A"),
      ),
    );
  }
}