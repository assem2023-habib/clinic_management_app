import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
}

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _deviceToken;
  String? get deviceToken => _deviceToken;

  final _messageStream = ValueNotifier<RemoteMessage?>(null);
  ValueNotifier<RemoteMessage?> get messageStream => _messageStream;

  Future<void> initialize() async {
    await _requestPermission();
    await _initLocalNotifications();
    await _getToken();
    _setupForegroundHandler();
    _setupBackgroundHandler();
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _messageStream.value = RemoteMessage(
          senderId: '',
          messageId: '',
          data: Map<String, String>.from(data),
        );
      } catch (_) {}
    }
  }

  Future<void> _getToken() async {
    _deviceToken = await _messaging.getToken();
    debugPrint('FCM token: $_deviceToken');

    _messaging.onTokenRefresh.listen((newToken) {
      _deviceToken = newToken;
      debugPrint('FCM token refreshed: $newToken');
    });
  }

  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  void _setupBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _checkInitialMessage();
  }

  Future<void> _checkInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      _messageStream.value = message;
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _showLocalNotification(message);
    _messageStream.value = message;
  }

  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    _messageStream.value = message;
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      'clinic_channel',
      'إشْعَارَات العِيَادَة',
      channelDescription: 'إشْعَارَات حَجْز المَوَاعِيد وَتَذْكِيرَات العِلَاج',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title ?? 'إشْعَار جَدِيد',
      body: notification.body ?? '',
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: jsonEncode(message.data),
    );
  }

  Future<void> deleteToken() async {
    await _messaging.deleteToken();
    _deviceToken = null;
  }
}
