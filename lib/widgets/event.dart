import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:calendar_app/func.dart';
import 'package:calendar_app/hive_objects/category.dart';
import 'package:calendar_app/hive_objects/event.dart';
import 'package:calendar_app/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  static const routeName = 'event';

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

Category? dropdownValue;

class _EventDetailsState extends State<EventDetails> with Func {
  final _formKey = GlobalKey<FormState>();
  Category? dropdownValue;
  final TextEditingController controller = TextEditingController();
  final TextEditingController eventController = TextEditingController();
  final TextEditingController eventdescriptionController =
      TextEditingController();
  Uint8List? imageBytes;
  bool completed = false;
  bool viewed = false;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EventArguements;
    if (args.view && !viewed) {
      setState(() {
        dropdownValue = args.event?.category[0];
        eventController.text = args.event!.eventName;
        eventdescriptionController.text = args.event!.eventDescription;
        imageBytes = args.event!.file;
        completed = args.event!.completed;
        viewed = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          "Event",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed:
                (args.view)
                    ? () {
                      updateExistingEvent(args, context);
                    }
                    : null,
            icon: Icon(Icons.update),
          ),
          IconButton(
            onPressed:
                (args.view)
                    ? () {
                      deleteMethod(context, args);
                    }
                    : null,
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SELECT CATEGORY',
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ValueListenableBuilder<Box<Category>>(
                        valueListenable: categoryBox.listenable(),
                        builder: (context, box, Widget) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF4A00E0), // Equivalent to #4A00E0
                                  Color(0xFF8E2DE2), // Equivalent to #8E2DE2
                                ],
                              ),
                              color: Colors.deepPurpleAccent.shade200,

                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: DropdownButton(
                              hint: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'SELECT CATEGORY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              focusColor: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(5),
                              dropdownColor: Colors.deepPurpleAccent.shade400,

                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),

                              isExpanded: true,
                              value: dropdownValue,
                              items:
                                  box.values
                                      .map(
                                        (category) => DropdownMenuItem(
                                          value: category,
                                          child: Text(
                                            category.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (Category? newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: CircleBorder(),
                          elevation: 10,
                        ),
                        onPressed: () {
                          createNewCategory(context);
                        },
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.deepPurpleAccent,
                    ),
                    Text(
                      DateFormat("EEEE d MMMM").format(args.DayFocused),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.deepPurple),
                  controller: eventController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.arrow_right),
                    suffixIcon: Icon(Icons.event),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text("ENTER EVENT NAME"),
                    filled: true,
                    fillColor: Colors.grey.shade100,

                    labelStyle: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: eventdescriptionController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.arrow_right),
                    suffixIcon: Icon(Icons.notes_sharp),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text("ENTER EVENT DESCRIPTION"),
                    labelStyle: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  tileColor: Colors.deepPurpleAccent,
                  title: Text(
                    'UPLOAD FILE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing:
                      (imageBytes != null)
                          ? Icon(Icons.done, color: Colors.white)
                          : Icon(Icons.upload, color: Colors.white),
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      File file = File(result.files.single.path!);
                      imageBytes = await file.readAsBytes();
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'IMAGE NOT SELECTED',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              (imageBytes != null)
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(imageBytes!, width: 200),
                  )
                  : const SizedBox.shrink(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwitchListTile(
                  title: Text(
                    "Event Completed ?",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  value: completed,
                  onChanged: (bool? value) {
                    setState(() {
                      completed = value!;
                    });
                  },
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed:
                        (args.view)
                            ? null
                            : () async {
                              if (_formKey.currentState?.validate() == true &&
                                  dropdownValue != null) {
                                await addEvent(
                                  Event(
                                    HiveList(categoryBox),
                                    args.DayFocused,
                                    eventController.text,
                                    eventdescriptionController.text,
                                    imageBytes,
                                    completed,
                                  ),
                                  dropdownValue!,
                                );

                                if (context.mounted) {
                                  StatusAlert.show(
                                    context,
                                    duration: Duration(seconds: 2),
                                    title: 'CALENDER APP',
                                    subtitle: 'EVENT ADDED',
                                    configuration: IconConfiguration(
                                      icon: Icons.done,
                                    ),
                                    maxWidth: 260,
                                  );
                                  Navigator.pop(context);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Enter All Required Fields'),
                                    backgroundColor: Colors.redAccent,
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent,
                      //shape: const RoundedRectangleBorder(),
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.8,
                        50,
                      ),
                    ),

                    child: Text('ADD EVENT'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createNewCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Create New Category',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Category Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },

              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  addCategory(Category(controller.text));
                }
                Navigator.of(context).pop();
                controller.clear();
              },
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  updateExistingEvent(EventArguements args, BuildContext context) {
    args.event?.category = HiveList((categoryBox));
    args.event?.date = args.DayFocused;
    args.event?.eventName = eventController.text;
    args.event?.eventDescription = eventdescriptionController.text;
    args.event?.completed = completed;
    updateEvent(args.event!, dropdownValue!);
    if (context.mounted) {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: 'CALENDER APP',
        subtitle: 'EVENT UPDATED',
        configuration: IconConfiguration(icon: Icons.done),
        maxWidth: 260,
      );
    }
    Navigator.pop(context);
  }

  deleteMethod(BuildContext context, EventArguements args) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'CALENDER APP',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Text(
            'DO YOU WANT TO DELETE THIS EVENT ?',
            style: TextStyle(fontSize: 12),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                deleteEvent(args.event!);
                if (context.mounted) {
                  StatusAlert.show(
                    context,
                    title: 'CALENDER APP',

                    subtitle: 'EVENT DELETED',
                    configuration: IconConfiguration(icon: Icons.done),
                    maxWidth: 300,
                    duration: Duration(seconds: 2),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('YES'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurpleAccent,
              ),
              child: Text('NO'),
            ),
          ],
        );
      },
    );
  }
}

class EventArguements {
  final DateTime DayFocused;
  final Event? event;
  final bool view;
  EventArguements({
    required this.DayFocused,
    required this.view,
    required this.event,
  });
}
