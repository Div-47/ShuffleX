import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shuffle_x/ui/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      home: MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
         
          primarySwatch: Colors.blue,
        ),
        home: Login(),
      ),
    );
  }
}
