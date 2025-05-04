import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service and Complaint Management',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Align(
        alignment: Alignment.center,
        child: Text('Service and Complaint Management'),
      )),
      body: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        //left section - Function A, B, & C
        Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Function A
                buildSectionTitle("Feedback & Escalation"),
                FeedbackSection(),
                //Function B & C
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SelfServicePortal(),
                    ),
                    Expanded(
                      child: FileComplaint(),
                    )
                  ],
                )
              ],
            )),
        //Right Section - Function D
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSectionTitle("Happiness Index"),
                HappinessIndexSection(),
              ],
            )),
      ] //row
          ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(3 + .2),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class FeedbackSection extends StatefulWidget {
  const FeedbackSection({super.key});

  @override
  _FeedbackSectionState createState() => _FeedbackSectionState();
}

class HappinessIndexSection extends StatefulWidget {
  const HappinessIndexSection({super.key});

  @override
  _HappinessIndexSectionState createState() => _HappinessIndexSectionState();
}

class SelfServicePortal extends StatefulWidget {
  const SelfServicePortal({super.key});

  @override
  _SelfServicePortal createState() => _SelfServicePortal();
}

class FileComplaint extends StatefulWidget {
  const FileComplaint({super.key});

  @override
  _FileComplaint createState() => _FileComplaint();
}

class _FileComplaint extends State<FileComplaint> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color.fromARGB(255, 159, 236, 104),
        padding: const EdgeInsets.fromLTRB(0, 150, 0, 100),
        child: Center(
          child:
              //Function C
              ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComplaintFormScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 105, 40, 226),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                )),
            child: const Text(
              'File a Complaint',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelfServicePortal extends State<SelfServicePortal> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Color.fromARGB(255, 119, 244, 131),
        padding: const EdgeInsets.fromLTRB(0, 150, 0, 100),
        child: Center(
          child:
              //Function B
              ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServiceListScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 105, 40, 226),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                )),
            child: const Text(
              'Self-Service Portal',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _HappinessIndexSectionState extends State<HappinessIndexSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class _FeedbackSectionState extends State<FeedbackSection> {
  int rate = 0; // Holds the star rating value
  String? comment; // Holds the user's comment
  bool? voteForEscalation; // Holds whether the user voted for escalation

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 211, 51),
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              color: Colors.white,
              child: const Text(
                'Rate our Service:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rate ? Icons.star : Icons.star_border,
                    color: const Color.fromARGB(255, 24, 7, 209),
                  ),
                  onPressed: () {
                    setState(() {
                      rate = index + 1; // Update the star rating
                    });
                  },
                );
              }),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.all(1),
              color: Colors.white,
              child: const Text(
                'Comments',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Leave a Comment (Optional)'),
              onChanged: (value) {
                comment = value; // Update the comment value
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(1),
              color: Colors.white,
              child: const Text(
                'Vote for Escalation:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 45,
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      voteForEscalation = true; // User votes "Yes"
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: voteForEscalation == true
                        ? Colors.blue
                        : const Color.fromARGB(
                            255, 243, 242, 242), // Highlight selection
                  ),
                  child: const Text('Yes'),
                ),
                const SizedBox(
                  width: 44,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      voteForEscalation = false; // User votes "No"
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: voteForEscalation == false
                        ? Colors.blue
                        : const Color.fromARGB(
                            255, 243, 242, 242), // Highlight selection
                  ),
                  child: const Text('No'),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Feedback Submitted'),
                        content: Text(
                            'Rating: $rate\nComment: ${comment ?? "No comment"}\nVote for Escalation: ${voteForEscalation == true ? "Yes" : "No"}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          )
                        ],
                      );
                    },
                  );
                },
                child: const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function B: Self-Service List
class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-Service List'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Print Form"),
            onTap: () {
              // Implement Print Form functionality
            },
          ),
          ListTile(
            title: const Text("Submit Simple Application"),
            onTap: () {
              // Implement application submission
            },
          ),
        ],
      ),
    );
  }
}

// Function C: Complaint Form
class ComplaintFormScreen extends StatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  _ComplaintFormScreenState createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  bool keepAnonymous = false;
  String? name;
  String? department;
  String shortDescription = '';
  String detailedDescription = '';
  String? complaintOnWhom;
  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File a Complaint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Keep Anonymous"),
              value: keepAnonymous,
              onChanged: (value) {
                setState(() {
                  keepAnonymous = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Name (optional)"),
              onChanged: (value) {
                name = value;
              },
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: "Department (optional)"),
              onChanged: (value) {
                department = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Short Description"),
              onChanged: (value) {
                shortDescription = value;
              },
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: "Detailed Description"),
              maxLines: 5,
              onChanged: (value) {
                detailedDescription = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Complaint on Whom"),
              onChanged: (value) {
                complaintOnWhom = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Email (optional)"),
              onChanged: (value) {
                email = value;
              },
            ),
            TextButton(
              onPressed: () {
                // Submit functionality
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
