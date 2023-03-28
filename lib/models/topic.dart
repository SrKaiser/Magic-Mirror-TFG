import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Topic {
  String id;
  String title;
  String place;
  String date;
  String time;

  String placeCreated;
  String dateCreated;
  String timeCreated;

  double stressLevel;
  String colorAssociated;
  String body;

  Topic({
    this.id,
    this.title,
    this.place,
    this.date,
    this.time,
    this.placeCreated,
    this.timeCreated,
    this.dateCreated,
    this.stressLevel,
    this.colorAssociated,
    this.body,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'place': place,
        'date': date,
        'time': time,
        'placeCreated': placeCreated,
        'timeCreated': timeCreated,
        'dateCreated': dateCreated,
        'stressLevel': stressLevel,
        'colorAssociated': colorAssociated,
        'body': body,
      };

  static Topic fromJson(Map<String, dynamic> json) => Topic(
        id: json['id'],
        title: json['title'],
        place: json['place'],
        date: json['date'],
        time: json['time'],
        placeCreated: json['placeCreated'],
        timeCreated: json['timeCreated'],
        dateCreated: json['dateCreated'],
        stressLevel: json['stressLevel'],
        colorAssociated: json['colorAssociated'],
        body: json['body'],
      );

  void setStressLevel(double stressLevel) {
    stressLevel = stressLevel;
  }
}

class TopicsStorage {
  final String storageKey;
  String filter;

  TopicsStorage(this.storageKey);

  Future<List<Topic>> loadTopics() async {
    final preferences = await SharedPreferences.getInstance();
    final topicsJson = preferences.getStringList(storageKey) ?? [];
    final topics =
        topicsJson.map((json) => Topic.fromJson(jsonDecode(json))).toList();
    return topics;
  }

  Future<List<Topic>> loadTopicsByFilter(String filtro) async {
    final preferences = await SharedPreferences.getInstance();
    final topicsJson = preferences.getStringList(storageKey) ?? [];
    final topics =
        topicsJson.map((json) => Topic.fromJson(jsonDecode(json))).toList();
    switch (filtro) {
      case 'stress':
        topics.sort((a, b) => -1 * a.stressLevel.compareTo(b.stressLevel));

        break;
      case 'dateOccurrence':
        topics.sort((a, b) => -1 * _compararFechas(a.date, b.date));
        break;
      default:
        topics
            .sort((a, b) => -1 * _compararFechas(a.dateCreated, b.dateCreated));
        break;
    }
    return topics;
  }

  int _compararFechas(String d1, String d2) {
    DateFormat format = DateFormat('MM/dd/yyyy');
    DateTime date1 = format.parse(d1);
    DateTime date2 = format.parse(d2);
    if (date1.year != date2.year) {
      return date1.year.compareTo(date2.year);
    } else if (date1.month != date2.month) {
      return date1.month.compareTo(date2.month);
    } else {
      return date1.day.compareTo(date2.day);
    }
  }

  Future<void> saveTopic(Topic topic) async {
    final preferences = await SharedPreferences.getInstance();
    final topicsJson = preferences.getStringList(storageKey) ?? [];
    final topicJson = jsonEncode(topic.toJson());
    final topicKey = topic.id ?? Uuid().v4();
    topicsJson
        .removeWhere((json) => Topic.fromJson(jsonDecode(json)).id == topicKey);
    topicsJson.add(topicJson);
    await preferences.setStringList(storageKey, topicsJson);
  }

  Future<void> deleteTopic(Topic topic) async {
    final preferences = await SharedPreferences.getInstance();
    final topicsJson = preferences.getStringList(storageKey) ?? [];
    final topicJson = jsonEncode(topic.toJson());
    topicsJson.remove(topicJson);
    await preferences.setStringList(storageKey, topicsJson);
  }
}
