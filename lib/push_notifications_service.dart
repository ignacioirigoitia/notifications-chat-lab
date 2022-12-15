

//SHA1 para la configuracion que solicita Firebase
//SHA1: 61:7E:89:54:79:70:1F:02:7A:86:B2:8E:B8:E5:D7:D6:10:8A:E6:34

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//import 'package:flutter_push_notifications_rmm2/screens/message_screen.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream = new StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    // ignore: avoid_print
    //print('Backgroud Handler ${message.messageId}');
    //_messageStream.add(message.notification?.body ?? 'No title');
    _messageStream.add(message.data['producto'] ?? 'Vacio1');
    // ignore: avoid_print
    print('Esta es la data: ${message.data}');
  }

  static Future<void> _onMessageHandler(RemoteMessage message) async {
    // ignore: avoid_print
    //print('on Message Handler ${message.messageId}');
    // ignore: avoid_print
    print('Esta es la data: ${message.data.toString()}');
    // ignore: avoid_print
    print('Esta es la body: ${message.notification!.body.toString()}');
    // ignore: avoid_print
    print('Esta es la title: ${message.notification!.title.toString()}');
    //_messageStream.add(message.notification?.body ?? 'No title');
    _messageStream
        .add('Esta es la body: ${message.notification!.body.toString()}');
    //_messageStream.add(message.data['producto'] ?? 'Vacio2');
  }

  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    // ignore: avoid_print
    //print('onMessageOpenApp Handler ${message.messageId}');
    //_messageStream.add(message.notification?.body ?? 'No title');
    _messageStream.add(message.data['producto'] ?? 'Vacio3');

    // ignore: avoid_print
    print('Esta es la data: ${message.data}');
  }

  static Future<String?> inicitializeApp() async {
    //push Notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    // ignore: avoid_print
    print('este es mi token: $token');
    

//handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    return token;
//local Notifications
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    print('User push notification status ${ settings.authorizationStatus }');

  }

  static closeStreams() {
    _messageStream.close();
  }
}
