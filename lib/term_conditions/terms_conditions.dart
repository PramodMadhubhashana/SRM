import 'package:flutter/material.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 30,
            right: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terms and Conditions",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Last updated : 08/09/2024",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Welcome to the Smart Resource Management App. By downloading, installing, accessing, or using our mobile and web applications, you agree to comply with and be bound by the following terms and conditions. Please read them carefully.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "1. Acceptance of Terms",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "By accessing or using our services, you agree to be bound by these Terms and Conditions, including any changes that may be made from time to time. If you do not agree to these terms, you must immediately stop using our services.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "2. Use of the App",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "The Smart Resource Management app is designed to assist users in effectively managing and optimizing resources such as time, materials, and workforce. The following conditions apply to your use of the app:",
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "• You must be NIBM Student to use the app.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "• You agree to use the app only for lawful purposes.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "• You are responsible for maintaining the confidentiality of your login information and for any activity that occurs under your account.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "3. User Accounts",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "To use certain features of the app, you may be required to create an account and provide information about yourself. You agree to:",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "• Provide accurate and complete information.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "•  Maintain the security of your password and account.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "• Notify us immediately of any unauthorized use of your account.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "• Take full responsibility for any activities that occur under your account.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "4. Privacy Policy",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Your privacy is important to us. Please review our Privacy Policy [insert link] for information on how we collect, use, and disclose information from our users.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "5. Intellectual Property Rights",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "All content and materials available on the Smart Resource Management app, including but not limited to text, graphics, logos, icons, images, and software, are the property of [Your Company] and are protected by applicable intellectual property laws.\n\nYou are granted a limited license to access and use the app for personal or business resource management purposes only. Any unauthorized use or reproduction of content from the app is prohibited.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "6. Prohibited Activities",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              Text(
                "You agree not to:\n• Use the app for any illegal or unauthorized purpose.\n• Reverse-engineer, decompile, or attempt to extract the source code from the app.\n• Interfere with or disrupt the app's services, servers, or networks.\n• Violate any applicable local, state, or international law.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "7. Limitation of Liability",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'We provide the app on an "as is" and "as available" basis. You understand and agree that [Your Company] will not be held liable for any indirect, incidental, special, consequential, or punitive damages resulting from:',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "• The use or inability to use the app.\n• Unauthorized access to or alteration of your data.\n• Any other matters related to the app.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "8. Termination",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "We reserve the right to terminate or suspend your access to the app at any time, without notice, for conduct that we believe violates these terms or is harmful to other users, us, or third parties, or for any other reason.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "9. Modifications to the App",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "We reserve the right to modify, update, or discontinue the app (or any part of it) at any time without notice. You agree that we shall not be liable to you or any third party for any modification, suspension, or discontinuation of the app.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "10. Governing Law",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "These terms and conditions are governed by and construed in accordance with the laws of [Your Country], without regard to its conflict of law principles. You agree to submit to the jurisdiction of the courts located in [Your Location] for the resolution of any disputes.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "11. Contact Us",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "If you have any questions about these Terms and Conditions, please contact us at:\n\n\n Phone : 0712839087",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
