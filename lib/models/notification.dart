import 'dart:convert';

class NotificationModel {
  late String title;
  late String details;
  String? imageUrl;

  NotificationModel(
    this.title,
    this.details, {
    this.imageUrl,
  });

  factory NotificationModel.fromJsonString(String str) =>
      NotificationModel._fromJson(jsonDecode(str));

  String toJsonString() => jsonEncode(_toJson());

  factory NotificationModel._fromJson(Map<String, dynamic> json) =>
      NotificationModel(json['title'], json['details'],
          imageUrl: json['imageUrl']);

  Map<String, dynamic> _toJson() =>
      {'title': title, 'details': details, 'imageUrl': imageUrl};
}
