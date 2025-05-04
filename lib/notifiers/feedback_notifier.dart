import 'package:flutter/material.dart';
import '../models/feedback_model.dart';

class FeedbackNotifier extends ChangeNotifier {
  List<FeedbackModel> _feedbacks = []; // List to store all the feedback entries

  // Adds a feedback entry to the list
  void addFeedback(FeedbackModel feedback) {
    _feedbacks.add(feedback);
    notifyListeners(); // Notify listeners to update the UI
  }

  // Calculate and return the average rating from all feedbacks
  double get average_Rating {
    if (_feedbacks.isEmpty) return 0.0;
    return _feedbacks.map((f) => f.rating).reduce((a, b) => a + b) /
        _feedbacks.length;
  }

  // Getter to access all the feedbacks
  List<FeedbackModel> get allFeedbacks => _feedbacks;
}
