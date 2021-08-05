import 'package:appointment_booking_app/Event.dart';
import 'package:flutter/cupertino.dart';

/*
Provider which stores the appointment details
 */
class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime value) => _selectedDate = value;

  List<Event> get appointmentsOfSelectedDate => _events;

  void addAppointment(Event event) {
    _events.add(event);
    notifyListeners();
  }
}
