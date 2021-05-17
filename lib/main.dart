import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
//import 'pages/home_page.dart';
import 'package:mup_app/login.dart';
import 'package:mup_app/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FirebaseInitializer());
}

class FirebaseInitializer extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Widget error = Text('...error initializing firebase...');
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
          }

          if (snapshot.connectionState == ConnectionState.done) {
            // Upon successful resolution of the future, launch the app main page
            return MyApp();
          }

          return CircularProgressIndicator(
            backgroundColor: Colors.blue[50],
          );
        });
  }
}
