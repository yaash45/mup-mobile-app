// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mup_app/pages/home_page.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:mup_app/models/Device.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mup_app/backend/Octave.dart';
import 'package:mup_app/backend/mup_firebase.dart';
import 'package:mup_app/models/Device.dart';
import 'package:mup_app/templates/appbar.dart';
import 'package:mup_app/pages/login.dart';
import 'package:mup_app/pages/frequency_profile.dart';
import 'package:mup_app/pages/my_account.dart';
import 'package:mup_app/pages/add_new_device.dart';
import 'package:mup_app/pages/sensor_profile.dart';
import 'package:mup_app/pages/device_info.dart';
import 'package:mup_app/templates/colors.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:mup_app/states/CurrentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
//class MockNavigatorObserver extends Mock implements NavigatorObserver {}


void main() {
  /*
  testWidgets('Verify Login widgets', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  }); */

  testWidgets('Verify Sign in process', (WidgetTester tester) async {
    // Build our app and trigger a frame.
  //  await tester.pumpWidget(MyApp()
  //  );
  await tester.pumpWidget(MaterialApp(home:Login()));
  
 // expect(find.text("Device Info"), findsNothing);
              
   
   await tester.enterText(find.byKey(ValueKey("Email")), "email@gmail.com");
   await tester.enterText(find.byKey(ValueKey("Password")), "password");
    
    await tester.tap(find.widgetWithText(TextButton, "Login"));
    //await tester.pumpWidget(MaterialApp(home:MyHomePage())); 
    await tester.pump();
 
    //print(tester);
    expect(find.byType(FFNavigationBarItem), findsWidgets);
    //expect(find.widgetWithText(Scaffold, "Devices"), findsOneWidget);
    //expect(find.widgetWithText(FFNavigationBarItem,"My Account"), findsOneWidget);
  });















}
