import 'package:flutter/material.dart';
import 'rating_screen.dart';
import 'self_service_screen.dart';
import 'complaint_screen.dart';
import 'happiness_index_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.png'), // replace with your logo
        ),
        title: Text(
          'Feedback Hub',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('? Help'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
            ),
          ),
          SizedBox(width: 16),
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
                      _buildLeftContent(context),
                      Spacer(),
                      SizedBox(
                        width: 250,
                        child: HappinessIndexScreen(),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildLeftContent(context),
                        SizedBox(height: 20),
                        HappinessIndexScreen()
                      ],
                    ),
                  ),
          );
        },
      ),
      bottomNavigationBar: _buildFooter(),
    );
  }

  Widget _buildLeftContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome! How may we assist\nyou today?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
        _buildNavButton(context, 'Feedback', RatingScreen()),
        SizedBox(height: 12),
        _buildNavButton(context, 'Self-Service', SelfServiceScreen()),
        SizedBox(height: 12),
        _buildNavButton(context, 'Raise Complaint', ComplaintScreen()),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String title, Widget target) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => target),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade50,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        alignment: Alignment.centerLeft,
        textStyle: TextStyle(fontSize: 16),
        elevation: 0,
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.blue.shade900),
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
          Text(
            'Subscribe to our newsletter',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
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
          Text(
            '© 2025 Brand, Inc. • Privacy • Terms • Sitemap',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
