import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elder_link/appointment/appointment_details_page.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../medicine/medicine_details_page.dart';

class NotificationController {

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final Map<String, String?> payload = receivedAction.payload ?? {};
    final String medicineName = payload['medicineName'] ?? '';
    final String dosage = payload['dosage'] ?? '';
    final String appointmentName = payload['appointmentName'] ?? '';
    final String location = payload['location'] ?? '';

    if (payload['navigate'] == 'medicine') {

      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => MedicineDetailsPage(
              medicineName: medicineName,
              dosage: dosage,
          ),
        ),
      );
    }

    if (payload['navigate'] == 'appointment') {

      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => AppointmentDetailsPage(
            appointmentName: appointmentName,
            location: location,
          ),
        ),
      );
    }

  }
}

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'basic_channel',
              channelName: 'ElderLink Notifications',
              channelDescription: 'Notification channel for ElderLink',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white,
              importance: NotificationImportance.Max,
              channelShowBadge: true,
              onlyAlertOnce: true,
              playSound: true,
              criticalAlerts: true,
              locked: true,
          )
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true
    );

    AwesomeNotifications().setListeners(onActionReceivedMethod: NotificationController.onActionReceivedMethod);
  }

  static Future<void> showMedicineNotification({
      required final int id,
      required final String title,
      required final String body,
      final String? summary,
      final Map<String, String>? payload,
      final ActionType actionType = ActionType.Default,
      final NotificationLayout notificationLayout = NotificationLayout.Default,
      final NotificationCategory? category,
      final String? bigPicture,
      final List<NotificationActionButton>? actionButtons,
      final bool scheduled = false,
      required DateTime scheduleDate,
  }) async{
    final correctedScheduleDate= DateTime(
      scheduleDate.year,
      scheduleDate.month,
      scheduleDate.day,
      scheduleDate.hour,
      scheduleDate.minute,
      0,
    );

    if(correctedScheduleDate.difference(DateTime.now()).inDays == 0){
      correctedScheduleDate.add(const Duration(days: 1));
    }

    //await AwesomeNotifications().cancel(id);
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'basic_channel',
            title: title,
            body: body,
            actionType: actionType,
            notificationLayout: notificationLayout,
            summary: summary,
            category: category,
            payload: payload,
            bigPicture: bigPicture,
            locked: true,
            displayOnBackground: true,
            criticalAlert: true,
            showWhen: true,
            wakeUpScreen: true,
        ),
        actionButtons: actionButtons,
        schedule: scheduled
             ? NotificationCalendar(
                  hour: correctedScheduleDate.hour,
                  minute: correctedScheduleDate.minute,
                  second: 0,
                  allowWhileIdle: true,
                  repeats: true,
                  preciseAlarm: true,
                )
             : null,
    );
  }

  static Future<void> showAppointmentNotification({
    required final int id,
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    required DateTime scheduleDate,
  }) async {
    DateTime scheduledDateTime = scheduleDate.subtract(const Duration(hours: 1));
    // print(correctedScheduleDate);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
        locked: true,
        displayOnBackground: true,
        criticalAlert: true,
        showWhen: true,
        wakeUpScreen: true,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationCalendar(
        year: scheduledDateTime.year,
        month: scheduledDateTime.month,
        day: scheduledDateTime.day,
        hour: scheduledDateTime.hour,
        minute: scheduledDateTime.minute,
        second: scheduledDateTime.second,
        allowWhileIdle: true,
        repeats: false,
        preciseAlarm: true,
      )
          : null,
    );
  }
}