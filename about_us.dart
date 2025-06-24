import 'package:flutter/material.dart';
import 'generated/l10n.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('myVideo', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              s.aboutUs,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.cyan[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              s.aboutUsText,
              style: TextStyle(
                fontSize: 18,
                height: 1.5,
                fontWeight: FontWeight.w400,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
