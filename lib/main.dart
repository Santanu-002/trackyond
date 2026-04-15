import 'package:flutter/material.dart';
import 'package:trackyond/app/trackyond_app.dart';
import 'package:trackyond/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();

  runApp(const TrackyondApp());
}
