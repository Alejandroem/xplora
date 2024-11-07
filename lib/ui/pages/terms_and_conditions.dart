import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'XPLRA App - Terms and Conditions',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Last Updated: September 8, 2024',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to the XPLRA mobile app. These Terms and Conditions govern your use of the XPLRA app and any services provided through the App. By accessing or using the App, you agree to be bound by these Terms. If you do not agree with these Terms, please do not use the App.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('1. Acceptance of Terms'),
            _buildSectionContent(
                'By downloading, installing, or using the XPLRA app, you agree to these Terms and our Privacy Policy. These Terms apply to all users of the App, including visitors, registered users, and others who access or use the App.'),
            _buildSectionTitle('2. Eligibility'),
            _buildSectionContent(
                'You must be at least 13 years old to use the XPLRA app. If you are between the ages of 13 and 18, you must have your parent or legal guardian’s permission to use the App.'),
            _buildSectionTitle('3. User Account'),
            _buildSectionContent(
                '- Account Creation: To access certain features of the App, you may be required to create an account. You agree to provide accurate, current, and complete information during the registration process.\n\n- Account Security: You are responsible for maintaining the confidentiality of your account login information. You agree to notify XPLRA immediately of any unauthorized use of your account.'),
            _buildSectionTitle('4. Use of the App'),
            _buildSectionContent(
                '- License: XPLRA grants you a limited, non-exclusive, non-transferable, revocable license to use the App for your personal, non-commercial use.\n\n- Restrictions: You agree not to:\n  - Modify, copy, or create derivative works based on the App.\n  - Use the App for any unlawful purpose.\n  - Attempt to gain unauthorized access to the App or its systems.\n  - Engage in any activity that interferes with or disrupts the App.'),
            _buildSectionTitle('5. Quests, Rewards, and Points System'),
            _buildSectionContent(
                '- Quests: The App provides users with quests and challenges that can be completed for rewards. The availability of quests and challenges may vary based on location and time.\n\n- Points: Users can earn points by completing quests and activities. Points have no cash value and cannot be exchanged for cash. XPLRA reserves the right to change the point system, rewards, and eligibility criteria at any time without notice.\n\n- Expiration: Points may expire if not used within a specified time period, as indicated in the App.'),
            _buildSectionTitle('6. In-App Purchases'),
            _buildSectionContent(
                'The App may offer in-app purchases for additional features, collectibles, or other items. All purchases are final and non-refundable, except as required by law.'),
            _buildSectionTitle('7. Content'),
            _buildSectionContent(
                '- User-Generated Content: Users may submit, upload, or post content such as photos, reviews, and comments. By submitting User Content, you grant XPLRA a non-exclusive, worldwide, royalty-free license to use, reproduce, modify, and distribute the content for promotional and marketing purposes.\n\n- Content Guidelines: You agree not to post any content that is unlawful, harmful, threatening, abusive, harassing, defamatory, vulgar, obscene, or otherwise objectionable.'),
            _buildSectionTitle('8. Third-Party Links'),
            _buildSectionContent(
                'The App may contain links to third-party websites or services that are not owned or controlled by XPLRA. XPLRA has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third-party websites or services.'),
            _buildSectionTitle('9. Privacy Policy'),
            _buildSectionContent(
                'Your use of the App is also governed by our [Privacy Policy] [Insert Link], which explains how we collect, use, and disclose your information.'),
            _buildSectionTitle('10. Termination'),
            _buildSectionContent(
                'XPLRA reserves the right to terminate or suspend your account and access to the App at any time, without notice, for any reason, including, but not limited to, a breach of these Terms. Upon termination, your right to use the App will immediately cease.'),
            _buildSectionTitle('11. Disclaimer of Warranties'),
            _buildSectionContent(
                'The XPLRA app is provided "as is" and "as available" without warranties of any kind, either express or implied. XPLRA does not warrant that:\n- The App will function uninterrupted or error-free.\n- The App will be free from viruses or other harmful components.\n- The results obtained from the use of the App will be accurate or reliable.'),
            _buildSectionTitle('12. Limitation of Liability'),
            _buildSectionContent(
                'To the fullest extent permitted by applicable law, XPLRA, its officers, directors, employees, or agents shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including, without limitation, loss of profits, data, use, or goodwill, arising out of or related to your use of the App.'),
            _buildSectionTitle('13. Indemnification'),
            _buildSectionContent(
                'You agree to defend, indemnify, and hold harmless XPLRA and its affiliates from and against any claims, damages, liabilities, losses, or expenses arising from:\n- Your use of the App.\n- Your violation of these Terms.\n- Your violation of any third-party rights.'),
            _buildSectionTitle('14. Changes to Terms'),
            _buildSectionContent(
                'XPLRA reserves the right to modify these Terms at any time. We will provide notice of any changes by posting the updated Terms within the App or by other appropriate means. Your continued use of the App after such changes constitutes your acceptance of the new Terms.'),
            _buildSectionTitle('15. Governing Law'),
            _buildSectionContent(
                'These Terms shall be governed and construed in accordance with the laws of [Insert Jurisdiction], without regard to its conflict of law provisions.'),
            _buildSectionTitle('16. Dispute Resolution'),
            _buildSectionContent(
                'Any disputes arising out of or in connection with these Terms shall be resolved through arbitration in accordance with the rules of [Arbitration Institution], and the location of arbitration will be Puerto Rico.'),
            _buildSectionTitle('17. Contact Information'),
            _buildSectionContent(
                'If you have any questions about these Terms, please contact us at:\nxplrapr@gmail.com'),
            const SizedBox(height: 20),
            const Text(
              'Acceptance of Terms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'By using the XPLRA app, you acknowledge that you have read, understood, and agree to these Terms and Conditions.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 16),
    );
  }
}
