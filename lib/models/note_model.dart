import 'dart:convert';

import 'package:flutter/material.dart';

class Note {
  int? id;
  String title;
  String content;
  Color color;
  DateTime date;
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color.value,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      color: Color(int.parse(map['color'])),
      date: DateTime.fromMillisecondsSinceEpoch(int.parse(map['date'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, color: $color, date: $date)';
  }

  Note copy({
    int? id,
    String? title,
    String? content,
    Color? color,
    DateTime? date,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      date: date ?? this.date,
    );
  }
}
