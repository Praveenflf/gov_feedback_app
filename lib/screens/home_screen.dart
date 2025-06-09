import 'package:flutter/material.dart';
import 'rating_screen.dart';
import 'self_service_screen.dart';
import 'complaint_screen.dart';
import 'happiness_index_screen.dart';
import '../utils/help_utils.dart';
import '../utils/custom_footer.dart';

class HomeScreen extends StatelessWidget {
  final String activePage = 'Home';

  final List<String> _titles = [
    'Home',
    'Feedback',
    'Self-Service',
    'Raise Complaint'
  ];

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
              'Feedback Hub',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: _buildWelcomeContent(context),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: HappinessIndexScreen(),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildWelcomeContent(context),
                        SizedBox(height: 20),
                        HappinessIndexScreen(),
                      ],
                    ),
                  ),
          );
        },
      ),
      bottomNavigationBar: Footer(),
    );
  }

  Widget _buildWelcomeContent(BuildContext context) {
    const buttonWidth = 340.0;
    const buttonHeight = 60.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome! How may we assist\nyou today?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        _buildNavButton(context, 'Feedback', 1, buttonWidth, buttonHeight),
        SizedBox(height: 20),
        _buildNavButton(context, 'Self-Service', 2, buttonWidth, buttonHeight),
        SizedBox(height: 20),
        _buildNavButton(
            context, 'Raise Complaint', 3, buttonWidth, buttonHeight),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String title, int index,
      double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: () {
          switch (index) {
            case 1:
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => RatingScreen()));
              break;
            case 2:
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => SelfServiceScreen()));
              break;
            case 3:
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ComplaintScreen()));
              break;
          }
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 186, 179, 231),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          alignment: Alignment.center,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
              color: Color.fromARGB(255, 67, 7, 246), fontSize: 19),
        ),
      ),
    );
  }
}
