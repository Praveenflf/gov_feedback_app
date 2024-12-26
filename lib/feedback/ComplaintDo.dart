import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

class ComplaintDo {
  String? name;
  String department;
  String complaintDescription;
  String complaintDetails;
  String? emailID;
  bool anonymous;

  // Constructor with optional named parameters
  ComplaintDo({
    required this.department,
    required this.complaintDescription,
    required this.complaintDetails,
    this.name,
    this.emailID,
    required this.anonymous,
  });

  // Another constructor that only requires the essentials and assumes anonymity
  ComplaintDo.essential({
    required this.department,
    required this.complaintDescription,
    required this.complaintDetails,
  }) : anonymous = true;

  // Method to display complaint details
  void displayComplaint() {
    printToConsole("Department: $department");
    printToConsole("Complaint Description: $complaintDescription");
    printToConsole("Details: $complaintDetails");
    if (anonymous) {
      printToConsole("Anonymous Complaint");
    } else {
      printToConsole("Submitted by: $name, Email: $emailID");
    }
  }
}
