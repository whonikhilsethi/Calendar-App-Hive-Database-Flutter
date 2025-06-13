import 'package:calendar_app/func.dart';
import 'package:calendar_app/widgets/category.dart';
import 'package:calendar_app/widgets/event.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../hive_objects/event.dart';

class EventList extends StatelessWidget with Func {
  final DateTime date;
  final bool all;
  final bool filter;
  final String searchTerm;

  const EventList({
    super.key,
    required this.date,
    required this.all,
    required this.filter,
    required this.searchTerm,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Event>>(
      valueListenable: eventBox.listenable(),
      builder: (context, box, widget) {
        List<Event> events =
            (all)
                ? box.values.toList()
                : (filter)
                ? searchEvent(searchTerm)
                : getEventByDate(date);

        if (events.isEmpty) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: EmptyWidget(
              packageImage: PackageImage.Image_2,
              title: 'Calender App',
              subTitle: 'No Events Found',
              titleTextStyle: TextStyle(
                fontSize: 22,
                color: Colors.deepPurpleAccent,
              ),
              subtitleTextStyle: TextStyle(fontSize: 14, color: Colors.black),
            ),
          );
        } else {
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
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      CategoryDetail.routeName,
                                      arguments: CategoryArguement(
                                        category:
                                            events[index].category[0].name,
                                      ),
                                    );
                                  },
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
        }
      },
    );
  }
}
