import 'package:flutter/material.dart';

class Signin extends StatelessWidget{
  static const routeName = '/signin';
  static const routeIndex = 2;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/logo_762x341.png'),
                  width: 120,
                )
              ],
            )),
        body: Center(
          child:
          Text(
            'Signin',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        )
    );
  }
}