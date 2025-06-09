import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Subscribe to our newsletter',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    hintText: 'Input your email',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Add your subscribe logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 119, 102, 227),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                ),
                child: const Text(
                  'Subscribe',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _FooterLink(text: 'About us'),
              _FooterLink(text: 'Features'),
              _FooterLink(text: 'Help Center'),
              _FooterLink(text: 'Contact us'),
              _FooterLink(text: 'FAQs'),
              _FooterLink(text: 'Careers'),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          const Text(
            '© 2025 Brand, Inc. • Privacy • Terms • Sitemap',
            style: TextStyle(color: Color.fromARGB(137, 255, 255, 255)),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;

  const _FooterLink({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Add link action here
      },
      child: Text(text, style: const TextStyle(color: Colors.white70)),
    );
  }
}
