import 'package:appointment_booking_app/Event.dart';
import 'package:flutter/material.dart';

class AppointmentDetails extends StatelessWidget {
  final Event event;

  const AppointmentDetails({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Details"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(30),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Name :",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    event.name,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(30),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "mobile :",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    event.mobile,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(30),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Email :",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    event.email,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(30),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "From :",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    event.from.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(30),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "To :",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    event.to.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(30),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Topic :",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    event.comment,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
