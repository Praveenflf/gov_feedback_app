class ComplaintModel {
  final String complaintId; // Unique complaint ID, e.g., CD00001
  final String? name; // Optional Name of the complainant
  final String department; // Department the complaint pertains to
  final String shortDescription; // Short description of the complaint
  final String?
      detailedDescription; // Optional detailed description of the complaint
  final String complaintOnWhom; // Person/department the complaint is against
  final String? email; // Optional email for the complainant

  ComplaintModel({
    required this.complaintId, // Ensure complaintId is passed during initialization
    this.name, // Optional
    required this.department, // Mandatory
    required this.shortDescription, // Mandatory
    this.detailedDescription, // Optional
    required this.complaintOnWhom, // Mandatory
    this.email, // Optional
  });
}
