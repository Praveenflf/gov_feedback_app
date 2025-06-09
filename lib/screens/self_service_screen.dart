import 'package:flutter/material.dart';
import 'package:gov_feedback_app/utils/custom_footer.dart';
import '../screens/complaint_screen.dart';
import '../screens/home_screen.dart';
import '../screens/rating_screen.dart';
import '../utils/help_utils.dart';
import '../utils/otp_service.dart';

class SelfServiceScreen extends StatefulWidget {
  @override
  _SelfServiceScreenState createState() => _SelfServiceScreenState();
}

class _SelfServiceScreenState extends State<SelfServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _otpController = TextEditingController();
  String selectedDept = 'Revenue';

  final _printDeptController = TextEditingController();
  final _printFormNameController = TextEditingController();

  bool otpSent = false;
  bool otpVerified = false;

  final String activePage = 'Self-Service';

  final List<String> _titles = [
    'Home',
    'Feedback',
    'Self-Service',
    'Raise Complaint'
  ];

  final departmentOptions = ['Revenue', 'Water', 'Electricity', 'Birth/Death'];

  final Map<String, List<String>> deptForms = {
    'Revenue': ['Patta Transfer Form', 'Tax Payment Form'],
    'Water': ['Water Connection Form', 'Usage Complaint Form'],
    'Electricity': ['New Connection Form', 'Complaint Form'],
    'Birth/Death': ['Birth Certificate Form', 'Death Certificate Form'],
  };

  String normalizeContact(String input) {
    input = input.trim();
    final phoneRegex = RegExp(r'^\d{10}$');
    if (phoneRegex.hasMatch(input)) {
      return '+91$input';
    }
    return input;
  }

  void _sendOTP() async {
    if (_formKey.currentState!.validate()) {
      final normalizedContact = normalizeContact(_contactController.text);
      bool success = await OtpService.sendOtp(normalizedContact);
      if (success) {
        setState(() {
          otpSent = true;
          otpVerified = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP sent to $normalizedContact")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send OTP.")),
        );
      }
    }
  }

  void _verifyOTPAndSendForms() async {
    final normalizedContact = normalizeContact(_contactController.text);
    bool success = await OtpService.verifyOtp(
      normalizedContact,
      _otpController.text.trim(),
    );

    if (success) {
      setState(() {
        otpVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP verified. Form link sent!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    }
  }

  void _printForm() {
    print(
        "Printing: ${_printFormNameController.text} from ${_printDeptController.text}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Printing ${_printFormNameController.text}...")),
    );
  }

  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) return 'Enter contact info';
    final phoneRegex = RegExp(r'^\d{10}$');
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!phoneRegex.hasMatch(value) && !emailRegex.hasMatch(value)) {
      return 'Enter valid Email or 10-digit Phone';
    }
    return null;
  }

  @override
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
              'Self-Service Portal',
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
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Get Forms Online",
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Name"),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter your name' : null,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(
                          labelText: "Email ID or Phone Number"),
                      validator: _validateContact,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) _sendOTP();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5865F2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                    ),
                    child: Text(
                      "Send OTP",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: selectedDept,
                decoration: InputDecoration(labelText: "Department"),
                items: departmentOptions.map((dept) {
                  return DropdownMenuItem(
                    value: dept,
                    child: Text(dept),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => selectedDept = val!);
                },
              ),
              SizedBox(height: 10),
              if (otpSent && !otpVerified) ...[
                TextFormField(
                  controller: _otpController,
                  decoration: InputDecoration(labelText: "Enter OTP"),
                  keyboardType: TextInputType.number,
                ),
              ],
              ElevatedButton(
                onPressed: _verifyOTPAndSendForms,
                child: Text("Verify OTP & Get Forms"),
              ),
              if (otpVerified)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Form links sent successfully."),
                ),
              Divider(height: 40),
              Text("Print Forms",
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _printDeptController.text.isEmpty
                    ? departmentOptions.first
                    : _printDeptController.text,
                decoration: InputDecoration(labelText: "Select Department"),
                items: departmentOptions.map((dept) {
                  return DropdownMenuItem(value: dept, child: Text(dept));
                }).toList(),
                onChanged: (val) {
                  _printDeptController.text = val!;
                  _printFormNameController.text = '';
                  setState(() {});
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _printFormNameController.text.isEmpty
                    ? null
                    : _printFormNameController.text,
                decoration: InputDecoration(labelText: "Select Form Name"),
                items: (_printDeptController.text.isNotEmpty
                        ? deptForms[_printDeptController.text] ?? []
                        : [])
                    .map<DropdownMenuItem<String>>((form) {
                  return DropdownMenuItem<String>(
                    value: form,
                    child: Text(form),
                  );
                }).toList(),
                onChanged: (val) {
                  _printFormNameController.text = val!;
                  setState(() {});
                },
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_printDeptController.text.isNotEmpty &&
                      _printFormNameController.text.isNotEmpty) {
                    _printForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5865F2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: Text(
                  "Print Form",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
