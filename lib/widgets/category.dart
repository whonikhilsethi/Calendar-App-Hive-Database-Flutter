import 'package:calendar_app/func.dart';
import 'package:calendar_app/widgets/event.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../hive_objects/event.dart';
import '../main.dart';

class CategoryDetail extends StatefulWidget {
  const CategoryDetail({super.key});

  static const routeName = "category";

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> with Func {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CategoryArguement;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          'Category: ${args.category}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ValueListenableBuilder<Box<Event>>(
        valueListenable: eventBox.listenable(),
        builder: (context, box, widget) {
          List<Event> events = getByCategory(args.category);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      EventDetails.routeName,
                      arguments: EventArguements(
                        DayFocused: events[index].date,
                        view: true,
                        event: events[index],
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                DateFormat.E().format(events[index].date),
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                DateFormat.d().format(events[index].date),
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 90,
                            width: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: VerticalDivider(
                                color: Colors.deepPurpleAccent,
                                thickness: 2,
                                indent: 10,
                                endIndent: 10,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                Text(
                                  events[index].eventName,
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                ActionChip(
                                  label: Text(
                                    events[index].category[0].name,
                                    style: TextStyle(
                                      color: Colors.deepPurpleAccent.shade700,
                                    ),
                                  ),
                                  onPressed: () {},

                                  backgroundColor: Colors.yellowAccent.shade100,
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.keyboard_arrow_right),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CategoryArguement {
  final String category;

  CategoryArguement({required this.category});
}
