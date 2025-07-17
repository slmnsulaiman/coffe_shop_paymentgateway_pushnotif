// // // import 'dart:io';

// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:get_storage/get_storage.dart';
// // // import 'package:jwt_decoder/jwt_decoder.dart';
// // // import 'package:mobile/initial_binding.dart';
// // // import 'package:webview_flutter/webview_flutter.dart';
// // // import 'package:webview_flutter_android/webview_flutter_android.dart';

// // // import 'app/routes/app_pages.dart';

// // // void main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await GetStorage.init();

// // //   // Inisialisasi WebView untuk Android (jika perlu)
// // //   if (Platform.isAndroid) {
// // //     WebViewPlatform.instance = AndroidWebViewPlatform();
// // //   }

// // //   final box = GetStorage();
// // //   final token = box.read('token');

// // //   String initialRoute;
// // //   if (token != null && !JwtDecoder.isExpired(token)) {
// // //     initialRoute = Routes.HOME;
// // //   } else {
// // //     box.erase();
// // //     initialRoute = Routes.LOGIN;
// // //   }

// // //   runApp(
// // //     GetMaterialApp(
// // //       initialBinding: InitialBinding(),
// // //       debugShowCheckedModeBanner: false,
// // //       title: "Application",
// // //       initialRoute: initialRoute,
// // //       getPages: AppPages.routes,
// // //     ),
// // //   );
// // // }

// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:get_storage/get_storage.dart';
// // import 'package:jwt_decoder/jwt_decoder.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:mobile/initial_binding.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// // import 'package:webview_flutter_android/webview_flutter_android.dart';
// // import 'app/routes/app_pages.dart';

// // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   await Firebase.initializeApp();
// //   print('🔔 [Background] Message: ${message.notification?.title}');
// // }

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(); // ✅ Inisialisasi Firebase
// //   await GetStorage.init();

// //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// //   if (Platform.isAndroid) {
// //     WebViewPlatform.instance = AndroidWebViewPlatform();
// //   }

// //   final box = GetStorage();
// //   final token = box.read('token');

// //   String initialRoute;
// //   if (token != null && !JwtDecoder.isExpired(token)) {
// //     initialRoute = Routes.HOME;
// //   } else {
// //     box.erase();
// //     initialRoute = Routes.LOGIN;
// //   }

// //   runApp(
// //     GetMaterialApp(
// //       initialBinding: InitialBinding(),
// //       debugShowCheckedModeBanner: false,
// //       title: "Application",
// //       initialRoute: initialRoute,
// //       getPages: AppPages.routes,
// //     ),
// //   );
// // }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:mobile/initial_binding.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'app/routes/app_pages.dart';

// // 🧠 Local Notification plugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // 🔔 Channel (for Android 8+)
// // const AndroidNotificationChannel channel = AndroidNotificationChannel(
// //   'high_importance_channel',
// //   'High Importance Notifications',
// //   importance: Importance.high,
// // );

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel',
//   'High Importance Notifications',
//   description: 'Channel untuk notifikasi penting',
//   importance: Importance.high,
//   playSound: true,
//   // sound: RawResourceAndroidNotificationSound('notifikasi_kasir'),
// );

// // 🔙 Handler untuk notifikasi saat app background
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('🔔 [Background] Message: ${message.notification?.title}');
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await GetStorage.init();

//   // Init WebView Android
//   if (Platform.isAndroid) {
//     WebViewPlatform.instance = AndroidWebViewPlatform();
//   }

//   // Init FCM background handler
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   // ✅ Init local notifications (Android)
//   const AndroidInitializationSettings androidSettings =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   const InitializationSettings initSettings = InitializationSettings(
//     android: androidSettings,
//   );

//   await flutterLocalNotificationsPlugin.initialize(initSettings);

//   // ✅ Create channel (Android 8+)
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin
//       >()
//       ?.createNotificationChannel(channel);

//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     final String soundName = message.data['sound'] ?? 'default';

//     print("🔔 Notif diterima: ${notification?.title}");
//     print("📄 Body: ${notification?.body}");
//     print("🔊 Sound yang akan diputar: $soundName");

//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel',
//             'High Importance Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//             showWhen: true,
//             playSound: true,
//             sound: soundName != 'default'
//                 ? RawResourceAndroidNotificationSound(soundName)
//                 : null, // ✅ biarkan null agar pakai default system sound
//           ),
//         ),
//       );
//     }
//   });

//   // 🔐 Routing logic
//   final box = GetStorage();
//   final token = box.read('token');

//   String initialRoute;
//   if (token != null && !JwtDecoder.isExpired(token)) {
//     initialRoute = Routes.HOME;
//   } else {
//     box.erase();
//     initialRoute = Routes.LOGIN;
//   }

//   runApp(
//     GetMaterialApp(

//       initialBinding: InitialBinding(),
//       debugShowCheckedModeBanner: false,
//       title: "Application",
//       initialRoute: initialRoute,
//       getPages: AppPages.routes,
//     ),
//   );
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/initial_binding.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:mobile/app/routes/app_pages.dart';

// ✨ Tambahkan ini
import 'package:flutter_screenutil/flutter_screenutil.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'Channel untuk notifikasi penting',
  importance: Importance.high,
  playSound: true,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 [Background] Message: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    final String soundName = message.data['sound'] ?? 'default';

    print("🔔 Notif diterima: ${notification?.title}");
    print("📄 Body: ${notification?.body}");
    print("🔊 Sound yang akan diputar: $soundName");

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            playSound: true,
            sound: soundName != 'default'
                ? RawResourceAndroidNotificationSound(soundName)
                : null,
          ),
        ),
      );
    }
  });

  final box = GetStorage();
  final token = box.read('token');

  String initialRoute;
  if (token != null && !JwtDecoder.isExpired(token)) {
    initialRoute = Routes.HOME;
  } else {
    box.erase();
    initialRoute = Routes.LOGIN;
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        360,
        690,
      ), // Gunakan ukuran desain (misalnya iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: InitialBinding(),
          debugShowCheckedModeBanner: false,
          title: "Application",
          initialRoute: initialRoute,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
