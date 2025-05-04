import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/feedback_notifier.dart';

class HappinessIndexScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the average rating from FeedbackNotifier
    final averageRating = Provider.of<FeedbackNotifier>(context).average_Rating;

    // Function to get color based on the average rating
    Color getColor(double rating) {
      if (rating >= 4) {
        return Colors.green; // Good
      } else if (rating >= 3) {
        return Colors.orange; // Moderate
      } else {
        return Colors.red; // Poor
      }
    }

    // Function to get status based on the rating
    String getStatus(double rating) {
      if (rating >= 4) {
        return 'Excellent';
      } else if (rating >= 3) {
        return 'Average';
      } else {
        return 'Needs Improvement';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Happiness Index'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Happiness Index',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            CircleAvatar(
              radius: 60,
              backgroundColor: getColor(averageRating),
              child: Text(
                averageRating.toStringAsFixed(1),
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Text(
              getStatus(averageRating),
              style: TextStyle(fontSize: 20, color: getColor(averageRating)),
            )
          ],
        ),
      ),
    );
  }
}
