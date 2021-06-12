import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

SnackBar snackBarAlert(message, status){
  return SnackBar(
    content:Text(message),
    duration: ((status == 'error') ? const Duration(seconds: 30) : const Duration(seconds: 15)),
    backgroundColor: (status == 'warning') ? HexColor("#af9800") : (status == 'success') ? HexColor('#588157') : (status == 'error') ? HexColor('#772828') : 'null',
  );
}