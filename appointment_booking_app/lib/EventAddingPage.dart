import 'package:appointment_booking_app/Event.dart';
import 'package:appointment_booking_app/EventProvider.dart';
import 'package:appointment_booking_app/Utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /*
  save data from shared preference
   */

  Future<void> saveData(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("name", event.name);
    prefs.setString("mobile", event.mobile);
    prefs.setString("email", event.email);
    prefs.setString("from", event.from.toString());
    prefs.setString("to", event.to.toString());
    prefs.setString("comment", event.comment);
  }

  Future<Event> getDataFromDB() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString("name");
    final email = prefs.getString("email");
    final from = prefs.getString("from");
    final to = prefs.getString("to");
    final mobile = prefs.getString("mobile");
    final comment = prefs.getString("comment");
    return Event(
        name: name!,
        email: email!,
        mobile: mobile!,
        comment: comment!,
        from: DateTime.parse(from!),
        to: DateTime.parse(to!));
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
            /*
              check if mobile and email are valid or  not
              if not then show a snakeBar
               */
            if (validEmail && number.length == 10) {
              saveFrom();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Invalid inputs"),
              ));
            }
          },
          icon: Icon(Icons.done),
          label: Text("Save"),
        ),
      ];

  /*
  builds the name TextField
   */
  Widget _buildTitle() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: "enter name"),
        onFieldSubmitted: (_) {},
        controller: nameController,
        validator: (name) =>
            name != null && name.isEmpty ? "name cannot be empty" : null,
      );

  /*
  builds the email TextField
   */
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

  /*
  builds the mobile TextField
   */
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

  /*
  builds the comment TextField
   */
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

  /*
  builds the fromDate Column
   */
  Widget buildDateTime() => Column(
        children: [
          buildFrom(),
        ],
      );

  /*
  builds the datePicker Column
   */
  Widget buildDateTimePicker() => Column(
        children: [
          Container(margin: EdgeInsets.only(top: 30), child: buildFrom()),
          // buildTo(),
        ],
      );

  /*
  builds the fromDate header
   */
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

  /*
  builds the toDate header
   */
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
                  // pickToDateTime(pickDate: false);
                },
              ),
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
          to: DateTime(fromDate.year, fromDate.month, fromDate.day,
              fromDate.hour + 1, fromDate.minute));

      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addAppointment(event);
      saveData(event);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Appointment booked successfully"),
          backgroundColor: Colors.green,
        ),
      );
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
    if (date.weekday == DateTime.tuesday ||
        date.weekday == DateTime.wednesday) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tuesday and Wednesday are holidays"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
    if (date.day < DateTime.now().day) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You cannot book appointment for previous days"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
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
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;

      if (timeOfDay.hour < 9 ||
          (timeOfDay.hour >= 16 && timeOfDay.minute > 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Working Hours are from 9am to 5pm"),
            backgroundColor: Colors.red,
          ),
        );
        // showErrorSnackBar(context);

        return null;
      }
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      if (timeOfDay.hour <= DateTime.now().hour && timeOfDay.minute <= DateTime.now().minute && date.day <= DateTime.now().day) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You cannot but appointment for already passed time"),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
      return date.add(time);
    }
  }

  void showErrorSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Working Hours are from 9am to 5pm',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.fixed,
    );

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
