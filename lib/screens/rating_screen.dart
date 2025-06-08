import 'package:flutter/material.dart';
import 'complaint_screen.dart';
import 'home_screen.dart';
import 'self_service_screen.dart';
import '../utils/help_utils.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;
  bool? _escalate;
  final TextEditingController _commentController = TextEditingController();

  void _submitFeedback() {
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

  Widget _navLink(BuildContext context, String title, int index) {
    final routes = [
      () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => HomeScreen())),
      () => {},
      () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => SelfServiceScreen())),
      () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => ComplaintScreen())),
    ];
    final isSelected = title == 'Feedback';

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
            fontWeight: isSelected ? FontWeight.normal : FontWeight.normal,
          ),
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
            _navLink(context, 'Home', 0),
            _navLink(context, 'Feedback', 1),
            _navLink(context, 'Self-Service', 2),
            _navLink(context, 'Raise Complaint', 3),
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
                backgroundColor: Colors.blue,
                shape: BeveledRectangleBorder(),
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
                                      hintText: 'Optional comment',
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
                  SizedBox(height: 32),
                  _buildFooter(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
