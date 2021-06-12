import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:reunionou_app/models/Auth.dart';
import 'package:reunionou_app/models/Event.dart';
import 'package:reunionou_app/models/User.dart';
import 'package:reunionou_app/pages/Auth/Login.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:reunionou_app/utils/layout/topNavBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import'dart:math' as Math;

class EventPage extends StatelessWidget{
  static const routeName = '/event';
  static const routeIndex = 2;

  final Auth loggedUser;
  Event event;

  EventPage(this.loggedUser);

  double getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2-lat1);  // deg2rad below
    var dLon = deg2rad(lon2-lon1);
    var a =
        Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
                Math.sin(dLon/2) * Math.sin(dLon/2)
    ;
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    var d = R * c; // Distance in km
    return d;
  }

  double deg2rad(deg) {
    return deg * (Math.pi/180);
  }

  void _init(BuildContext context){
    //GET EVENT
    event = ModalRoute.of(context).settings.arguments;

    //GET DISTANCE (en KM avec que 2 chiffres après la virgule)
    event.distanceBetweenAuth = num.parse(getDistanceFromLatLonInKm(event.location.x,event.location.y,loggedUser.lat,loggedUser.long).toStringAsFixed(2));

    //CONVERT DATE ENG TO FR
    if(!event.date.contains("à")) {
      var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      var dateOLD = inputFormat.parse(event.date);
      var hourTime = DateFormat.Hms().format(dateOLD);

      inputFormat = DateFormat("yyyy-MM-dd");
      dateOLD = inputFormat.parse(event.date);

      var outputFormat = DateFormat("dd/MM/yyyy");
      event.date = outputFormat.format(dateOLD) + " à " + hourTime;
    }

    //LOAD INVITED/SHARED USER LIST
    _loadInvitedUser();
  }

  void _loadInvitedUser() async{
    List<User> _invitedUser = [];

    var queryParameters = {
      'token' : this.loggedUser.token,
    };
    final url = Uri(
      scheme: 'http',
      host: 'api.local',
      port: 19080,
      path: '/shared/' + event.id.toString(),
      queryParameters: queryParameters,
    );
    final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "Token ${this.loggedUser.token}",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        });
    if(response.statusCode == 200){
      final data = convert.jsonDecode(response.body);
      data.forEach((user){
        User unUser = new User(user["user"]["id"], user["user"]["fullname"], user["user"]["email"]);
        _invitedUser.add(unUser);
      });
      event.invitedUser = _invitedUser;
    }
  }

  @override
  Widget build(BuildContext context){
  _init(context);

    return Scaffold(
        backgroundColor: HexColor("#f9fbf2"),
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
                  event.title,
                  style: TextStyle(
                      color: Colors.black
                  ),
                )
              ],
            )
        ),
        body:
        new FlutterMap(
          options: new MapOptions(
            center: new LatLng(event.location.x, event.location.y),
            zoom: 13.0,
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate: "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
              additionalOptions: {
                'accessToken': 'pk.eyJ1IjoibHVjYXM4NTUiLCJhIjoiY2ttdWdleHZnMTFiejJ3cG05YmtuaDQ5bCJ9.NjQZOuusPTQ-Fs87VrlPkg',
                'id': 'mapbox/streets-v11',
              },
            ),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: new LatLng(event.location.x, event.location.y),
                  builder: (ctx) =>
                  new Container(
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.mapMarkerAlt),
                      color: HexColor("#5B1F1F"),
                      iconSize: 45.0,
                      onPressed: (){
                        showModalBottomSheet(context: context, builder: (builder) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                            ),

                            child: new Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top : 10,
                                      bottom : 10
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: HexColor("#772828"),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        
                                        Text(
                                          event.title,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20
                                          ),
                                        ),
                                        
             
                                        Text(
                                          event.description,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                   
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    MaterialButton(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(FontAwesomeIcons.listAlt, color: HexColor("#4E1A1A")),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "Invités",
                                              style: TextStyle(
                                                color: HexColor("#4E1A1A"),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        print("send mail author");
                                      },
                                    ),
                                    MaterialButton(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(FontAwesomeIcons.comments, color: HexColor("#4E1A1A")),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "Remarque",
                                              style: TextStyle(
                                                color: HexColor("#4E1A1A"),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        print("send mail author");
                                      },
                                    ),
                                    if(event.author.fullname == loggedUser.fullname) ...[
                                      MaterialButton(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  4.0),
                                              child: Icon(
                                                  FontAwesomeIcons.share,
                                                  color: HexColor("#4E1A1A")),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  2.0),
                                              child: Text(
                                                "Partager",
                                                style: TextStyle(
                                                  color: HexColor("#4E1A1A"),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          print("partager l'évenement");
                                        },
                                      ),
                                    ]
                                    else ...[
                                      MaterialButton(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Icon(FontAwesomeIcons.envelope, color: HexColor("#4E1A1A")),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Text(
                                                "Contacter",
                                                style: TextStyle(
                                                  color: HexColor("#4E1A1A"),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          print("partager l'évenement");
                                        },
                                      ),
                                    ]
                                  ],
                                ),
                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.only(right:15), child: Icon(FontAwesomeIcons.mapMarkerAlt, color: HexColor("#4E1A1A"))),
                                        Expanded(child: Text(
                                          event.location.name.toUpperCase(),
                                          style: TextStyle(color: Colors.black, fontSize: 16),
                                        ),
                                        ),
                                      ],
                                    )
                                ),
                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.only(right:15), child: Icon(FontAwesomeIcons.road, color: HexColor("#4E1A1A"))),
                                        Expanded(child: Text(
                                          "Vous êtes à " + event.distanceBetweenAuth.toString() + "km de l'événement",
                                          style: TextStyle(color: Colors.black, fontSize: 16),
                                        ),
                                        ),
                                      ],
                                    )
                                ),
                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.only(right:15), child: Icon(FontAwesomeIcons.calendarDay, color: HexColor("#4E1A1A"))),
                                        Text(
                                          event.date,
                                          style: TextStyle(color: Colors.black, fontSize: 16),
                                        )
                                      ],
                                    )
                                ),
                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.only(right:15), child: Icon(FontAwesomeIcons.userAlt, color: HexColor("#4E1A1A"))),
                                        if(event.author.fullname == loggedUser.fullname) ...[
                                          Expanded(child:
                                          Text(
                                            event.author.fullname.toUpperCase() + " (VOUS)",
                                            style: TextStyle(color: Colors.black, fontSize: 16),
                                          ))
                                        ]else ...[
                                          Expanded(child:
                                          Text(
                                            event.author.fullname.toUpperCase(),
                                            style: TextStyle(color: Colors.black, fontSize: 16),
                                          ))
                                        ]
                                      ],
                                    )
                                ),
                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.only(right:15), child: Icon(FontAwesomeIcons.teamspeak, color: HexColor("#4E1A1A"))),
                                        Text(
                                          event.invitedUser.length.toString() + " invité(s)",
                                          style: TextStyle(color: Colors.black, fontSize: 16),
                                        )
                                      ],
                                    )
                                )
                              ],
                              ////////////////////////////////////////////////// CHANGER LES LOGO (contact et partager) :
                              ////////////////////////////////////////////////// PARTICIPANTS - CONTACTER  - user normal (afficher participant si c'est pas un événement public avec un ;lien (token)
                              ////////////////////////////////////////////////// PARTICIPANTS - PARTAGER - user créateur de l'evenement
                              //////////////////////////////////////////////////
                              ////////////////////////////////////////////////// MODI>FIER l'evenement si c'est le créateur
                              //////////////////////////////////////////////////
                              //////////////////////////////////////////////////
                              //////////////////////////////////////////////////
                              //////////////////////////////////////////////////
                              //////////////////////////////////////////////////
                              //////////////////////////////////////////////////
                              //////////////////////////////////////////////////
                              //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                              //////////////////////////////////////////////////
                              //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                              //////////////////////////////////////////////////
                              //////////////////////////////////////////////////
                              //////////////////////////////////////////////////




                            ),
                          );
                        },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}