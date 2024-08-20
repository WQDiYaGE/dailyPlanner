import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import '../models/task.dart';

class LocalNotifyManager {
  late FlutterLocalNotificationsPlugin flnPlugin;
  // ignore: prefer_typing_uninitialized_variables
  var initSetting;

  BehaviorSubject<ReceieveNotification> get didRecieve =>
      BehaviorSubject<ReceieveNotification>();

  LocalNotifyManager.init() {
    flnPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIosPermission();
    }
    initilizePlatform();
  }

  requestIosPermission() {
    flnPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  initilizePlatform() {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('notificationicon');

    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: (id, title, body, payload) async {
              ReceieveNotification notif =
                  ReceieveNotification(id, title, body, payload);
              didRecieve.add(notif);
            });

    initSetting = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  setOnNotificationRecieve(Function onNotificationRecieve) {
    didRecieve.listen((notification) {
      onNotificationRecieve(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flnPlugin.initialize(initSetting,
        onSelectNotification: (String? payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    var androidChannel = const AndroidNotificationDetails(
        'CHANNEL_ID 1', 'CHANNEL_NAME 1',
        importance: Importance.high, priority: Priority.high, playSound: false);
    var iosChannel = const IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flnPlugin.show(0, "title", "body", platformChannel,
        payload: 'Shruthi payload');
  }

  Future<void> showScheduledNotification(
      int id, Task task, DateTime atTime) async {
    var androidChannel = const AndroidNotificationDetails(
        'CHANNEL_ID 1', 'CHANNEL_SCHEDULED_DATE',
        importance: Importance.max, priority: Priority.high, playSound: false);
    var iosChannel = const IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    // ignore: deprecated_member_use
    await flnPlugin.schedule(
        id, "Task Reminder", task.title, atTime, platformChannel,
        payload: "${task.title}|${task.note}");
  }

  Future<void> showDailyAtTimeNotification(
      int id, Task task, TimeOfDay atTime) async {
    var time = Time(atTime.hour, atTime.minute, 0);
    DateTime.now().add(const Duration(seconds: 20));
    var androidChannel = const AndroidNotificationDetails(
        'CHANNEL_ID 2', 'CHANNEL_DAILY',
        importance: Importance.max, priority: Priority.high, playSound: false);
    var iosChannel = const IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    // ignore: deprecated_member_use
    await flnPlugin.showDailyAtTime(
        id, "Task Reminder", task.title, time, platformChannel,
        payload: "${task.title}|${task.note}");
  }

  Future<void> showWeeklyAtDayTimeNotification(
      int id, Task task, TimeOfDay atTime) async {
    var time = Time(atTime.hour, atTime.minute, 0);
    DateTime.now().add(const Duration(seconds: 20));
    var androidChannel = const AndroidNotificationDetails(
        'CHANNEL_ID 3', 'CHANNEL_WEEKLY',
        importance: Importance.max, priority: Priority.high, playSound: false);
    var iosChannel = const IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    if (task.repeat == "Weekend") {
      // ignore: deprecated_member_use
      await flnPlugin.showWeeklyAtDayAndTime(id * 101, "Task Reminder",
          task.title, Day.saturday, time, platformChannel,
          payload: "${task.title}|${task.note}");
      // ignore: deprecated_member_use
      await flnPlugin.showWeeklyAtDayAndTime(id * 102, "Task Reminder",
          task.title, Day.sunday, time, platformChannel,
          payload: "${task.title}|${task.note}");
    } else {
      if (kDebugMode) {
        print(".........${id * 13}");
      }
      // ignore: deprecated_member_use
      await flnPlugin.showWeeklyAtDayAndTime(id * 103, "Task Reminder",
          task.title, Day.monday, time, platformChannel,
          payload: "${task.title}|${task.note}");
      // ignore: deprecated_member_use
      await flnPlugin.showWeeklyAtDayAndTime(id * 104, "Task Reminder",
          task.title, Day.tuesday, time, platformChannel,
          payload: "${task.title}|${task.note}");
      // ignore: deprecated_member_use
      await flnPlugin.showWeeklyAtDayAndTime(id * 105, "Task Reminder",
          task.title, Day.wednesday, time, platformChannel,
          payload: "${task.title}|${task.note}");
      // ignore: deprecated_member_use
      await flnPlugin.showWeeklyAtDayAndTime(id * 106, "Task Reminder",
          task.title, Day.thursday, time, platformChannel,
          payload: "${task.title}|${task.note}");
      // ignore: deprecated_member_use
      await flnPlugin.showWeeklyAtDayAndTime(id * 107, "Task Reminder",
          task.title, Day.friday, time, platformChannel,
          payload: "${task.title}|${task.note}");
    }
  }

  Future<void> cancelNotification(int id) async {
    await flnPlugin.cancel(id);
  }

  Future<void> cancelAllNotification() async {
    await flnPlugin.cancelAll();
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceieveNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceieveNotification(this.id, this.title, this.body, this.payload);
}
