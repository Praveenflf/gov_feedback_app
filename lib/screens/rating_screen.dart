import 'package:flutter/material.dart';
import '../utils/custom_footer.dart';
import 'complaint_screen.dart';
import 'home_screen.dart';
import 'self_service_screen.dart';
import '../utils/help_utils.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;
  bool? _escalate = null;
  final TextEditingController _commentController = TextEditingController();

  final String activePage = 'Feedback';

  final List<String> _titles = [
    'Home',
    'Feedback',
    'Self-Service',
    'Raise Complaint'
  ];

  void _submitFeedback() {
    if (_rating == 0) {
      // Show alert dialog asking to select rating
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Rating Required"),
          content: Text("Please select the star before submitting."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return; // Don't proceed further
    }

    //Request to provide comments
    if (_rating <= 2) {
      // Show alert dialog
      if (_escalate == false) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Escalation Required due to low rating"),
            content:
                Text("Please select Yes to escalation to complete submission"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
        return;
      }

      if (_escalate == null) {
        // Show alert dialog asking to answer escalation
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content:
                Text("Please answer 'Do you want to escalte this center?'"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
        return; // Don't proceed further
      }

      // Show alert dialog
      if (_commentController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Comment Required"),
            content: Text("Please provide comment to complete submission"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
        return;
      } // Don't proceed further
    }

    // Proceed with submission
    _saveFeedbackToFirestore(); //save data to db
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Feedback Submitted"),
        content: Text("Thank you for your feedback!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _rating = 0;
                _escalate = null;
                _commentController.clear();
              });
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> _saveFeedbackToFirestore() async {
    try {
      print("Saving details to firebase");
      await FirebaseFirestore.instance.collection('Ratings').add({
        'Rating': _rating,
        'Comment': _commentController.text.trim(),
        'escalate': _escalate,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving feedback: $e");
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
        );
      }),
    );
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
            Text('Feedback Hub',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
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
              onPressed: () => HelpUtil.showGeneralHelp(context),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 800;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Form
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Feedback Form',
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  Text('Provide your rating from 1 to 5'),
                                  SizedBox(height: 10),
                                  _buildStarRating(),
                                  SizedBox(height: 16),
                                  TextField(
                                    controller: _commentController,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText: 'Comment',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text('Do you want to escalate this center?'),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            setState(() => _escalate = true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _escalate == true
                                              ? Color.fromARGB(
                                                  255, 102, 78, 255)
                                              : Color.fromARGB(
                                                  255, 196, 193, 193),
                                          shape: BeveledRectangleBorder(),
                                        ),
                                        child: Text('Yes',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      SizedBox(width: 16),
                                      ElevatedButton(
                                        onPressed: () =>
                                            setState(() => _escalate = false),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _escalate == false
                                              ? Color.fromARGB(
                                                  255, 102, 78, 255)
                                              : Color.fromARGB(
                                                  255, 196, 193, 193),
                                          shape: BeveledRectangleBorder(),
                                        ),
                                        child: Text('No',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 60),
                            // Right Submit Section
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Submit Feedback',
                                      style: TextStyle(
                                          fontSize: 38,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 102, 78, 255)),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'We value your opinion! Share your thoughts and help us improve.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 26,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: _submitFeedback,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 102, 78, 255),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 18),
                                        shape: BeveledRectangleBorder(),
                                      ),
                                      child: Text(
                                        'Submit Feedback',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Feedback Form',
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Text('Provide your rating from 1 to 5'),
                            _buildStarRating(),
                            TextField(
                              controller: _commentController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Optional comment',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text('Do you want to escalate this center?'),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      setState(() => _escalate = true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _escalate == true
                                        ? Colors.blue
                                        : Colors.grey[600],
                                    shape: BeveledRectangleBorder(),
                                  ),
                                  child: Text('Yes',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      setState(() => _escalate = false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _escalate == false
                                        ? Colors.blue
                                        : Colors.grey[600],
                                    shape: BeveledRectangleBorder(),
                                  ),
                                  child: Text('No',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Center(
                              child: ElevatedButton(
                                onPressed: _submitFeedback,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 18),
                                  shape: BeveledRectangleBorder(),
                                ),
                                child: Text('Submit Feedback',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Footer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
