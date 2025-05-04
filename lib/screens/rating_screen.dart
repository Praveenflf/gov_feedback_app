import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/feedback_model.dart';
import '../notifiers/feedback_notifier.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  // Variables to hold the user inputs
  int _rating = 1; // Default rating is 1
  String? _comment; // Optional comment
  bool _escalate = false; // Default is no escalation

  // Key to validate the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Function A - Rate & Comment'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Rating input (1 to 5)
              Text(
                'Rate your experience:',
                style: TextStyle(fontSize: 18),
              ),
              Slider(
                value: _rating.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _rating.toString(),
                onChanged: (value) {
                  setState(() {
                    _rating = value.toInt();
                  });
                },
              ),
              Text('Rating: $_rating', style: TextStyle(fontSize: 16)),

              // Comment input (optional)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Add a comment (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _comment = value;
                  });
                },
              ),
              SizedBox(height: 10),

              // Escalation switch
              SwitchListTile(
                title: Text('Escalate this feedback?'),
                value: _escalate,
                onChanged: (value) {
                  setState(() {
                    _escalate = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create a new FeedbackModel
                    final feedback = FeedbackModel(
                      rating: _rating,
                      comment: _comment,
                      escalate: _escalate,
                    );

                    // Add feedback to the provider
                    Provider.of<FeedbackNotifier>(context, listen: false)
                        .addFeedback(feedback);

                    // Show a confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Feedback submitted successfully!')),
                    );

                    // Optionally clear the form
                    setState(() {
                      _rating = 1;
                      _comment = null;
                      _escalate = false;
                    });
                  }
                },
                child: Text('Submit Feedback'),
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
