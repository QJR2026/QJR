import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  static const TextStyle _headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle _sectionTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle _subSectionTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle _bodyTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
  );

  static const TextStyle _italicBodyTextStyle = TextStyle(
    fontStyle: FontStyle.italic,
    color: Colors.black,
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Terms of Service'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms of Service', style: _headingStyle),
            SizedBox(height: 10),
            Text(
              'Effective Date: August 07, 2025',
              style: _italicBodyTextStyle,
            ),
            SizedBox(height: 5),
            Text(
              'App Name: Quick Jesus Reminder',
              style: _italicBodyTextStyle,
            ),
            SizedBox(height: 5),
            Text(
              'Developer: Collette Global LLC',
              style: _italicBodyTextStyle,
            ),
            SizedBox(height: 20),

            Text('1. Acceptance of Terms', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'By accessing or using the Quick Jesus Reminder mobile application ("App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, please do not use the App.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),

            Text('2. About the App and Accounts', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text('2.1. Nature of the App', style: _subSectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'Quick Jesus Reminder is designed to provide inspirational and educational quotes and daily reminders. Basic usage of the App is available without creating an account. Certain premium features require an active subscription.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 10),
            Text(
              '2.2. User Accounts and Registration',
              style: _subSectionTitleStyle,
            ),
            SizedBox(height: 5),
            Text(
              'To access subscription-based features across multiple devices, restore purchases, or personalize your experience, you may create an account using a valid email address and password. You are responsible for maintaining the confidentiality of your credentials and all activities performed under your account.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),

            // ===== START: IN-APP SUBSCRIPTIONS SECTION =====
            Text('3. In-App Subscriptions', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'The App offers auto-renewable in-app subscriptions that provide access to premium content and enhanced features. Subscription options, pricing, and billing periods are displayed within the App at the time of purchase.\n\n'
              'Payment will be charged to your Apple ID account at the time of confirmation of purchase. Subscriptions automatically renew unless auto-renew is turned off at least 24 hours before the end of the current billing period.\n\n'
              'You can manage or cancel your subscription at any time through your Apple App Store account settings. Any unused portion of a free trial period, if offered, will be forfeited when a subscription is purchased.\n\n'
              'Subscription fees are non-refundable except as required by law or permitted under Apple’s App Store policies. Collette Global LLC does not process payments or issue refunds directly.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),
            // ===== END: IN-APP SUBSCRIPTIONS SECTION =====

            Text('4. Intellectual Property', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'All content in the App, including text and graphics, is the property of Collette Global LLC or is sourced from public domain materials. You may not reproduce, distribute, or create derivative works without explicit permission unless otherwise stated.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),

            Text('5. Disclaimer of Warranties', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'The App and its content are provided "as is" without warranties of any kind. We do not guarantee the App will be uninterrupted or error-free. Your use of the App is at your own risk.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),

            Text('6. Limitation of Liability', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'Collette Global LLC shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the App or subscription services.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),

            Text('7. Governing Law', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'These Terms are governed by and construed in accordance with the laws of the State of Delaware, USA, without regard to its conflict of law rules.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),

            Text('8. Changes to These Terms', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'We may update these Terms from time to time. The Effective Date above will reflect the latest changes. Continued use of the App after changes become effective constitutes acceptance of the revised Terms.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),

            Text('9. Contact Us', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'If you have any questions or concerns about these Terms, please contact us at:\n\n'
              'Collette Global LLC\n'
              'Email: adam@colletteglobal.com\n'
              'Developer Email: mohsinkalam79@gmail.com',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
