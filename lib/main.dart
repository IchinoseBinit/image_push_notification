import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationSettings? settings;

  getMessaging() async {
    settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  void initState() {
    super.initState();
    showNotificationsInApp();
    getMessaging();

    FirebaseMessaging.onMessage.listen((event) async {
      var pictureFile = await _downloadSaveFile(
          event.notification!.android!.imageUrl!, 'image.jpg');

      final picture = BigPictureStyleInformation(
        FilePathAndroidBitmap(pictureFile),
        contentTitle: event.notification!.title!,
        summaryText: event.notification!.body!,
        htmlFormatContent: true,
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your channel id', 'channel name',
              importance: Importance.max,
              priority: Priority.high,
              styleInformation: picture);
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        Random().nextInt(120000),
        event.notification!.title!,
        event.notification!.body!,
        // event.notification!
        platformChannelSpecifics,
        payload: 'item x',
      );
    });
  }

  _downloadSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';

    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  void showNotificationsInApp() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  selectNotification(payload) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text(
          'You have pushed the button this many times:',
        ),
      ),
    );
  }
}
