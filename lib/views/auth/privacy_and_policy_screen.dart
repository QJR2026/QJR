import 'package:flutter/material.dart';

class PrivacyAndPolicyScreen extends StatelessWidget {
  const PrivacyAndPolicyScreen({super.key});

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

  static const TextStyle _subTitleStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle _bodyTextStyle = TextStyle(
    color: Colors.black,
  );

  static const TextStyle _italicBodyTextStyle = TextStyle(
    fontStyle: FontStyle.italic,
    color: Colors.black,
  );

  static Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 5),
        child: Text(title, style: _sectionTitleStyle),
      );

  static Widget _subTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: Text(title, style: _subTitleStyle),
      );

  static Widget _paragraph(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: _bodyTextStyle),
      );

  static Widget _bullets(List<String> items) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Text('• $item', style: _bodyTextStyle),
              ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Privacy Policy', style: _headingStyle),
            const SizedBox(height: 10),
            const Text('Effective Date: November 17, 2026',
                style: _italicBodyTextStyle),
            const SizedBox(height: 5),
            const Text('App Name: Quick Jesus Reminder',
                style: _italicBodyTextStyle),
            const SizedBox(height: 5),
            const Text('Developer: Collette Global LLC',
                style: _italicBodyTextStyle),
            const SizedBox(height: 5),
            const Text('Platforms: iOS and Android',
                style: _italicBodyTextStyle),

            // 1
            _section('1. Introduction'),
            _paragraph(
                'Welcome to Quick Jesus Reminder ("QJR", "we", "our", or "us"). Your privacy is important to us. This Privacy Policy explains what information we collect, how we use it, and how we protect your information when you use the Quick Jesus Reminder mobile application on iOS and Android.'),
            _paragraph(
                'Quick Jesus Reminder provides inspirational and educational Christian quotes, daily reminders, notifications, and faith-based content intended to encourage and inspire users.'),

            // 2
            _section('2. Information We Collect'),
            _paragraph(
                'Quick Jesus Reminder can be used without creating an account by selecting "Continue without account." When using the app without an account, we do not collect account information such as your name, email address, or password.'),
            _paragraph(
                'Some features may require an account, including saving favorites, syncing information across devices, and accessing personalized functionality.'),
            _subTitle('Account Information'),
            _paragraph('If you choose to create an account, we collect:'),
            _bullets(['Name', 'Email address', 'Password']),
            _paragraph(
                'Your account information is used to create and maintain your account and provide account-related functionality. Passwords are handled using appropriate security measures and are not stored or displayed as plain text.'),
            _subTitle('User Preferences'),
            _paragraph(
                'We may collect and store preferences you select within the app in order to personalize your experience. These may include:'),
            _bullets([
              'Favorite quotes or content',
              'Notification preferences',
              'Preferred notification time',
              'App settings',
              'Content preferences',
            ]),
            _subTitle('Push Notification Preferences'),
            _paragraph(
                'If you enable notifications, Quick Jesus Reminder may store information related to your notification preferences, including your selected reminder time. This information is used to deliver motivational quotes, reminders, and other app notifications according to your preferences.'),
            _subTitle('Theme Requests'),
            _paragraph(
                'If you choose to submit a theme request, we collect the title, description, and any image you optionally select from your photo library. The image is uploaded only when you choose to attach it and is used solely to review your request.'),
            _subTitle('Device Information'),
            _paragraph(
                'We collect a device identifier, device brand and model, your device time zone, and a push notification token. This information is used to sign you in, keep your session secure, and deliver notifications at your preferred local time.'),

            // 3
            _section('3. Information We Do Not Intentionally Collect'),
            _paragraph(
                'Quick Jesus Reminder does not intentionally collect:'),
            _bullets([
              'Precise geographic location',
              'Contacts',
              'Camera recordings',
              'Microphone recordings',
              'Photos from your library, except an image you choose to attach to a theme request',
              'Advertising identifiers for behavioral advertising purposes',
            ]),
            _paragraph(
                'Quick Jesus Reminder does not use third-party advertising or tracking SDKs for behavioral advertising.'),

            // 4
            _section('4. How We Use Your Information'),
            _paragraph(
                'We use the information collected through Quick Jesus Reminder to provide and maintain the app and its features. Your information may be used to:'),
            _bullets([
              'Create and maintain your account',
              'Identify your account when you sign in',
              'Save your preferences and favorite content',
              'Sync supported information across devices',
              'Deliver notifications at your preferred time',
              'Review theme requests you submit',
              'Personalize supported app functionality',
              'Provide premium features (where applicable)',
              'Maintain app security and reliability',
              'Troubleshoot technical issues',
              'Improve app functionality and user experience',
            ]),
            _paragraph('We do not sell your personal information.'),

            // 5
            _section('5. Guest Access'),
            _paragraph(
                'Quick Jesus Reminder allows users to access certain features without creating an account through the "Continue without account" option. When using guest access, a name, email address, and password are not required.'),
            _paragraph(
                'Certain features that depend on an account, such as syncing account information or favorites across devices, may not be available in guest mode.'),

            // 6
            _section('6. Subscriptions, Payments, and Platform Availability'),
            _subTitle('Android Users (Free Access)'),
            _paragraph(
                'Quick Jesus Reminder is currently completely free to use on Android. There are no in-app purchases, paid subscriptions, or payment processing on the Android version of the app.'),
            _subTitle('iOS Users (In-App Subscriptions)'),
            _paragraph(
                'In-app purchases and auto-renewable subscriptions are available exclusively on iOS to provide access to premium features and content.'),
            _bullets([
              'All subscription purchases on iOS are processed solely through Apple\'s App Store.',
              'Subscription pricing, available plans, billing periods, and renewal information are displayed within the iOS app before a purchase is completed.',
              'Payment is charged to the user\'s Apple ID account upon confirmation of purchase.',
              'Subscriptions automatically renew unless auto-renewal is canceled in accordance with Apple\'s subscription terms.',
              'iOS users can manage or cancel their subscriptions through Apple ID → Subscriptions.',
              'Collette Global LLC does not directly collect or process payment card information.',
              'Refund requests and payment-related matters are handled according to Apple\'s App Store policies.',
            ]),

            // 7
            _section('7. Content'),
            _paragraph(
                'Quick Jesus Reminder provides Christian, motivational, inspirational, and educational quotes and reminders, including public-domain materials and content curated by our team.'),
            _paragraph(
                'This content is intended for general inspirational and educational purposes and should not be considered a substitute for professional medical, psychological, legal, financial, or other professional advice.'),

            // 8
            _section('8. Children\'s Privacy'),
            _paragraph(
                'We do not knowingly collect personal information from children under the age of 13 without appropriate authorization where required. In guest mode, users are not required to provide a name, email address, or password.'),
            _paragraph(
                'If we become aware that personal information from a child has been collected in a manner that does not comply with applicable requirements, we will take reasonable steps to remove that information.'),

            // 9
            _section('9. Data Security'),
            _paragraph(
                'We take reasonable technical and organizational measures designed to protect your information against unauthorized access, disclosure, loss, misuse, or modification. Data is transmitted over encrypted connections. However, no electronic transmission or storage system can be guaranteed to be completely secure.'),

            // 10
            _section('10. Data Retention and Deletion'),
            _paragraph(
                'We retain user information only for as long as reasonably necessary to maintain user accounts, provide app functionality, resolve technical or security issues, and comply with applicable legal obligations.'),
            _paragraph(
                'You can delete your account from the app\'s Settings screen, or request account deletion through our deletion portal at https://qjr-delete-user.web.app/'),

            // 11
            _section('11. Third-Party Services'),
            _paragraph(
                'Quick Jesus Reminder relies on services provided by Apple, Google, and other technical service providers necessary to operate the application, including:'),
            _bullets([
              'App Store purchases and auto-renewable subscriptions (iOS only)',
              'Push notification services (Apple Push Notification service and Firebase Cloud Messaging)',
              'Cloud hosting, authentication, and database infrastructure',
            ]),
            _paragraph(
                'The use of Apple or Google services may also be subject to their respective privacy policies and terms.'),

            // 12
            _section('12. Terms of Use'),
            _paragraph(
                'For iOS users, Quick Jesus Reminder uses Apple\'s Standard Terms of Use (EULA), available at: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'),

            // 13
            _section('13. Your Choices'),
            _bullets([
              'Use the app without creating an account',
              'Enable or disable push notifications',
              'Change your preferred notification time',
              'Manage your account preferences',
              'Manage or cancel your Apple subscription (iOS users)',
              'Request deletion of your account and associated data',
            ]),
            _paragraph(
                'Notification permissions can also be managed through your device\'s Settings.'),

            // 14
            _section('14. Changes to This Privacy Policy'),
            _paragraph(
                'We may update this Privacy Policy from time to time to reflect changes in our practices, features, technologies, or legal requirements. When we do, the "Effective Date" at the top of this policy will be updated.'),

            // 15
            _section('15. Contact Us'),
            _paragraph(
                'If you have any questions or concerns about this Privacy Policy, please contact us:\n\nCollette Global LLC\nEmail: adam@colletteglobal.com\nDeveloper Email: mohsinkalam79@gmail.com\n\nDeveloped with <3 by Maze Digitals'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
