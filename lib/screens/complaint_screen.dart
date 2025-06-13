import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gov_feedback_app/screens/home_screen.dart';
import 'package:gov_feedback_app/screens/rating_screen.dart';
import 'package:gov_feedback_app/screens/self_service_screen.dart';
import 'package:gov_feedback_app/utils/ComplaintIdGenerator.dart';
import 'package:gov_feedback_app/utils/custom_footer.dart';
import 'package:gov_feedback_app/utils/help_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComplaintScreen extends StatefulWidget {
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _complaintOnController = TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? name, shortDesc, detailedDesc, department, complaintOnWhom;
  String? contact;
  String? otp;

  bool otpSent = false;
  bool otpVerified = false;
  bool isVerifying = false;
  String errorMessage = '';

  String? selectedDepartment;

  // Helper regex for validation
  final RegExp _phoneRegex = RegExp(r'^\+91\d{10}$');
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool isValidPhone(String input) => RegExp(r'^\d{10}$').hasMatch(input);
  bool isValidEmail(String input) =>
      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);

  Future<void> _sendOtp() async {
    final val = _contactController.text.trim();
    String? formattedContact;

    // Validate and format contact
    if (_phoneRegex.hasMatch(val)) {
      formattedContact = val;
    } else if (RegExp(r'^\d{10}$').hasMatch(val)) {
      // Add +91 prefix if just 10 digits entered
      formattedContact = '+91$val';
      _contactController.text = formattedContact;
    } else if (_emailRegex.hasMatch(val)) {
      formattedContact = val;
    } else {
      // Invalid format - show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a valid phone number or email')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/send-otp'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': formattedContact,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        print("OTP sent successfully");
        otpSent = true;
        errorMessage = '';
      });
    } else {
      setState(() => errorMessage = 'Failed to send OTP. Try again.');
    }
  }

  Future<void> _verifyOtp() async {
    final contact = _contactController.text.trim();
    final otp = _otpController.text.trim();
    final formattedContact = isValidPhone(contact) ? '+91$contact' : contact;

    if (otp.isEmpty || otp.length != 6) {
      setState(() => errorMessage = 'Enter valid 6-digit OTP');
      return;
    }

    setState(() => isVerifying = true);

    final response = await http.post(
      Uri.parse('http://localhost:3000/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': formattedContact, 'code': otp}),
    );

    setState(() => isVerifying = false);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true) {
        setState(() {
          otpVerified = true;
          errorMessage = 'OTP verified successfully';
        });
      } else {
        setState(() {
          otpVerified = false;
          errorMessage = responseBody['message'] ?? 'Invalid OTP';
        });
      }
    } else {
      setState(
          () => errorMessage = 'OTP verification failed. Please try again.');
    }
    print(errorMessage);
  }

  final String activePage = 'Raise Complaint';
  final List<String> _titles = [
    'Home',
    'Feedback',
    'Self-Service',
    'Raise Complaint'
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 20,
        title: Row(
          children: [
            Image.asset('images/logo.jpg', height: 32),
            SizedBox(width: 8),
            Text(
              'Complaint Submission Form',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 32),
            ...List.generate(_titles.length, (index) {
              return NavLink(context, _titles[index], index, activePage);
            }),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextButton.icon(
              onPressed: () => showHelpDialog(context),
              icon: Icon(Icons.help_outline, color: Colors.white),
              label: Text('? Help', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 119, 102, 227),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 700) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLeftColumn(),
                        SizedBox(width: 40),
                        buildRightColumn(),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        buildLeftColumn(),
                        SizedBox(height: 30),
                        buildRightColumn(),
                      ],
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget buildLeftColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            _nameController,
            'Name (optional)',
            onChanged: (val) => name = val,
            validator: null,
          ),
          SizedBox(height: 20),
          _buildTextField(
            _shortDescriptionController,
            'Short Description *',
            onChanged: (val) => shortDesc = val,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Short Description is required';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildTextField(
            _descriptionController,
            'Detailed Description (optional)',
            maxLines: 5,
            onChanged: (val) => detailedDesc = val,
            validator: null,
          ),
          SizedBox(height: 20),
          _buildDropdownField(
            label: 'Complaint on Whom *',
            value: complaintOnWhom,
            items: ['Officer A', 'Clerk B', 'Others', 'N/A'],
            onChanged: (val1) {
              setState(() {
                complaintOnWhom = val1;
                print('Selected: $complaintOnWhom');
              });
            },
            validator: (val1) {
              if (val1 == null || val1.isEmpty) {
                return 'Please select whom complaint is against';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buildRightColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdownField(
            label: 'Department *',
            value: department,
            items: ['Water', 'Electricity', 'Sanitation', 'Other', 'N/A'],
            onChanged: (val) => setState(() => department = val),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please select a department';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildOtpRow(
            label: 'Contact (Phone or Email) (optional)',
            controller: _contactController,
            hint: 'Enter phone or email',
            onSendOtp: _sendOtp,
          ),
          if (otpSent) ...[
            SizedBox(height: 20),
            _buildOtpVerificationRow(
              controller: _otpController,
              onVerifyOtp: _verifyOtp,
              otpVerified: otpVerified,
            ),
          ],
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: otpVerified
                  ? _submitComplaint
                  : () {
                      setState(() {
                        errorMessage =
                            "Please verify the OTP before submitting.";
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5865F2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController Textcontroller, String label,
      {int maxLines = 1,
      required Function(String) onChanged,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        TextFormField(
          controller: Textcontroller,
          onChanged: onChanged,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: 'Enter $label'.replaceAll('(optional)', '').trim(),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          validator: validator,
          items: items
              .map((e) => DropdownMenuItem(child: Text(e), value: e))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Choose $label',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpRow({
    required String label,
    required TextEditingController controller,
    required String hint,
    required VoidCallback onSendOtp,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: otpSent ? null : onSendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5865F2),
              ),
              child: Text(
                'Send OTP',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildOtpVerificationRow({
    required TextEditingController controller,
    required VoidCallback onVerifyOtp,
    required bool otpVerified,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter OTP'),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter 6 digit OTP',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  suffixIcon: otpVerified
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: isVerifying || otpVerified ? null : onVerifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5865F2),
              ),
              child: isVerifying
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(otpVerified ? 'Verified' : 'Verify'),
            )
          ],
        ),
      ],
    );
  }

  void _submitComplaint() {
    if (!_formKey.currentState!.validate()) {
      // Form fields validation failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the required fields')),
      );
      return;
    }

    if (!otpSent) {
      setState(() => errorMessage = 'Please request OTP first.');
      return;
    }

    // OTP verification
    if (!otpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please verify OTP before submitting')),
      );
      return;
    }

    // Save form state (if needed)
    _formKey.currentState!.save();

    if (!otpVerified) {
      return null;
    }

    name = _nameController.text.trim();
    contact = _contactController.text.trim();
    shortDesc = _shortDescriptionController.text.trim();
    detailedDesc = _descriptionController.text.trim();

    _saveComplaintToFireStore(); //save details to DB

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Complaint submitted successfully.')),
    );

    // Reset
    _formKey.currentState!.reset();
    _contactController.clear();
    _otpController.clear();
    _descriptionController.clear();
    _complaintOnController.clear;
    complaintOnWhom = null;
    department = null;
    setState(() {
      selectedDepartment = null;
      otpSent = false;
      otpVerified = false;
      errorMessage = '';
    });
  }

  Future<void> _saveComplaintToFireStore() async {
    try {
      String complID = await getNextComplaintIdFromFirestore();
      print("Saving complaint date to DB");
      await FirebaseFirestore.instance
          .collection("Complaints")
          .doc(complID)
          .set({
        'Contact': contact,
        'Defendant': complaintOnWhom,
        'DepartmentID': department,
        'Name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'detailed_Desc': detailedDesc,
        'short_Desc': shortDesc,
        'status': 'New'
      });
    } catch (e) {
      print("Error saving complaint: $e");
    }
  }
}
