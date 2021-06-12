import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'dart:convert' as convert;
import 'package:reunionou_app/utils/snackBarAlert.dart';
import 'package:reunionou_app/pages/Home.dart';

class Auth{
  int id;
  String fullname;
  String email;
  String token;
  bool connected = false;
  double lat;
  double long;

  Future<Auth> seConnecter(String login, String password, context) async{
    var response;
    try {
      final url = Uri.parse('http://api.local:19080/signin');
      response = await http.post(
          url,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"},
          body: {
            'email': login,
            'password': password
          });
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(snackBarAlert("Une erreur a été rencontré, vérifiez votre connexion. Si le problème persiste veuillez contacter l'administrateur.", "error"));
    }
    if(response.statusCode == 200){
      final data = convert.jsonDecode(response.body);
      if(data['fullname'] != null){
        this.fullname = data['fullname'];
        this.email = data['email'];
        this.token = data['token'];
        this.connected = true;
      }
      else
        ScaffoldMessenger.of(context).showSnackBar(snackBarAlert("Vos identifiants de connexion sont incorrects, veuillez réessayer!", "error"));
    }
    else
      ScaffoldMessenger.of(context).showSnackBar(snackBarAlert("Une erreur a été rencontré, vous avez reçu une réponse inattendue.", "error"));
    return this;
  }

}