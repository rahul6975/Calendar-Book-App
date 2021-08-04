import 'dart:html';

import 'package:flutter/material.dart';

class EventAddingPage extends StatefulWidget {
  final Event? event;

  const EventAddingPage({Key? key, this.event}) : super(key: key);

  @override
  _EventAddingPageState createState() => _EventAddingPageState();
}

class _EventAddingPageState extends State<EventAddingPage> {
  final _formKey =
  GlobalKey<FormState>(); // for getting atleast title for the appointment
  late DateTime fromDate;
  late DateTime toDate;
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTitle(),
              SizedBox(height: 12,)
              buildDateTime(),
            ],
          ),
        ),
      ),
    );
  }

/*
Save button
 */
  List<Widget> buildEditingActions() =>
      [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent, shadowColor: Colors.transparent),
            onPressed: () {},
            icon: Icon(Icons.done),
            label: Text("Save")),
      ];

  Widget _buildTitle() =>
      TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: "Add appointment title"),
        onFieldSubmitted: (_) {},
        controller: titleController,
        validator: (title) =>
        title != null && title.isEmpty ? "title cannot be empty" : null,
      );

 Widget buildDateTime() =>Column(
   children: [
     buildFrom(),
   ],
 )
}
