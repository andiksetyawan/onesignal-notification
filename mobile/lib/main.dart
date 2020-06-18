import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Signal Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'One Signal Notification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _setExternalId() {
    
    String _exID = "1234s11";
    OneSignal.shared.setExternalUserId(_exID).then((results) {
      if (results == null) return;
    });
    // OneSignal.shared.
  }

  @override
  void initState() {
    // TODO: implement initState
    _init();
    _initLocalNotif();
    super.initState();
  }

  void _init() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.init("424b6483-18f2-4010-b01a-d0ff0df91b5d", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      // will be called whenever a notification is received
      print("on receive");
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.
      print("on tap");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // will be called whenever the subscription changes
      //(ie. user gets registered with OneSignal and gets a user ID)
    });

    // OneSignal.shared.setEmailSubscriptionObserver(
    //     (OSEmailSubscriptionStateChanges emailChanges) {
    //   // will be called whenever then user's email subscription changes
    //   // (ie. OneSignal.setEmail(email) is called and the user gets registered
    // });


    void _handleNotificationReceived(OSNotification notification) {
      _showLocalNotification(title: notification.payload.title, body: notification.payload.body, payload: "");
    }

    OneSignal.shared
        .setNotificationReceivedHandler(_handleNotificationReceived);
  }

  void _initLocalNotif() async {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@drawable/ic_stat_onesignal_default');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {}

  _showLocalNotification(
      {String title = "", String body = "", payload = ""}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'dev.andiksetyawan.onesignal',
      'Notifikasi Umum',
      'Push notifikasi lokal',
      importance: Importance.Max,
      priority: Priority.High,
      icon: '@drawable/ic_stat_onesignal_default', //launcher_icon
      //color: Theme.of(context).primaryColor
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'one signal notification with local notification',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setExternalId,
        tooltip: 'Subscribe by External ID',
        child: Icon(Icons.add),
      ), 
    );
  }
}
