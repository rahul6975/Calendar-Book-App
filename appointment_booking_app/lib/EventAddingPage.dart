import 'package:appointment_booking_app/Event.dart';
import 'package:appointment_booking_app/Utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              SizedBox(
                height: 12,
              ),
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
  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent, shadowColor: Colors.transparent),
            onPressed: () {},
            icon: Icon(Icons.done),
            label: Text("Save")),
      ];

  Widget _buildTitle() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: "Add appointment title"),
        onFieldSubmitted: (_) {},
        controller: titleController,
        validator: (title) =>
            title != null && title.isEmpty ? "title cannot be empty" : null,
      );

  Widget buildDateTime() => Column(
        children: [
          buildFrom(),
        ],
      );

  Widget buildDateTimePicker() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: "From",
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: Utils.toDate(fromDate),
                onClicked: () {
                  pickFromDateTime(pickDate: true);
                },
              ),
            ),
            Expanded(
              child: buildDropdownField(
                  text: Utils.toTime(fromDate),
                  onClicked: () {
                    pickFromDateTime(pickDate: false);
                  }),
            )
          ],
        ),
      );

  Widget buildTo() => buildHeader(
        header: "To",
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: Utils.toDate(toDate),
                onClicked: () {},
              ),
            ),
            Expanded(
              child: buildDropdownField(
                  text: Utils.toTime(toDate), onClicked: () {}),
            )
          ],
        ),
      );

  static String toData(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return '$time';
  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({required String header, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          child,
        ],
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;
    setState(() {
      fromDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2021, 8),
        lastDate: DateTime(2101),
      );

      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }
}
