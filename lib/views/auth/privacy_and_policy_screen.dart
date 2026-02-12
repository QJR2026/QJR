// // import 'package:flutter/material.dart';
// // import '/extensions/size_box_extension.dart';

// // import '../widgets/custom_back_button.dart';

// // class PrivacyAndPolicyScreen extends StatelessWidget {
// //   const PrivacyAndPolicyScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         // Use SafeArea to avoid overlapping with system UI
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               40.vSpace(),
// //               const CustomBackButton(),
// //               30.vSpace(),
// //               const Text(
// //                 'Privacy Policy',
// //                 style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
// //               ),
// //               20.vSpace(),
// //               Expanded(
// //                 child: SingleChildScrollView(
// //                   child: Text(
// //                     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' *
// //                         4,
// //                     style: const TextStyle(
// //                         fontSize: 15, fontWeight: FontWeight.w400),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// class PrivacyAndPolicyScreen extends StatelessWidget {
//   const PrivacyAndPolicyScreen({super.key});

//   // Define common TextStyles as static const variables
//   static const TextStyle _headingStyle = TextStyle(
//     fontSize: 24,
//     fontWeight: FontWeight.bold,
//     color: Colors.black,
//   );

//   static const TextStyle _sectionTitleStyle = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//     color: Colors.black,
//   );

//   static const TextStyle _bodyTextStyle = TextStyle(
//     color: Colors.black,
//   );

//   static const TextStyle _italicBodyTextStyle = TextStyle(
//     fontStyle: FontStyle.italic,
//     color: Colors.black,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Privacy Policy'),
//       ),
//       body: const SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Privacy Policy',
//               style: _headingStyle,
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Effective Date: July 14, 2025',
//               style: _italicBodyTextStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'App Name: Quick Jesus Reminder',
//               style: _italicBodyTextStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'Developer: Collette Global LLC',
//               style: _italicBodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text(
//               '1. Introduction',
//               style: _sectionTitleStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'Welcome to Quick Jesus Reminder ("QJR", "we", "our", or "us"). Your privacy is important to us, and we are committed to protecting it. This Privacy Policy outlines how we handle your information when you use our mobile application, available on iOS.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),

//             // --- UPDATED SECTION 2 ---
//             Text(
//               '2. Information We Collect',
//               style: _sectionTitleStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'When you register for an account and use Quick Jesus Reminder, we collect the following information:',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               '• **Account Information:** When you create an account, we collect your email address and a password. Your password is stored in an encrypted or hashed format.',
//               style: _bodyTextStyle,
//             ),
//             Text(
//               '• **User Preferences:** We collect information about your preferences within the app to personalize your experience.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 10),
//             Text(
//               'We do NOT collect other personal information such as your name, location, contacts, camera, microphone, or photo library. We also do not use third-party advertising or tracking SDKs.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             // --- END UPDATED SECTION 2 ---

//             Text(
//               '3. Use of Content',
//               style: _sectionTitleStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'All quotes and daily reminders presented in the app are either in the public domain or curated by our editorial team for inspirational and educational purposes. The content is provided to uplift and encourage users in their daily lives.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text(
//               '4. Children’s Privacy',
//               style: _sectionTitleStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'We do not knowingly collect or solicit personal information from anyone, including children under the age of 13. Our app is designed to be safe and appropriate for all age groups.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),

//             // --- UPDATED SECTION 5 ---
//             Text(
//               '5. Data Security',
//               style: _sectionTitleStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'We are committed to protecting the information you provide to us. We store your email address and encrypted password on secure servers and implement reasonable technical and organizational measures designed to protect your data from unauthorized access, use, or disclosure. We ensure that the app is built using secure development practices to protect your experience and maintain reliability.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             // --- END UPDATED SECTION 5 ---

//             Text(
//               '6. Changes to This Privacy Policy',
//               style: _sectionTitleStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'We may update this Privacy Policy from time to time to reflect changes in our practices, technologies, or legal obligations. When we do, the "Effective Date" at the top of this policy will be updated.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text(
//               '7. Subscriptions',
//               style: _sectionTitleStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'Quick Jesus Reminder operates on a subscription model to provide you with continuous access to its features and content. Payments for subscriptions are processed securely.\n',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text(
//               '8. Contact Us',
//               style: _sectionTitleStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'If you have any questions or concerns about this Privacy Policy, please feel free to contact us:\n\nCollette Global LLC\nEmail: adam@colletteglobal.com\nDeveloper Email: mohsinkalam79@gmail.com\n\nDeveloped with <3 by Maze Digitals',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }

// after no subscription

// import 'package:flutter/material.dart';

// class PrivacyAndPolicyScreen extends StatelessWidget {
//   const PrivacyAndPolicyScreen({super.key});

//   static const TextStyle _headingStyle = TextStyle(
//     fontSize: 24,
//     fontWeight: FontWeight.bold,
//     color: Colors.black,
//   );

//   static const TextStyle _sectionTitleStyle = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//     color: Colors.black,
//   );

//   static const TextStyle _bodyTextStyle = TextStyle(
//     color: Colors.black,
//   );

