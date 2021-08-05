import 'dart:ui';

import 'package:flutter/material.dart';

class Event {
  final String name;
  final String email;
  final DateTime from;
  final DateTime to;
  final String mobile;
  final String comment;
  final Color backgroundColor;

  const Event({
    required this.name,
    required this.email,
    required this.mobile,
    required this.comment,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.green,
  });
}
