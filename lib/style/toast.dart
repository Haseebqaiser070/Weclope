import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToastLong(String message, Color color) {
  return Fluttertoast.showToast(
      msg: message, //Item Uploaded Successfully
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

showToastShort(String message, Color color) {
  Fluttertoast.showToast(
      msg: message, //Item Uploaded Successfully
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
