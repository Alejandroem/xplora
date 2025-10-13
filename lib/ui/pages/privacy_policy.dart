import 'package:flutter/material.dart';

import '../../theme.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/gradient_background.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Privacy Policy',
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy\nXPLRA App - Privacy Policy',
                style: h2Style.copyWith(color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                'Effective Date: September, 8. 2024',
                style: bodyTextStyle.copyWith(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'XPLRA, LLC is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use the XPLRA mobile app. By using the App, you agree to the collection and use of information in accordance with this Privacy Policy.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '1. Information We Collect',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'a. Personal Information',
                style: h3Style.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              Text(
                'When you register an account or use the XPLRA app, we may collect the following personal information:',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              Text(
                '- Name\n- Email address\n- Phone number (optional)\n- Location data (when you use location-based features)\n- Profile information (such as photos, DOB or interests, if provided)',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'b. Non-Personal Information',
                style: h3Style.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              Text(
                'We may collect non-personal information about your interaction with the App:',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              Text(
                '- Device Information: Device type, operating system, unique device identifiers, IP address.\n- Usage Information: How you use the App, including the features you use, time spent, and pages visited.\n- Location Data: With your consent, we may collect precise location data to offer location-based services and quests.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'c. Information from Third-Party Services',
                style: h3Style.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              Text(
                'If you choose to link your XPLRA account with third-party services such as social media platforms (e.g., Facebook, Google), we may collect your profile information from these services, including your username, email address, and profile picture.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '2. How We Use Your Information',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              Text(
                'We use the information we collect for the following purposes:',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              Text(
                '- To Provide and Improve the App: Ensuring the App functions properly, personalizing your experience, and offering new features.\n- To Offer Rewards and Incentives: Tracking quests, points, and rewards to deliver personalized incentives.\n- To Communicate with You: Sending account updates, promotional emails, and responding to your inquiries.\n- To Enhance User Experience: Using analytics to understand user behavior and preferences, which helps us improve the App.\n- For Security and Fraud Prevention: Monitoring, investigating, and preventing fraudulent activities and ensuring the security of your account.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '3. How We Share Your Information',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              Text(
                'We do not sell your personal information. However, we may share your information with:',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              Text(
                '- Service Providers: Third-party vendors who help us provide, maintain, and improve the App (e.g., hosting services, analytics providers, payment processors).\n- Business Partners: With local businesses, tourism boards, or event organizers for the purpose of creating quests, offering rewards, or providing services you may be interested in.\n- Legal Requirements: We may disclose your information if required to do so by law or in response to valid requests by public authorities (e.g., a court or government agency).\n- Business Transfers: In the event of a merger, acquisition, or sale of assets, your information may be transferred as part of the transaction.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '4. Data Retention',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              Text(
                'We retain your personal information for as long as necessary to fulfill the purposes for which it was collected or as required by law. If you request deletion of your account, we will delete your personal data unless we are required to retain it for legal reasons.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '5. Your Privacy Choices',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              Text(
                'a. Access and Update Your Information',
                style: h3Style.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              Text(
                'You can access, update, or delete your personal information by logging into your account or contacting us at xplrapr@gmail.com',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'b. Location Data',
                style: h3Style.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              Text(
                'You can enable or disable location services at any time through your device settings. However, disabling location services may limit certain features of the App, such as location-based quests and rewards.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'c. Marketing Communications',
                style: h3Style.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              Text(
                'You can opt out of receiving promotional emails by following the unsubscribe instructions in those emails or by adjusting your account settings.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'd. Account Deletion',
                style: h3Style.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              Text(
                'If you wish to delete your XPLRA account, please contact us at xplrapr@gmail.com, and we will take necessary steps to delete your information, subject to any legal retention obligations.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '6. Security of Your Information',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              Text(
                'We take reasonable measures to protect your personal information from unauthorized access, use, or disclosure. However, no method of transmission over the internet or electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your personal information, we cannot guarantee its absolute security.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '7. Children\'s Privacy',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              Text(
                'The XPLRA app is not intended for use by individuals under the age of 13. If we become aware that we have collected personal data from children without verification of parental consent, we will take steps to delete such information. If you believe we may have collected information from a child under 13, please contact us at [xplrapr@gmail.com].',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '8. International Data Transfers',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              Text(
                'XPLRA is based in Puerto Rico, and the information we collect may be transferred to, stored, or processed in other countries. By using the App, you consent to the transfer of your information to countries outside your residence, which may have different data protection rules.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '9. Your Rights Under GDPR and CCPA',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              Text(
                'If you are located in the European Economic Area (EEA) or California, you have certain rights regarding your personal information:',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'a. GDPR Rights (For EU Users)',
                style: h3Style.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              Text(
                '- Access: You have the right to request a copy of the personal data we hold about you.\n- Rectification: You can request correction of inaccurate or incomplete data.\n- Erasure: You can request the deletion of your personal data under certain circumstances.\n- Restriction of Processing: You can request to limit how we use your data.\n- Data Portability: You have the right to request your personal data in a structured, commonly used, and machine-readable format.\n- Objection: You have the right to object to the processing of your personal data for certain purposes.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'b. CCPA Rights (For California Users)',
                style: h3Style.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              Text(
                '- Access: You have the right to request disclosure of the categories and specific pieces of personal information collected about you.\n- Deletion: You have the right to request the deletion of your personal information.\n- Opt-Out: You have the right to opt out of the sale of your personal information, though we do not sell personal information.\n- Non-Discrimination: You have the right not to receive discriminatory treatment for exercising your privacy rights.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                'To exercise any of these rights, please contact us at [xplrapr@gmail.com].',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '10. Changes to This Privacy Policy',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              Text(
                'We may update this Privacy Policy from time to time. When we make changes, we will revise the "Effective Date" at the top of this policy. We encourage you to review this Privacy Policy periodically to stay informed about how we are protecting your information.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                '11. Contact Us',
                style: h3Style.copyWith(fontSize: 20, color: textPrimary),
              ),
              Text(
                'If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at:',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
              Text(
                '[xplrapr@gmail.com]',
                style: bodyTextStyle.copyWith(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'By using the XPLRA app, you agree to the terms of this Privacy Policy.',
                style: bodyTextStyle.copyWith(fontSize: 16, color: textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
