import 'dart:js_interop_unsafe';
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/help_utils.dart';
import 'complaint_screen.dart';
import 'home_screen.dart';
import 'rating_screen.dart';

class SelfServiceScreen extends StatefulWidget {
  @override
  _SelfServiceScreenState createState() => _SelfServiceScreenState();
}

class _SelfServiceScreenState extends State<SelfServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _emailPhoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _deptController = TextEditingController();

  bool isPhone = true;
  bool otpSent = false;
  bool otpVerified = false;
  String generatedOTP = '';
  String referenceId = '';
  String selectedForm = 'Aadhar Card';

  void _sendOTP() {
    setState(() {
      generatedOTP = (100000 + Random().nextInt(900000)).toString();
      otpSent = true;
      otpVerified = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("OTP Sent: $generatedOTP (simulated)"),
    ));
  }

  void _verifyOTP() {
    if (_otpController.text == generatedOTP) {
      setState(() {
        otpVerified = true;
        referenceId = 'REF${Random().nextInt(999999)}';
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Form submitted successfully! Reference ID: $referenceId"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid OTP"),
      ));
    }
  }

  void _printForm() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Printing $selectedForm... (simulated)"),
    ));
  }

  void dispose() {
    _otpController.dispose();
    _emailPhoneController.dispose();
    _nameController.dispose();
    _deptController.dispose();
    super.dispose();
  }

  final String activePage = 'Self-Service';

  final List<String> _titles = [
    'Home',
    'Feedback',
    'Self-Service',
    'Raise Complaint'
  ];

  Widget _navLink(
      BuildContext context, String title, int index, String activePage) {
    final routes = [
      () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => HomeScreen())),
      () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => RatingScreen())),
      () {},
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
            color:
                isSelected ? Color.fromARGB(255, 102, 78, 255) : Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

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
              return _navLink(context, _titles[index], index, activePage);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Self Service Portal",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 30),

            // Submit Form Section
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name (required)"),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val!.isEmpty ? "Enter your name" : null,
                  ),
                  SizedBox(height: 20),
                  Text("Email ID (optional)"),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _emailPhoneController,
                    keyboardType: isPhone
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: isPhone
                          ? "Enter your Phone Number"
                          : "Enter your Email ID",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(isPhone ? Icons.phone : Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Department (required)"),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _deptController,
                    decoration: InputDecoration(
                      hintText: "Select your Department",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val!.isEmpty ? "Enter your department" : null,
                  ),
                  SizedBox(height: 20),
                  Text("Description"),
                  SizedBox(height: 5),
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Enter your Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isPhone ? "Phone Number" : "Email Address"),
                      Switch(
                        value: isPhone,
                        onChanged: (val) {
                          setState(() => isPhone = val);
                        },
                      ),
                    ],
                  ),
                  if (!otpSent)
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) _sendOTP();
                      },
                      child: Text("Submit"),
                    ),
                  if (otpSent && !otpVerified) ...[
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        labelText: "Enter OTP",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _verifyOTP,
                      child: Text("Verify OTP & Confirm"),
                    ),
                  ],
                  if (otpVerified)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "✅ Submitted! Reference ID: $referenceId",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 40),
            Divider(thickness: 1),
            SizedBox(height: 20),

            // Print Forms Section
            Text(
              "Print Forms",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedForm,
                    items: [
                      'Aadhar Card',
                      'Birth Certificate',
                      'Caste Certificate',
                      'Income Certificate',
                    ]
                        .map((form) => DropdownMenuItem(
                              value: form,
                              child: Text(form),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedForm = val!),
                    decoration: InputDecoration(
                      hintText: "Select Department",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Form name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: _printForm,
                child: Text("Print"),
              ),
            ),

            SizedBox(height: 40),

            // Footer Section
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Subscribe to our newsletter',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    hintText: 'Input your email',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  shape: BeveledRectangleBorder(),
                ),
                child: Text('Subscribe', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 20,
            alignment: WrapAlignment.center,
            children: [
              for (var label in [
                'About us',
                'Features',
                'Help Center',
                'Contact us',
                'FAQs',
                'Careers'
              ])
                TextButton(
                  onPressed: () {},
                  child: Text(label, style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            '© 2025 Brand, Inc. • Privacy • Terms • Sitemap',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          )
        ],
      ),
    );
  }
}
