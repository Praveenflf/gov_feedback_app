import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifiers/feedback_notifier.dart';
import 'notifiers/complaint_notifier.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeedbackNotifier()),
        ChangeNotifierProvider(create: (_) => ComplaintNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Office feedback and people Support System',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
