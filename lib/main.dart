// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import './screens/auth_screen.dart';
// import './screens/chat_screen.dart';
// import './screens/splash_screen.dart';

// import 'package:firebase_core/firebase_core.dart';

// import 'screens/welcome_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final _auth = FirebaseAuth.instance;
//     final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//     return FutureBuilder(
//         // Initialize FlutterFire:
//         future: _initialization,
//         builder: (context, appSnapshot) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'Message Me',
//             theme: ThemeData(
//               primarySwatch: Colors.pink,
//               backgroundColor: Colors.pink,
//               accentColor: Colors.deepPurple,
//               accentColorBrightness: Brightness.dark,
//               buttonTheme: ButtonTheme.of(context).copyWith(
//                 buttonColor: Colors.pink,
//                 textTheme: ButtonTextTheme.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//             home: appSnapshot.connectionState != ConnectionState.done
//                 ? SplashScreen()
//                 : StreamBuilder(
//                     stream: FirebaseAuth.instance.authStateChanges(),
//                     builder: (ctx, userSnapshot) {
//                       if (userSnapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return SplashScreen();
//                       }
//                       if (userSnapshot.hasData) {
//                         return ChatScreen();
//                       }
//                       return WelcomeScreen();
//                     }),
//             routes: {
//               WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
//               ChatScreen.screenRoute: (context) => ChatScreen(),
//               AuthScreen.screenRoute: (context) => AuthScreen()
//             },
//           );
//         });
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './screens/auth_screen.dart';
import './screens/welcome_screen.dart';
import './screens/chat_screen.dart';
import './screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _auth = FirebaseAuth.instance;

  // @override
  // void initState() {
  //   CheckUserConnection();
  //   super.initState();
  // }

  // Future CheckUserConnection() async {
  //   //bool _isconnected = false;
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
  //   } on SocketException catch (_) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('No Internet Connection'),
  //         content: Text('Please check your internet and try again.'),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 Future.delayed(Duration(seconds: 2))
  //                     .then((value) => CheckUserConnection());
  //               },
  //               child: Text('OK'))
  //         ],
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.pink,
      ),
      home: _getHomePage(),
      routes: {
        WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
        ChatScreen.screenRoute: (context) => ChatScreen(),
        AuthScreen.screenRoute: (context) => AuthScreen()
      },
    );
  }

  StreamBuilder<Object?> _getHomePage() {
    return StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (userSnapshot.hasData) {
            return ChatScreen();
          } else {
            return WelcomeScreen();
          }
        });
  }
}
