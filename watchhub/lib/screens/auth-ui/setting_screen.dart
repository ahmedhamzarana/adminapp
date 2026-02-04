import 'package:flutter/material.dart';
import 'package:watchhub/utils/app_routes.dart';
import 'package:watchhub/utils/appconstant.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final List<Map<String, String>> faqList = const [
    {
      "question": "How can I track my order?",
      "answer": "Go to Order History in your profile to track all orders."
    },
    {
      "question": "What payment methods are supported?",
      "answer": "We support credit/debit cards, UPI, and net banking."
    },
    {
      "question": "How can I return a product?",
      "answer": "You can request a return from Order History within 7 days of delivery."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Appconstant.barcolor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------------- Preferences ----------------
          _sectionTitle("Preferences"),
          _switchTile(
            icon: Icons.notifications_outlined,
            title: "Notifications",
            value: true, // placeholder, integrate Provider if needed
            onChanged: (val) {},
          ),


          const SizedBox(height: 24),

          // ---------------- Help & Support ----------------
          _sectionTitle("Help & Support"),
          _navTile(
            icon: Icons.question_answer_outlined,
            title: "FAQ",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => FAQScreen(faqList: faqList)));
            },
          ),
          _navTile(
            icon: Icons.chat_outlined,
            title: "Contact Support",
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.contactSupportRoute);
            },
          ),

          const SizedBox(height: 30),
          Center(
            child: Text(
              "App Version 1.0.0",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SwitchListTile(
        secondary: Icon(icon, color: Appconstant.appmaincolor),
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _navTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: Appconstant.appmaincolor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// ================= FAQ SCREEN =================

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqList;

  const FAQScreen({super.key, required this.faqList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        title: const Text(
          "FAQ",
          style: TextStyle(color: Appconstant.barcolor),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return ExpansionTile(
            title: Text(
              faq['question']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(faq['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}
