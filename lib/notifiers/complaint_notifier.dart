import 'package:flutter/material.dart';
import '../models/complaint_model.dart';

class ComplaintNotifier extends ChangeNotifier {
  List<String> complaintOnWhomOptions = [
    'Unknown',
    'Officer A',
    'Officer B',
    'Clerk C',
    'Security',
    'Other'
  ];

  // Private variable to store the complaint that has been submitted
  ComplaintModel? _submittedComplaint;

  // Getter to retrieve the submitted complaint
  ComplaintModel? get submittedComplaint => _submittedComplaint;

  // Counter to generate unique complaint IDs
  static int _complaintCounter = 0;

  // Function to submit a complaint
  void submitComplaint(ComplaintModel complaint) {
    _submittedComplaint = complaint;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Generate a new complaint ID in the format "CD00001", "CD00002", ...
  static String generateComplaintId() {
    _complaintCounter++;
    return 'CD' + _complaintCounter.toString().padLeft(5, '0');
  }
}
