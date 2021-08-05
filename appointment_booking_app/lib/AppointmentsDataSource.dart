import 'package:appointment_booking_app/Event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentsDataSource extends CalendarDataSource {
  AppointmentsDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  bool isAllDay(int index) => false;

  @override
  String getSubject(int index) => getEvent(index).comment;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;
}
