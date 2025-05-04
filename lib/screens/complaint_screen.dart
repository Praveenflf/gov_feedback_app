import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/complaint_model.dart';
import '../notifiers/complaint_notifier.dart';
import '../utils/complaintIdGenerator.dart'; // Import your ID generator utility

class ComplaintScreen extends StatefulWidget {
  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  // Variables to hold the user inputs
  String? _name;
  String _department = 'Water';
  String _shortDescription = '';
  String? _detailedDescription;
  String _complaintOnWhom = 'Unknown';
  String? _email;

  // Key to validate the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Function C - File a Complaint'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Name input (optional)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name (optional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              SizedBox(height: 10),

              // Department dropdown
              DropdownButtonFormField<String>(
                value: _department,
                decoration: InputDecoration(
                  labelText: 'Select Department',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _department = value!;
                  });
                },
                items: ['Water', 'Electricity', 'Sanitation', 'Other']
                    .map((dep) => DropdownMenuItem<String>(
                          value: dep,
                          child: Text(dep),
                        ))
                    .toList(),
              ),
              SizedBox(height: 10),

              // Short description input
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Short Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _shortDescription = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a short description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Detailed description input (optional)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Detailed Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _detailedDescription = value;
                  });
                },
              ),
              SizedBox(height: 10),

              // Complaint on Whom dropdown
              DropdownButtonFormField<String>(
                value: _complaintOnWhom,
                decoration: InputDecoration(
                  labelText: 'Complaint on Whom',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _complaintOnWhom = value!;
                  });
                },
                items: [
                  'Unknown',
                  'Officer A',
                  'Officer B',
                  'Clerk C',
                  'Security',
                  'Other'
                ]
                    .map((whom) => DropdownMenuItem<String>(
                          value: whom,
                          child: Text(whom),
                        ))
                    .toList(),
              ),
              SizedBox(height: 10),

              // Email input (optional)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email (optional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Generate complaint ID
                    final complaintId =
                        await ComplaintIdGenerator.getNextComplaintId();

                    // Create a new ComplaintModel with the generated ID
                    final complaint = ComplaintModel(
                      complaintId: complaintId,
                      name: _name ?? '',
                      department: _department,
                      shortDescription: _shortDescription,
                      detailedDescription: _detailedDescription ?? '',
                      complaintOnWhom: _complaintOnWhom,
                      email: _email ?? '',
                    );

                    // Add complaint to the provider
                    Provider.of<ComplaintNotifier>(context, listen: false)
                        .submitComplaint(complaint);

                    // Show a confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Complaint submitted successfully!'),
                      ),
                    );

                    // Clear form
                    setState(() {
                      _name = null;
                      _department = 'Water';
                      _shortDescription = '';
                      _detailedDescription = null;
                      _complaintOnWhom = 'Unknown';
                      _email = null;
                    });
                  }
                },
                child: Text('Submit Complaint'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
