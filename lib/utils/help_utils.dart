import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/rating_screen.dart';
import '../screens/self_service_screen.dart';
import '../screens/complaint_screen.dart';

void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Need Help?'),
      content: Text(
        'This application helps you provide feedback, request services, and raise complaints.\n\n'
        'Use the navigation links at the top or buttons below to get started.',
      ),
      actions: [
        TextButton(
          child: Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

/// A utility class for help-related functionality Shows the help dialog specific to the rating screen
class HelpUtil {
  static void showGeneralHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Need Help?'),
        content: Text(
          '• Provide a rating from 1 to 5 stars.\n'
          '• Add an optional comment to describe your experience.\n'
          '• Select "Yes" if you feel this center needs escalation.\n'
          '\nClick "Submit Feedback" to send your input.',
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

//Nav button logics
Widget NavLink(
    BuildContext context, String title, int index, String activePage) {
  final routes = [
    () => Navigator.push(
        context, MaterialPageRoute(builder: (_) => HomeScreen())),
    () => Navigator.push(
        context, MaterialPageRoute(builder: (_) => RatingScreen())),
    () => Navigator.push(
        context, MaterialPageRoute(builder: (_) => SelfServiceScreen())),
    () => Navigator.push(
        context, MaterialPageRoute(builder: (_) => ComplaintScreen())),
  ];

  final isSelected = title == activePage;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextButton(
      onPressed: routes[index],
      style: TextButton.styleFrom(
        backgroundColor: isSelected
            ? Color.fromARGB(255, 204, 198, 246)
            : Colors.transparent,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Color.fromARGB(255, 0, 0, 0) : Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  );
}
