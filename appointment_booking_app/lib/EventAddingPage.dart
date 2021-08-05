import 'package:appointment_booking_app/Event.dart';
import 'package:appointment_booking_app/EventProvider.dart';
import 'package:appointment_booking_app/Utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventAddingPage extends StatefulWidget {
  final Event? event;

  const EventAddingPage({Key? key, this.event}) : super(key: key);

  @override
  _EventAddingPageState createState() => _EventAddingPageState();
}

class _EventAddingPageState extends State<EventAddingPage> {
  final _formKey =
      GlobalKey<FormState>(); // for getting at-least name for the appointment
  late DateTime fromDate;
  late DateTime toDate;
  bool validEmail = false;
  var number = "";
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final commentController = TextEditingController();

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
              _buildEmail(),
              _buildMobile(),
              _buildComment(),
              SizedBox(
                height: 12,
              ),
              buildDateTimePicker(),
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
            onPressed: () {
              if (validEmail && number.length == 10) {
                saveFrom();
              }
            },
            icon: Icon(Icons.done),
            label: Text("Save")),
      ];

  Widget _buildTitle() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: "enter name"),
        onFieldSubmitted: (_) {},
        controller: nameController,
        validator: (name) =>
            name != null && name.isEmpty ? "name cannot be empty" : null,
      );

  Widget _buildEmail() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: "enter email"),
        onFieldSubmitted: (_) {},
        onChanged: (value) {
          validEmail = EmailValidator.validate(value);
        },
        controller: emailController,
        validator: (email) => email != null && email.isEmpty && validEmail
            ? "email cannot be empty"
            : null,
      );

  Widget _buildMobile() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: "enter mobile number"),
        onFieldSubmitted: (_) {},
        onChanged: (value) {
          number = value.toString();
        },
        controller: mobileController,
        validator: (mobile) =>
            mobile != null && mobile.isEmpty && number.length == 10
                ? "number cannot be empty"
                : null,
      );

  Widget _buildComment() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: "enter some comments"),
        onFieldSubmitted: (_) {},
        controller: commentController,
        validator: (comment) => comment != null && comment.isEmpty
            ? "comments cannot be empty"
            : null,
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
                onClicked: () {
                  pickToDateTime(pickDate: true);
                },
              ),
            ),
            Expanded(
              child: buildDropdownField(
                  text: Utils.toTime(toDate),
                  onClicked: () {
                    pickToDateTime(pickDate: false);
                  }),
            ),
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

  Future saveFrom() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Event(
          name: nameController.text,
          email: emailController.text,
          mobile: mobileController.text,
          comment: commentController.text,
          from: fromDate,
          to: toDate);

      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addAppointment(event);
      Navigator.of(context).pop();
    }
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return;
    setState(() {
      toDate = date;
    });
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate = DateTime(date.year, date.month, date.day);
    }
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
