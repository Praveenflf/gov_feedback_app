import 'package:flutter/material.dart';
import 'rating_screen.dart';
import 'self_service_screen.dart';
import 'complaint_screen.dart';
import 'happiness_index_screen.dart';
import '../utils/help_utils.dart';

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
                          alignment: Alignment.center,
                          child: _buildWelcomeContent(context),
                        ),
                      ),
                      SizedBox(width: 20),
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
      bottomNavigationBar: _buildFooter(),
    );
  }

  Widget _navLink(
      BuildContext context, String title, int index, String activePage) {
    final routes = [
      () {},
      () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => RatingScreen())),
      () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => SelfServiceScreen())),
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

  Widget _buildWelcomeContent(BuildContext context) {
    const buttonWidth = 340.0;
    const buttonHeight = 60.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          backgroundColor: const Color.fromARGB(255, 102, 78, 255),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          alignment: Alignment.center,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 19),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                ),
                child: Text('Subscribe'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _footerLink('About us'),
              _footerLink('Features'),
              _footerLink('Help Center'),
              _footerLink('Contact us'),
              _footerLink('FAQs'),
              _footerLink('Careers'),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Colors.white24),
          SizedBox(height: 10),
          Text('© 2025 Brand, Inc. • Privacy • Terms • Sitemap',
              style:
                  TextStyle(color: const Color.fromARGB(137, 255, 255, 255))),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(text, style: TextStyle(color: Colors.white70)),
    );
  }
}