//   static const TextStyle _italicBodyTextStyle = TextStyle(
//     fontStyle: FontStyle.italic,
//     color: Colors.black,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Privacy Policy'),
//       ),
//       body: const SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Privacy Policy', style: _headingStyle),
//             SizedBox(height: 10),
//             Text(
//               'Effective Date: August 04, 2025',
//               style: _italicBodyTextStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'App Name: Quick Jesus Reminder',
//               style: _italicBodyTextStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               'Developer: Collette Global LLC',
//               style: _italicBodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text('1. Introduction', style: _sectionTitleStyle),
//             SizedBox(height: 5),
//             Text(
//               'Welcome to Quick Jesus Reminder ("QJR", "we", "our", or "us"). Your privacy is important to us, and we are committed to protecting it. This Privacy Policy outlines how we handle your information when you use our mobile application, available on iOS.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text('2. Information We Collect', style: _sectionTitleStyle),
//             SizedBox(height: 5),
//             Text(
//               'When you register for an account and use Quick Jesus Reminder, we collect the following information:',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 5),
//             Text(
//               '• Account Information: When you create an account, we collect your email address and a password. Your password is stored in an encrypted or hashed format.',
//               style: _bodyTextStyle,
//             ),
//             Text(
//               '• User Preferences: We collect information about your preferences within the app to personalize your experience.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 10),
//             Text(
//               'We do NOT collect other personal information such as your name, location, contacts, camera, microphone, or photo library. We also do not use third-party advertising or tracking SDKs.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text('3. Use of Content', style: _sectionTitleStyle),
//             SizedBox(height: 5),
//             Text(
//               'All quotes and daily reminders presented in the app are either in the public domain or curated by our editorial team for inspirational and educational purposes. The content is provided to uplift and encourage users in their daily lives.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text('4. Children’s Privacy', style: _sectionTitleStyle),
//             SizedBox(height: 5),
//             Text(
//               'We do not knowingly collect or solicit personal information from anyone, including children under the age of 13. Our app is designed to be safe and appropriate for all age groups.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text('5. Data Security', style: _sectionTitleStyle),
//             SizedBox(height: 5),
//             Text(
//               'We are committed to protecting the information you provide to us. We store your email address and encrypted password on secure servers and implement reasonable technical and organizational measures designed to protect your data from unauthorized access, use, or disclosure. We ensure that the app is built using secure development practices to protect your experience and maintain reliability.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text('6. Changes to This Privacy Policy',
//                 style: _sectionTitleStyle),
//             SizedBox(height: 5),
//             Text(
//               'We may update this Privacy Policy from time to time to reflect changes in our practices, technologies, or legal obligations. When we do, the "Effective Date" at the top of this policy will be updated.',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 20),
//             Text('7. Contact Us', style: _sectionTitleStyle),
//             SizedBox(height: 5),
//             Text(
//               'If you have any questions or concerns about this Privacy Policy, please feel free to contact us:\n\nCollette Global LLC\nEmail: adam@colletteglobal.com\nDeveloper Email: mohsinkalam79@gmail.com\n\nDeveloped with <3 by Maze Digitals',
//               style: _bodyTextStyle,
//             ),
//             SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }

//after continue without login add
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

  static const TextStyle _bodyTextStyle = TextStyle(
    color: Colors.black,
  );

  static const TextStyle _italicBodyTextStyle = TextStyle(
    fontStyle: FontStyle.italic,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        forceMaterialTransparency: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy', style: _headingStyle),
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
            Text('1. Introduction', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'Welcome to Quick Jesus Reminder ("QJR", "we", "our", or "us"). Your privacy is important to us, and we are committed to protecting it. This Privacy Policy outlines how we handle your information when you use our mobile application, available on iOS.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),
            Text('2. Information We Collect', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'You may use the app anonymously by choosing the "Continue without account" option. In this case, no personal information such as email or password is collected. However, you will not be able to use features such as syncing favorites or receiving personalized notifications.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 10),
            Text(
              'When you register for an account and use Quick Jesus Reminder, we collect the following information:',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 5),
            Text(
              '• Account Information: When you create an account, we collect your email address and a password. Your password is stored in an encrypted or hashed format.',
              style: _bodyTextStyle,
            ),
            Text(
              '• User Preferences: We collect information about your preferences within the app to personalize your experience.',
              style: _bodyTextStyle,
            ),
            Text(
              '• Push Notification Preferences: If you opt in to receive daily reminders or motivational quotes, we store your notification settings. These are not linked to your identity and are only used to deliver content at your preferred time.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 10),
            Text(
              'We do NOT collect other personal information such as your name, location, contacts, camera, microphone, or photo library. We also do not use third-party advertising or tracking SDKs.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),
            Text('3. Use of Content', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'All quotes and daily reminders presented in the app are either in the public domain or curated by our editorial team for inspirational and educational purposes. The content is provided to uplift and encourage users in their daily lives.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),
            Text('4. Children’s Privacy', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'We do not knowingly collect or solicit personal information from anyone, including children under the age of 13. Our app is designed to be safe and appropriate for all age groups.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 5),
            Text(
              'If a user under the age of 13 uses the app in anonymous mode, we do not collect any personally identifiable information. Push notifications, if enabled, are generic and do not track or identify users.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),
            Text('5. Data Security', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'We are committed to protecting the information you provide to us. We store your email address and encrypted password on secure servers and implement reasonable technical and organizational measures designed to protect your data from unauthorized access, use, or disclosure. We ensure that the app is built using secure development practices to protect your experience and maintain reliability.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),
            Text('6. Changes to This Privacy Policy',
                style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'We may update this Privacy Policy from time to time to reflect changes in our practices, technologies, or legal obligations. When we do, the "Effective Date" at the top of this policy will be updated.',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 20),
            Text('7. Contact Us', style: _sectionTitleStyle),
            SizedBox(height: 5),
            Text(
              'If you have any questions or concerns about this Privacy Policy, please feel free to contact us:\n\nCollette Global LLC\nEmail: adam@colletteglobal.com\nDeveloper Email: mohsinkalam79@gmail.com\n\nDeveloped with <3 by Maze Digitals',
              style: _bodyTextStyle,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
