import 'package:flutter/material.dart';

class ComplaintScreen extends StatefulWidget {
  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();

  String? name, shortDesc, detailedDesc, department, complaintOnWhom;
  String? phone, email, otp;

  void _sendOtp(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP sent to $type (mocked)')),
    );
  }

  Widget buildLeftColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Name (optional)', onChanged: (val) => name = val),
          SizedBox(height: 20),
          _buildTextField('Short Description',
              onChanged: (val) => shortDesc = val),
          SizedBox(height: 20),
          _buildTextField('Detailed Description',
              maxLines: 5, onChanged: (val) => detailedDesc = val),
          SizedBox(height: 20),
          _buildDropdownField(
            label: 'Complaint on Whom',
            value: complaintOnWhom,
            items: ['Officer A', 'Clerk B', 'Others'],
            onChanged: (val) => setState(() => complaintOnWhom = val),
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
            label: 'Department',
            value: department,
            items: ['Water', 'Electricity', 'Sanitation', 'Other'],
            onChanged: (val) => setState(() => department = val),
          ),
          SizedBox(height: 20),
          _buildOtpRow(
            label: 'Phone Number (Optional)',
            hint: 'Enter your phone',
            onChanged: (val) => phone = val,
            onSendOtp: () => _sendOtp('Phone'),
          ),
          SizedBox(height: 20),
          _buildOtpRow(
            label: 'Email ID (Optional)',
            hint: 'Enter your email',
            onChanged: (val) => email = val,
            onSendOtp: () => _sendOtp('Email'),
          ),
          SizedBox(height: 20),
          _buildTextField('Enter OTP', onChanged: (val) => otp = val),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _submitComplaint,
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
        ],
      ),
    );
  }

  Widget _buildTextField(String label,
      {int maxLines = 1, required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          maxLines: maxLines,
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
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
    required String hint,
    required Function(String) onChanged,
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
                onChanged: onChanged,
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
              onPressed: onSendOtp,
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

  void _submitComplaint() {
    // Add logic to submit
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Complaint Submitted (mocked)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complaint Submission Form"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
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
      ),
    );
  }
}
