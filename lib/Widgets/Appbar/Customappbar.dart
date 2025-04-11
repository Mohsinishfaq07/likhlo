import 'package:flutter/material.dart';
import 'package:likhlo/Utils/Textstyle/Textstyle.dart';

AppBar CustomAppbar(String label) {
  return AppBar(
    title: Text(label),
    centerTitle: true,
    backgroundColor: Colors.blue,
    titleTextStyle: AppStyle(25, FontWeight.bold, Colors.white),
  );
}
