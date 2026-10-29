import 'dart:convert';
import 'package:flutter/services.dart';

class CvData {
  CvData(this.json);
  final Map<String, dynamic> json;
  String text(String key) => json[key] as String;
  List<Map<String, dynamic>> entries(String key) =>
      (json[key] as List).cast<Map<String, dynamic>>();
  static Future<CvData> load() async => CvData(
    jsonDecode(await rootBundle.loadString('assets/cv/profile.json'))
        as Map<String, dynamic>,
  );
}
