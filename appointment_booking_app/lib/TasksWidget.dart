import 'package:appointment_booking_app/AppointmentDetails.dart';
import 'package:appointment_booking_app/AppointmentsDataSource.dart';
import 'package:appointment_booking_app/Event.dart';
import 'package:appointment_booking_app/EventProvider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:provider/provider.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  /*
  get data from shared preference
   */
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
    final provider = Provider.of<EventProvider>(context);
    final selectedAppointment = provider.appointmentsOfSelectedDate;
    final event = getDataFromDB();
    if (selectedAppointment.isEmpty && event != null) {
      return Center(
        child: Text(
          "No Appointments found",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      );
    }

    return SfCalendarTheme(
      data: SfCalendarThemeData(),
      child: SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: AppointmentsDataSource(provider.events),
        initialDisplayDate: provider.selectedDate,
        appointmentBuilder: appointmentBuilder,
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: BoxDecoration(
          color: Colors.red.withOpacity(0.3),
        ),
        onTap: (details) {
          if (details.appointments == null) return;
          final event = details.appointments!.first;

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AppointmentDetails(event: event),
          ));
        },
      ),
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          event.comment,
          maxLines: 2,
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
