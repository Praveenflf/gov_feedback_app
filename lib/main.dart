import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifiers/feedback_notifier.dart';
import 'notifiers/complaint_notifier.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        home: HomeScreen(),
      ),
    );
  }
}
