import 'package:flutter/material.dart';

AppBar topNavBar(){
  return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,//pour fix le problème de centrage du logo
        children: [
          Image(
            image: AssetImage('assets/images/logo_762x341.png'),
            width: 120,
          )
        ],
      ));
}