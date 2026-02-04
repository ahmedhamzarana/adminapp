import 'package:flutter/material.dart';
import 'package:watchhub/utils/appconstant.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        title: Text('Watch.Hub') ,
        centerTitle: true,
      ),
      
    );
  }
}