// lib/service/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:vital_care/model/medicament_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialiser() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
  }

  // Planifie une notification 2 minutes avant l'heure du médicament
  Future<void> planifierNotification(Medicament medicament) async {
    // Heure de fin - 2 minutes
    final DateTime heureNotification = medicament.heure.subtract(
      const Duration(minutes: 2),
    );

    // Si l'heure est déjà passée, on ne planifie pas
    if (heureNotification.isBefore(DateTime.now())) return;

    final tz.TZDateTime heureNotificationTZ = tz.TZDateTime.from(
      heureNotification,
      tz.local,
    );

    await _plugin.zonedSchedule(
      medicament.id!, // ID unique par médicament
      '💊 Rappel médicament',
      '${medicament.nom} - ${medicament.dosage}mg dans 2 minutes !',
      heureNotificationTZ,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicament_channel',
          'Rappels médicaments',
          channelDescription: 'Notifications de rappel pour les médicaments',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Annule la notification d'un médicament
  Future<void> annulerNotification(int medicamentId) async {
    await _plugin.cancel(medicamentId);
  }

  // Annule toutes les notifications
  Future<void> annulerTout() async {
    await _plugin.cancelAll();
  }
}