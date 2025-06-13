import 'package:calendar_app/func.dart';
import 'package:calendar_app/widgets/event.dart';
import 'package:calendar_app/widgets/eventlist.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with Func {
  DateTime DayFocused = DateTime.now();
  bool search = false;
  final TextEditingController searchController = TextEditingController();
  bool viewAll = false;
  bool filter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title:
            (search)
                ? TextField(
                  controller: searchController,

                  cursorColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      viewAll = false;
                      filter = true;
                    });
                  },
                  style: TextStyle(color: Colors.white),

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: 'Search Here..',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                )
                : Text(
                  'CALENDER APP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

        actions: [
          (search)
              ? IconButton(
                onPressed: () {
                  setState(() {
                    search = false;
                  });
                },
                icon: Icon(Icons.cancel),
                color: Colors.white,
              )
              : IconButton(
                onPressed: () {
                  setState(() {
                    search = true;
                    viewAll = true;
                  });
                },
                icon: Icon(Icons.search, color: Colors.white),
              ),
        ],
      ),
      body: Container(
        color: Colors.deepPurple.shade50,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: !search,
                child: TableCalendar(
                  focusedDay: DayFocused,
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  currentDay: DayFocused,
                  onDaySelected:
                      (selectedDay, focusedDay) => setState(() {
                        DayFocused = selectedDay;
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Visibility(
                    visible: !search,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                      ),

                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          EventDetails.routeName,
                          arguments: EventArguements(
                            DayFocused: DateTime.utc(
                              DayFocused.year,
                              DayFocused.month,
                              DayFocused.day,
                            ),
                            view: false,
                            event: null, // Add the required event argument here
                          ),
                        );
                      },
                      label: Text('Add Event'),
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ),
              EventList(
                filter: filter,
                searchTerm: searchController.text,
                all: viewAll,

                date: DateTime.utc(
                  DayFocused.year,
                  DayFocused.month,
                  DayFocused.day,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
