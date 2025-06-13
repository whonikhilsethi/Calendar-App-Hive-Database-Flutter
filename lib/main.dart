import 'package:calendar_app/widgets/calendar.dart';
import 'package:calendar_app/hive_objects/category.dart';
import 'package:calendar_app/widgets/category.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'hive_objects/event.dart';
import 'widgets/event.dart';

late Box<Category> categoryBox;
late Box<Event> eventBox;
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Category>(CategoryAdapter());
  Hive.registerAdapter<Event>(EventAdapter());

  categoryBox = await Hive.openBox<Category>("categories");
  eventBox = await Hive.openBox<Event>("events");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Calendar(),
        EventDetails.routeName: (context) => const EventDetails(),
        CategoryDetail.routeName: (context) => const CategoryDetail(),
      },
    );
  }
}
