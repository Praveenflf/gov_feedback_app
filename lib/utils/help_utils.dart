import 'package:flutter/material.dart';

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

/// A utility class for help-related functionality
class HelpUtil {
  /// Shows the help dialog specific to the rating screen
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
